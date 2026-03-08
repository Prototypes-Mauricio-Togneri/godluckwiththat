<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CLOSE, EMIT_SAVE, EMIT_LOAD, EMIT_SETTINGS, EMIT_RESTART, EMIT_QUIT} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'

defineProps({
  hasSavedGame: {
    type: Boolean,
    required: true,
  },
})

const emit = defineEmits([
  EMIT_CLOSE,
  EMIT_SAVE,
  EMIT_LOAD,
  EMIT_SETTINGS,
  EMIT_RESTART,
  EMIT_QUIT,
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
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ t('modal.pause.title') }}</h2>

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
          {{ t('modal.pause.resume') }}
        </button>
        <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_SAVE)">
          {{ t('modal.pause.save') }}
        </button>
        <button
          class="btn-gold modal-btn"
          :disabled="!hasSavedGame"
          @click="playTap(); emit(EMIT_LOAD)"
        >
          {{ t('modal.pause.load') }}
        </button>
        <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_SETTINGS)">
          {{ t('modal.pause.settings') }}
        </button>

        <!-- Separator between normal and destructive actions -->
        <span class="modal-rule action-separator" />

        <button class="btn-gold modal-btn modal-btn--danger" @click="playTap(); emit(EMIT_RESTART)">
          {{ t('modal.pause.restart') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--danger" @click="playTap(); emit(EMIT_QUIT)">
          {{ t('modal.pause.quit') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Pause modal content — centered narrow panel */
.modal-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 90vw;
  align-items: center;
}

.modal-rule {
  margin: 1rem 0 1.5rem;
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

/* Separator between normal and destructive actions */
.action-separator {
  margin: 0.25rem 0;
  align-self: center;
}

</style>
