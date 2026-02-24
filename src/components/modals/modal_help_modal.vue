<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

defineProps({
  titleKey: {
    type: String,
    required: true,
  },
  bodyKey: {
    type: String,
    required: true,
  },
})

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
    <div class="modal-content">
      <h2 class="modal-title">{{ t(titleKey) }}</h2>
      <span class="modal-rule" />
      <p class="modal-description">{{ t(bodyKey) }}</p>

      <button class="btn-gold modal-btn" @click="playTap(); emit('close')">
        {{ t('modal.help.close') }}
      </button>
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
  z-index: 110;
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
  padding: 1.75rem 2rem 1.5rem;
  min-width: 340px;
  max-width: 480px;
  display: flex;
  flex-direction: column;
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
  align-self: center;
}

.modal-rule {
  display: block;
  width: 3.5rem;
  height: 1px;
  margin: 0.75rem auto 1.25rem;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(var(--color-accent-rgb), 0.35),
    transparent
  );
}

.modal-description {
  font-family: var(--font-body);
  font-size: 1.05rem;
  font-weight: 300;
  line-height: 1.6;
  color: rgba(var(--color-text-rgb), 0.75);
}

.modal-btn {
  margin-top: 1.5rem;
  align-self: stretch;
  font-size: 0.8rem;
  letter-spacing: 0.15em;
  padding: 0.6rem 1.8rem;
}

.modal-btn:hover {
  box-shadow: 0 0 20px rgba(var(--color-accent-rgb), 0.08);
}
</style>
