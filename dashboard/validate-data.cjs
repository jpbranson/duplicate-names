// Validate serialized payloads independently of the R exporter.
const fs=require('node:fs'),path=require('node:path'),zlib=require('node:zlib'),assert=require('node:assert/strict');
const {F,makeIndex}=require('./app.js');const folder=path.join(__dirname,'data');
const read=name=>JSON.parse(zlib.gunzipSync(fs.readFileSync(path.join(folder,name))).toString('utf8'));
const manifest=JSON.parse(fs.readFileSync(path.join(folder,'manifest.json'),'utf8'));
assert.equal(manifest.publication_ready,false);assert.equal(manifest.osm_data_included,false);
const checks=[];
for(const category of ['museums','churches'])for(const level of ['l2','l3']){
  const index=read(`${category}-${level}-index.json.gz`),expected=new Map(index.map(g=>[g[0],g]));
  assert.equal(expected.size,index.length);const ids=new Set();let total=0,eligible=0,aliases=0,verified=0;
  for(const bucket of new Set(index.map(g=>g[1]))){
    const rows=read(`${category}-${level}-${bucket}.json.gz`);
    for(const r of rows){assert.equal(r.length,15);assert(!ids.has(r[F.id]));ids.add(r[F.id]);assert.equal(typeof r[F.eligible],'boolean');assert(Number.isFinite(r[F.lon])&&Math.abs(r[F.lon])<=180);assert(Number.isFinite(r[F.lat])&&Math.abs(r[F.lat])<=90);assert(['affiliated','independent','unknown'].includes(r[F.aff]));assert.notEqual(r[F.source],'osm');if(category==='churches')assert.equal(r[F.source],'overture');total++;eligible+=r[F.eligible]?1:0;aliases+=r[F.aliases]?1:0;verified+=r[F.review]==='verified'?1:0;}
    for(const g of makeIndex(rows,level)){const e=expected.get(g[0]);assert(e,`Group absent: ${g[0]}`);assert.equal(e[1],bucket);assert.deepEqual(g.slice(2),e.slice(2));expected.delete(g[0]);}
  }
  assert.equal(expected.size,0);const m=manifest.collections[category];assert.equal(total,m.records);assert.equal(eligible,m.eligible);assert.equal(aliases,m.aliases);assert.equal(verified,m.verified);
  checks.push({category,level,records:total,groups:index.length,eligible,aliases,verified,status:'passed'});
}
const states=read('states.geojson.gz');assert.equal(states.type,'FeatureCollection');assert.equal(states.features.length,51);
const report={status:'passed',publication_ready:false,checks,states:51,remote_tiles:false};
const evidence=process.env.DUPNAMES_DASHBOARD_EVIDENCE||path.join(__dirname,'../data/processed/dashboard_validation');
fs.mkdirSync(evidence,{recursive:true});
fs.writeFileSync(path.join(evidence,'serialized_payload_checks.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
