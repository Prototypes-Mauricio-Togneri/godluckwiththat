# UI Rules

## Shared Styles

Repeated CSS across `.vue` files gets extracted into `src/assets/styles.css`. Component-specific overrides stay in scoped `<style>` blocks.

## Color Format

Always use `rgba()`. No hex. Opaque colors use alpha `1` (e.g. `rgba(196, 80, 80, 1)`).

## CSS Units

Use `rem` for all `border-radius` values. No `px` (exception: `50%` for circles).

## UI/UX

Always use the `frontend-design` skill when changing the UI.

## Comment Conventions

All CSS code uses a minimal, purpose-focused comment style:

**Section Dividers** - Major sections use decorated block comments:
```css
/* ============================================
   Section Name
   ============================================ */
```

**Rule Comments** - Single-line comment above the rule:
```css
/* Animated background */
.background-element::before {
```

**Pseudo-element Comments** - Brief description of visual effect:
```css
/* Scan line overlay effect */
.title-text::after {
```

**Conditional Logic Comments** - Explain non-obvious selectors:
```css
/* Hide background animation when game screen is active */
body:has(.game-screen.active) .background-animation {
```

**Guidelines:**
- Place comments above the rule they describe
- Use short, descriptive phrases (not full sentences)
- Focus on visual/functional purpose, not technical implementation
- Group related selectors together (base rule, pseudo-elements, states)
- Place keyframe animations near their corresponding animation properties
