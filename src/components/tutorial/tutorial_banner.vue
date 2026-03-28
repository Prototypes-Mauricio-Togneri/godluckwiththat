<script setup>
import {t} from '@/js/i18n/localized.js'

defineProps({
  textKey: {
    type: String,
    default: null,
  },
  hintKey: {
    type: String,
    default: null,
  },
  buildingImg: {
    type: String,
    default: null,
  },
})
</script>

<template>
  <div v-if="textKey" class="tutorial-banner">
    <div class="banner-inner">
      <img v-if="buildingImg" class="banner-icon" :src="buildingImg" alt="">
      <div class="banner-content">
        <span class="banner-text">{{ t(textKey) }}</span>
        <span v-if="hintKey" class="banner-hint">{{ t(hintKey) }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.tutorial-banner {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 50;
  display: flex;
  justify-content: center;
  padding: 0 1.5rem 0.75rem;
  pointer-events: none;
}

.banner-inner {
  pointer-events: auto;
  display: flex;
  align-items: center;
  gap: 0.85rem;
  padding: 0.55rem 0.75rem;
  background: linear-gradient(
    180deg,
    rgba(39, 33, 25, 0.97),
    rgba(30, 26, 20, 0.97)
  );
  border: 1px solid rgba(var(--color-accent-rgb), 0.25);
  border-radius: 0.375rem;
  box-shadow:
    0 -2px 16px rgba(var(--color-shadow-rgb), 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.08);
  animation: banner-glow 0.5s ease-in-out 0.3s 3;
}

@keyframes banner-glow {
  0%, 100% {
    border-color: rgba(var(--color-accent-rgb), 0.25);
    box-shadow:
      0 -2px 16px rgba(var(--color-shadow-rgb), 0.4),
      inset 0 1px 0 rgba(var(--color-accent-rgb), 0.08);
  }
  50% {
    border-color: rgba(var(--color-accent-rgb), 0.6);
    box-shadow:
      0 -2px 16px rgba(var(--color-shadow-rgb), 0.4),
      inset 0 1px 0 rgba(var(--color-accent-rgb), 0.08),
      0 0 12px rgba(var(--color-accent-rgb), 0.25);
  }
}

.banner-icon {
  width: 2rem;
  height: 2rem;
  object-fit: contain;
  flex-shrink: 0;
}

.banner-content {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.banner-text {
  font-family: var(--font-body);
  font-size: 0.9rem;
  font-weight: 400;
  color: var(--color-text);
  letter-spacing: 0.01em;
  white-space: nowrap;
}

.banner-hint {
  font-family: var(--font-body);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.45);
  letter-spacing: 0.01em;
}
</style>
