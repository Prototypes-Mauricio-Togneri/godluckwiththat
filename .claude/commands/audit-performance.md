---
description: Audit for performance bottlenecks, memory leaks, and CPU/GPU waste.
---

You are a Senior Performance Engineer specializing in Vue 3 single-page applications.

Conduct a comprehensive audit of this codebase to identify performance bottlenecks, memory leaks, excessive CPU/GPU usage, and patterns that degrade over time. Follow this specific workflow:

1. **Analysis Phase**: Scan all `.js`, `.vue`, and `.css` files. Focus on:
    * **Vue Reactivity Overhead**: Deep `reactive()` wrapping large object graphs, frequent mutations to reactive state inside `requestAnimationFrame` or tight loops, unnecessary dependency tracking from accessing reactive properties in hot paths.
    * **Game Loop Efficiency**: `requestAnimationFrame` or `setInterval` callbacks that iterate collections unconditionally (even when empty or idle), missing early returns, per-frame object allocation (new Map, new Array, new instances) that creates GC pressure.
    * **Unbounded Growth**: Arrays, Maps, Sets, or other collections that grow over time without caps or pruning (e.g., event logs, history, caches). Each entry in a reactive collection adds overhead to every mutation.
    * **Template Rendering**: Plain functions called in templates that re-evaluate on every render instead of being `computed` properties. Expensive operations (iteration, object creation) inside template expressions. Missing or duplicate `:key` in `v-for`.
    * **Memory Leaks**: `setInterval`/`setTimeout` not cleared in `onUnmounted`, `addEventListener` without corresponding `removeEventListener`, `requestAnimationFrame` not cancelled on teardown, closures capturing large scopes, orphaned reactive watchers or subscriptions.
    * **Object Allocation in Hot Paths**: Getters or methods called per-frame or per-render that create new objects (Cost instances, Maps, Arrays, shallow copies) instead of caching or reusing them. Frequent `Object.entries()`, `Object.keys()`, or spread operators in code called every tick.
    * **CSS/GPU Load**: Excessive `filter: drop-shadow()`, `box-shadow`, `backdrop-filter`, or `filter: blur()` on many simultaneously visible elements. Animations or transitions on properties that trigger layout (width, height, top, left) instead of transform/opacity. Large numbers of elements with `will-change` or forced compositing layers.
    * **Asset & Network**: Uncompressed or oversized images/audio, missing lazy loading for off-screen content, large JSON payloads parsed synchronously.
    * **Watcher & Computed Cascades**: Deep watchers (`{ deep: true }`) on large objects, computed properties that depend on frequently-changing reactive state and trigger cascading re-evaluations across multiple consumers.
    * **Provide/Inject Overhead**: Deeply reactive objects passed via `provide`/`inject` that cause child components to re-render on every property change, even when the child only needs a subset of the data.

2. **Cross-Reference Verification**: Before listing an issue, verify it is a real problem:
    - Check if a seemingly leaked listener is actually cleaned up in a parent component or via a composable.
    - Check if a growing collection has a cap or pruning logic elsewhere.
    - Check if an "expensive" operation is actually called infrequently (e.g., only on user action, not per-frame).
    - Check if `shallowRef`/`shallowReactive` is already used where noted.

3. **Reporting**: Present findings in a Markdown table:
   | File Path | Line # | Severity | Category | Description & Suggested Fix |
   | :--- | :--- | :--- | :--- | :--- |

   Severity levels: **Critical** (causes measurable lag or crash after sustained play), **High** (noticeable performance degradation under normal conditions), **Medium** (suboptimal but tolerable), **Low** (minor inefficiency, cosmetic).

   Category values: Reactivity, Game Loop, Memory Leak, GC Pressure, Rendering, CSS/GPU, Asset, Watcher Cascade.

   End with a one-line summary: "X critical, Y high, Z medium, W low across N files."

**Constraint**: Do NOT modify any code. Only provide the diagnostic report.
