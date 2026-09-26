"""Extract successfully cached source bytes without treating HTML as a PDF."""
import csv, json
from pathlib import Path
from html.parser import HTMLParser
from pypdf import PdfReader

class TextParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.hidden = 0
        self.parts = []
    def handle_starttag(self, tag, attrs):
        if tag in ('script', 'style'):
            self.hidden += 1
    def handle_endtag(self, tag):
        if tag in ('script', 'style') and self.hidden:
            self.hidden -= 1
    def handle_data(self, data):
        if not self.hidden and data.strip():
            self.parts.append(data.strip())

packet = Path(__file__).parent
rows = []
for r in csv.DictReader((packet / 'cache_status.csv').open(encoding='utf-8-sig')):
    if r['status'] != 'cached':
        continue
    p = Path(r['path'])
    if p.suffix == '.csv':
        rows.append({'id': r['id'], 'detected': 'csv', 'extension_mismatch': False,
                     'note': 'Structured public records; see the selected IRS JSON rows.'})
        continue
    data = p.read_bytes()
    is_pdf = data.startswith(b'%PDF-')
    if is_pdf:
        content = '\n\n'.join(f'PAGE {i+1}\n{page.extract_text() or ""}'
                              for i, page in enumerate(PdfReader(p).pages))
    else:
        parser = TextParser()
        parser.feed(data.decode('utf-8', errors='replace'))
        content = '\n'.join(parser.parts)
    (packet / (r['id'] + '.txt')).write_text(content, encoding='utf-8')
    rows.append({'id': r['id'], 'detected': 'pdf' if is_pdf else 'html',
                 'extension_mismatch': p.suffix == '.pdf' and not is_pdf,
                 'characters': len(content)})
(packet / 'extraction_status.json').write_text(json.dumps(rows, indent=2), encoding='utf-8')
print(f'Processed {len(rows)} cached sources; {sum(r["extension_mismatch"] for r in rows)} extension mismatches')
