# UI Rules

- **CSS Conventions**: All CSS naming, style, and comment conventions are in `docs/conventions.md`. Follow them for every code change.
- **Shared Styles**: Repeated CSS across `.vue` files gets extracted into `src/assets/styles.css`. Component-specific overrides stay in scoped `<style>` blocks.
- **Color Format**: Always use `rgba()`. No hex. Opaque colors use alpha `1` (e.g. `rgba(196, 80, 80, 1)`).
- **CSS Units**: Use `rem` for all `border-radius` values. No `px` (exception: `50%` for circles).
- **UI/UX**: Always use the `frontend-design` skill when changing the UI.
