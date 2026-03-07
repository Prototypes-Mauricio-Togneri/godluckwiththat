<script setup>
import {t} from '@/js/i18n/localized.js'

defineProps({
  textKey: {
    type: String,
    default: null,
  },
  buildingImg: {
    type: String,
    default: null,
  },
  stepNumber: {
    type: Number,
    required: true,
  },
  totalSteps: {
    type: Number,
    required: true,
  },
})
</script>

<template>
  <div v-if="textKey" class="tutorial-banner">
    <div class="banner-inner">
      <img v-if="buildingImg" class="banner-icon" :src="buildingImg" alt="">
      <span class="banner-text">{{ t(textKey) }}</span>
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
}

.banner-icon {
  width: 1.5rem;
  height: 1.5rem;
  object-fit: contain;
  flex-shrink: 0;
}

.banner-text {
  font-family: var(--font-body);
  font-size: 0.9rem;
  font-weight: 400;
  color: var(--color-text);
  letter-spacing: 0.01em;
  white-space: nowrap;
}
</style>
