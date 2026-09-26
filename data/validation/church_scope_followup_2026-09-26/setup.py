from pathlib import Path
import json
p=Path('data/validation/church_scope_followup_2026-09-26')
old=Path('data/validation/church_ordinal_review_2026-09-26')
cache=(old/'cache_sources.R').read_text().replace('church_ordinal_review','church_scope_followup')
(p/'cache_sources.R').write_text(cache)
sources=[
 ('net_home','https://www.cogasoc.net/'),
 ('net_locations','https://www.cogasoc.net/locations-1'),
 ('cogsoc_home','https://cogsoconline.org/'),
 ('cogsoc_about','https://cogsoconline.org/about'),
 ('newhaven_home','https://churchofgod1931.org/'),
 ('hyattsville_home','https://www.cogasochyattsville.com/'),
 ('wilmington_home','https://wilmington.cogasoc.org/'),
 ('wilmington_history','https://wilmington.cogasoc.org/history-of-the-tabernacle/'),
 ('detroit_home','https://detroit.cogasoc.org/'),
 ('detroit_history','https://detroit.cogasoc.org/history-of-the-tabernacle/'),
 ('newark_home','https://newark.cogasoc.org/'),
 ('newark_history','https://newark.cogasoc.org/history-of-the-tabernacle/'),
 ('cincinnati_home','https://cincinnati.cogasoc.org/'),
 ('richmond_home','https://richmond.cogasoc.org/'),
 ('jacksonville_home','https://jacksonville.cogasoc.org/'),
 ('baltimore_home','https://baltimore.cogasoc.org/'),
 ('charlotte_home','https://charlotte.cogasoc.org/'),
 ('washington_home','https://washingtondc.cogasoc.org/'),
 ('atlanticcity_home','https://atlanticcity.cogasoc.org/'),
 ('southernpines_home','https://southernpines.cogasoc.org/')]
(p/'sources.json').write_text(json.dumps([dict(id=i,url=u) for i,u in sources],indent=2))
flight=Path('FLIGHT_LOG.md')
s=flight.read_bytes().decode('utf-8',errors='surrogateescape')
s+='\n\n### 2026-09-26 19:53 UTC - Church scope follow-up started\n\n- New packet church_scope_followup_2026-09-26 snapshots 36 linked candidates and all cluster members; prepare is running and must not be rerun. The preceding ordinal packet is frozen. Live scope/name decisions and working blank labels are archived before any rebuild.\n- Research distinguishes the Judaism-identifying cogasoc.org organization from similarly named Christian branches; no blanket name-based exclusions. Current 442,832 eligible / zero fully verified remain until a guarded proposal passes.\n- Independent labels and publication destination remain missing; useful source work continues. Cloud spending USD 0.\n'
flight.write_bytes(s.encode('utf-8',errors='surrogateescape'))
