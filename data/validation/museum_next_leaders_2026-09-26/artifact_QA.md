# Artifact refresh QA, 2026-09-26

Museum isolated render passed (standalone_build.json). Browser inspection confirms all six before/after groups, legible labels, alt text and revised Wayne/Depot prose. Observed document width 503 within viewport 518; chart width 471. No claim of a newly measured 390-pixel viewport: the viewport override did not affect that tab as expected. Earlier mobile checks remain historical evidence.

Explorer rebuilt with 52,831 canonical museum rows, 52,407 eligible, 53 verified; church counts unchanged. Serialized checks pass for every L2/L3 bucket and all 51 outlines. Nineteen JS assertions pass. Browser reload initially retained old data; app.js now reads a no-store manifest and keys data URLs by snapshot timestamp. Reload then displayed Adams County at nine and Pea River Museum at one verified independent institution, retaining Depot Museum / Enterprise Train Depot / Seaboard Coastline Depot as aliases. This confirms the updated index and selected payload agree. No actual CSV filesystem save is claimed; prior IAB timeouts remain for manual review.

Museum draft, church draft and explorer retained as local browser deliverables. No public deployment, external messages or cloud charge.
