<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits(['close'])
const visible = ref(false)
let rafId = null

function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
    emit('close')
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
  <div
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit('close')"
  >
    <div class="market-modal">
      <button class="modal-close-x" @click="playTap(); emit('close')">&#10005;</button>
      <h2 class="modal-title">{{ t('market.title') }}</h2>
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

.market-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 1rem 2rem 1.5rem;
  width: 90vw;
  max-width: 960px;
  max-height: 89vh;
  display: flex;
  flex-direction: column;
  transform: translateY(8px);
  transition: transform 0.25s ease;
}

.modal-overlay.visible .market-modal {
  transform: translateY(0);
}

.modal-close-x {
  position: absolute;
  top: 0.75rem;
  right: 0.75rem;
  background: rgba(180, 60, 60, 0.12);
  border: 1px solid transparent;
  border-radius: 3px;
  color: rgba(var(--color-text-rgb), 0.45);
  font-size: 0.85rem;
  line-height: 1;
  width: 1.5rem;
  height: 1.5rem;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.modal-close-x:hover {
  color: #c45050;
  border-color: rgba(180, 60, 60, 0.4);
}

.modal-title {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 1rem;
  color: var(--color-text);
  letter-spacing: 0.18em;
  text-transform: uppercase;
  align-self: center;
  margin-bottom: 1.25rem;
}
</style>
