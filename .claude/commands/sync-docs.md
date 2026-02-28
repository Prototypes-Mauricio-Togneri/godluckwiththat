---
description: Audits and updates JS/CSS documentation based on docs/architecture.md and docs/specs.md standards.
---

I want you to synchronize the documentation across the codebase. Follow this specific workflow:

1. **Rule Retrieval**:
   - Read the files `docs/architecture.md` and `docs/specs.md`.
   - Identify the "Source of Truth" for documentation standards (e.g., specific JSDoc tags, CSS naming conventions, or commenting styles) and game specifications (buildings, seasons, progression, balancing).

2. **File Audit**:
   - Locate and analyze all JavaScript (`.js`) and CSS (`.css`) files in the codebase.
   - Compare the existing documentation and comments against the rules found in `docs/architecture.md` and `docs/specs.md`.
   - Identify any missing, outdated, or non-compliant documentation.
   - Update the documentation in each file to match the implementation and the architectural standards.

3. **Safety constraints**:
   - Modify **documentation and comments only**. Do NOT change any Javascript logic or CSS property values.
