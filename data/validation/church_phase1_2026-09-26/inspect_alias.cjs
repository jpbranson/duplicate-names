const fs=require('fs'); const {parseCSV}=require('../../../dashboard/app.js');
const rows=parseCSV(fs.readFileSync('posts/duplicate-church-names/payload/first-baptist-map.csv','utf8'));
for(const r of rows.filter(r=>r.some(v=>v.includes('First Baptist Children'))))console.log(JSON.stringify(r));
const html=fs.readFileSync('posts/duplicate-church-names/embeds/first-baptist.html','utf8');const i=html.indexOf('First Baptist Children');console.log(JSON.stringify(html.slice(i-60,i+180)));
