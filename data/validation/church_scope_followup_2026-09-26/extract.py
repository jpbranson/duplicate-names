from pathlib import Path
from html.parser import HTMLParser
import csv,json,re
class Extract(HTMLParser):
 def __init__(self): super().__init__(); self.parts=[]; self.links=[]; self.skip=0
 def handle_starttag(self,tag,attrs):
  if tag in ('script','style'): self.skip+=1
  if tag=='a':
   href=dict(attrs).get('href','')
   if href: self.links.append(href)
  if tag in ('p','br','div','h1','h2','h3','li','tr','td'): self.parts.append('\n')
 def handle_endtag(self,tag):
  if tag in ('script','style'): self.skip=max(0,self.skip-1)
 def handle_data(self,data):
  if not self.skip: self.parts.append(data)
p=Path('data/validation/church_scope_followup_2026-09-26')
for row in csv.DictReader((p/'cache_status.csv').open(encoding='utf-8-sig')):
 if row['status']!='cached': continue
 x=Extract();x.feed(Path(row['path']).read_text(encoding='utf-8',errors='replace'))
 text='\n'.join(re.sub(r'\s+',' ',s).strip() for s in ''.join(x.parts).splitlines() if s.strip())
 (p/(row['id']+'_text.txt')).write_text(text,encoding='utf-8')
 (p/(row['id']+'_links.json')).write_text(json.dumps(sorted(set(x.links)),indent=2),encoding='utf-8')
