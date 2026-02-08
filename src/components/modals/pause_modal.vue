<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {t} from '../../js/i18n/localized.js'

const emit = defineEmits(['close', 'quit'])
const visible = ref(false)
let rafId = null

onMounted(() => {
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit('close')"
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ t('modal.pause.title') }}</h2>

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="emit('close')">
          {{ t('modal.pause.continue') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--quit" @click="emit('quit')">
          {{ t('modal.pause.quit') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.modal-overlay.visible {
  opacity: 1;
}

.modal-content {
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 2.5rem;
  min-width: 340px;
  max-width: 90vw;
  display: flex;
  flex-direction: column;
  align-items: center;
  transform: translateY(8px);
  transition: transform 0.25s ease;
}

.modal-overlay.visible .modal-content {
  transform: translateY(0);
}

.modal-title {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 1.3rem;
  color: var(--color-text);
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

/* Decorative horizontal divider */
.modal-rule {
  width: 3.5rem;
  height: 1px;
  margin: 1rem 0 1.5rem;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(var(--color-accent-rgb), 0.35),
    transparent
  );
}

/* ---- Button column ---- */

.modal-actions {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  align-self: stretch;
}

.modal-btn {
  width: 100%;
  font-size: 0.8rem;
  letter-spacing: 0.15em;
  padding: 0.6rem 1.8rem;
}

.modal-btn:hover {
  box-shadow: 0 0 20px rgba(var(--color-accent-rgb), 0.08);
}

/* Subdued quit button */
.modal-btn--quit {
  border-color: rgba(var(--color-accent-rgb), 0.12);
  color: rgba(var(--color-text-rgb), 0.45);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.03),
    rgba(var(--color-accent-rgb), 0.01)
  );
}

.modal-btn--quit:hover {
  color: var(--color-text);
  border-color: rgba(var(--color-accent-rgb), 0.35);
}
</style>
