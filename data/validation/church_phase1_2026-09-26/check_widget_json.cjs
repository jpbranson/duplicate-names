const fs=require('fs'); const html=fs.readFileSync('posts/duplicate-church-names/embeds/first-baptist.html','utf8');
const scripts=[...html.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/g)].filter(m=>m[1].includes('application/json'));
for(const s of scripts){try{JSON.parse(s[2]); console.log('JSON valid',s[2].length);}catch(e){process.exitCode=1;console.log(e.message);const pos=Number(e.message.match(/position (\d+)/)?.[1]);console.log(s[2].slice(pos-140,pos+140));}}

