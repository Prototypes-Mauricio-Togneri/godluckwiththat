<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([
  'cancel',
  'saveAndQuit',
  'quit',
])
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
    @click.self="emit('cancel')"
  >
    <div class="modal-content confirm-quit-content">
      <h2 class="modal-title">{{ t('modal.confirmQuit.title') }}</h2>

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <p class="modal-description confirm-quit-message">
        {{ t('modal.confirmQuit.message') }}
      </p>

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit('cancel')">
          {{ t('modal.confirmQuit.cancel') }}
        </button>
        <button class="btn-gold modal-btn" @click="playTap(); emit('saveAndQuit')">
          {{ t('modal.confirmQuit.saveAndQuit') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--danger" @click="playTap(); emit('quit')">
          {{ t('modal.confirmQuit.quit') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Confirm quit modal content — centered narrow panel */
.confirm-quit-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 90vw;
  align-items: center;
}

.modal-rule {
  margin: 1rem 0 1.25rem;
}

.confirm-quit-message {
  text-align: center;
  margin-bottom: 1.5rem;
}

/* ---- Button column ---- */

.modal-actions {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  align-self: stretch;
  margin-inline: -1rem;
}

.modal-btn {
  width: 100%;
}
</style>
