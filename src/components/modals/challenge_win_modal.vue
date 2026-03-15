<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {IMG_OTHER_PORTAL} from '@/js/engine/assets.js'
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

      <img class="portal-img" :src="IMG_OTHER_PORTAL" alt="">

      <p class="modal-description">{{ t('challenge.win.description') }}</p>

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit('continue')">
          {{ t('challenge.win.continue') }}
        </button>
        <button class="btn-gold modal-btn" @click="playTap(); emit('quit')">
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

.portal-img {
  width: 100%;
  max-width: 400px;
  object-fit: cover;
  margin-bottom: 1rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.25);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.35);
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

</style>
