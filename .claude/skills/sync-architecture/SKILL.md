---
name: sync-architecture
description: Synchronize architecture.md and specs.md with the current codebase implementation.
---

I want you to perform a high-fidelity synchronization between `docs/architecture.md`, `docs/specs.md`, and the actual codebase. Follow this workflow:

1. **Discovery Phase**: Analyze the project structure, core modules, data flow, and technology stack currently implemented in the source code.
2. **Gap Analysis**: Compare the "Source of Truth" (the code) against both `docs/architecture.md` and `docs/specs.md`. Identify:
    * **Stale Information**: Components, workflows, or game mechanics described in the docs that no longer exist.
    * **Missing Documentation**: New modules, patterns, integrations, or game features implemented in the code but absent from the docs.
    * **Inconsistencies**: Discrepancies in naming conventions, folder structures, architectural patterns, or game mechanics between the docs and the code.
3. **Drafting Phase**: Propose specific text updates for both docs that resolve these gaps.

**Output**: Provide a summary of the discrepancies found and Markdown diffs for each file that needs changes.

**Constraints**:
- `docs/architecture.md` should remain a high-level architectural guide, not a low-level file manifest.
- `docs/specs.md` should accurately reflect game mechanics, buildings, resources, and progression as implemented in the code.
