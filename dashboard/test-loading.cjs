// Reproduce a scope change while a collection fetch is pending, without a network.
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
class Element {
  constructor(){this.value='';this.textContent='';this.children=[];this.listeners={};this.hidden=false;this.disabled=false;}
  addEventListener(event,fn){this.listeners[event]=fn;}
  append(...nodes){this.children.push(...nodes);}
  replaceChildren(...nodes){this.children=nodes;}
  setAttribute(){}
  change(value){this.value=value;return this.listeners.change();}
}
const elements=new Map(),pending=new Map();
const element=id=>{if(!elements.has(id))elements.set(id,new Element());return elements.get(id);};
const fetch=url=>new Promise((resolve,reject)=>pending.set(url.split('?')[0],{resolve,reject}));
const context=vm.createContext({document:{getElementById:element,createElement:()=>new Element(),querySelectorAll:()=>[]},
  fetch,Response:class {constructor(body){this.body=body;}async json(){return this.body.data;}},
  DecompressionStream:class {},URL:{revokeObjectURL(){}},console,Map,Set,Number,String,Error,Promise});
const flush=()=>new Promise(resolve=>setImmediate(resolve));
function deliver(path,data){const call=pending.get(path);assert(call,`Request missing: ${path}`);call.resolve({ok:true,json:async()=>data,body:{pipeThrough:()=>({data})}});}
(async()=>{
  vm.runInContext(fs.readFileSync(__dirname+'/app.js','utf8'),context);
  deliver('data/manifest.json',{built_utc:'test',overture_release:'test'});await flush();
  element('category').change('churches');
  element('scope').change('all');
  element('search').value='held tabernacle';element('search').listeners.input();
  const record=['test-id','Held Tabernacle','held tabernacle','held tabernacle',-80,25,'',false,'pending','unknown','overture','test-source','outside_christian_scope_source_review','',16];
  deliver('data/churches-l3-index.json.gz',[['held tabernacle','ab',0,0,0,1]]);await flush();
  deliver('data/churches-l3-ab.json.gz',[record]);await flush();
  assert.equal(element('selected-name').textContent,'held tabernacle');
  assert.match(element('selected-summary').textContent,/1 records .* 1 holds/);
  assert.equal(element('download').disabled,false);
  // A stale failure from the previous collection must not replace the good view.
  pending.get('data/museums-l2-index.json.gz').reject(Error('obsolete request failure'));await flush();
  assert.match(element('status').textContent,/Showing 1 records/);
  element('scope').change('eligible');await flush();
  assert.equal(element('selected-name').textContent,'Choose a name');
  assert.equal(element('download').disabled,true);
  assert.equal(element('table-caption').textContent,'No records selected.');
  console.log('7 asynchronous collection/scope assertions passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
