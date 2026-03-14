<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([
  'continue',
  'quit',
])
const visible = ref(false)
let rafId = null

/** Block Escape — this modal cannot be dismissed without choosing. */
function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown, true)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown, true)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div class="modal-overlay" :class="{ visible }">
    <div class="modal-content">
      <h2 class="modal-title modal-title--win">{{ t('challenge.win.title') }}</h2>
      <span class="modal-rule modal-rule--win" />

      <p class="modal-description">{{ t('challenge.win.description') }}</p>

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit('continue')">
          {{ t('challenge.win.continue') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--quit" @click="playTap(); emit('quit')">
          {{ t('challenge.win.quit') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 2rem 2.5rem 1.5rem;
  min-width: 360px;
  max-width: 440px;
  align-items: center;
}

.modal-title--win {
  color: rgba(var(--color-accent-rgb), 1);
}

.modal-rule--win {
  margin: 1rem 0 1.5rem;
  width: 5rem;
  background: linear-gradient(
    90deg,
    rgba(var(--color-accent-rgb), 0),
    rgba(var(--color-accent-rgb), 0.5),
    rgba(var(--color-accent-rgb), 0)
  );
}

.modal-description {
  text-align: center;
  margin-bottom: 1.5rem;
}

.modal-actions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  align-self: stretch;
}

.modal-btn {
  font-family: var(--font-body);
  font-weight: 400;
  text-transform: uppercase;
  cursor: pointer;
}

/* Quit — subdued style */
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
  box-shadow: 0 0 20px rgba(var(--color-accent-rgb), 0.08);
}
</style>
