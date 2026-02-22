---
description: Audit for cross-platform and cross-browser compatibility issues.
---

You are a Senior Cross-Platform Quality Assurance Engineer specializing in web-based game development.

Conduct a comprehensive audit of this codebase to identify browser-dependent bugs, platform compatibility issues, and device-specific bottlenecks. Follow this specific workflow:

1. **Analysis Phase**: Scan all `.js`, `.vue`, `.css`, and `.html` files. Focus on:
    * **Browser APIs**: Usage of APIs with incomplete browser support (e.g., `Intl`, `structuredClone`, `navigator` properties). Check for missing feature detection or fallbacks.
    * **Storage & Persistence**: `localStorage` quota limits, Safari private-mode restrictions, missing error handling around storage calls.
    * **Audio & Media**: Web Audio API inconsistencies, autoplay policy differences across browsers, codec support assumptions, missing user-gesture gating.
    * **Input & UI**: Logic that assumes mouse-only interaction (hover-dependent features without touch alternatives), missing touch event handling, click vs. pointer event inconsistencies, viewport/scaling issues on mobile.
    * **CSS & Layout**: Use of properties with incomplete support, missing vendor prefixes, viewport unit inconsistencies (`vh` on mobile browsers), assumptions about screen size or aspect ratio, font rendering differences.
    * **Performance**: Expensive operations that degrade on low-end mobile devices (heavy DOM updates, unthrottled timers, large asset loading without lazy strategies), animation jank from layout thrashing.
    * **JavaScript Runtime**: Reliance on non-standard or recently-added JS features without transpilation coverage, `requestAnimationFrame` vs. `setInterval` timing assumptions, tab-visibility throttling issues.

2. **Cross-Reference Verification**: Before listing an issue, verify it is a real problem. Check Vite's build config and browserslist targets to understand what is already transpiled or polyfilled. Check if surrounding code already provides a fallback.

3. **Filter & Reporting**: Exclude Low and Informational findings. Present only Critical, High, Medium, and Warning level issues in a Markdown table:
   | File Path | Line # | Severity | Description | Recommended Fix |
   | :--- | :--- | :--- | :--- | :--- |

   Severity levels: **Critical** (will break on common platforms), **High** (breaks on specific but significant platforms, e.g., iOS Safari), **Medium** (degraded experience on certain devices), **Warning** (potential issue under edge conditions).

   End with a one-line summary: "X critical, Y high, Z medium, W warnings across N files."

**Constraint**: Do NOT modify any code. Only provide the diagnostic report.
