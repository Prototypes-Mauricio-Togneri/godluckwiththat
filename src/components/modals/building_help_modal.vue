<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {t} from '@/js/i18n/localized.js'

defineProps({
  nameKey: {
    type: String,
    required: true,
  },
  buildingKey: {
    type: String,
    required: true,
  },
  img: {
    type: String,
    required: true,
  },
})

const emit = defineEmits([EMIT_CLOSE])
const visible = ref(false)
let rafId = null

/** Closes modal on Escape while it is the topmost modal. */
function handleEscape() {
  emit(EMIT_CLOSE)
}

onMounted(() => {
  pushEscapeHandler(handleEscape)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
  removeEscapeHandler(handleEscape)
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
      <h2 class="modal-title">{{ t(nameKey) }}</h2>
      <span class="modal-rule" />
      <div class="modal-body">
        <img class="modal-thumb" :src="img" :alt="t(nameKey)">
        <p class="modal-description">{{ t('buildingHelp.' + buildingKey) }}</p>
      </div>

      <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
        {{ t('modal.buildingHelp.close') }}
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Help modal content panel */
.modal-content {
  padding: 1.75rem 2rem 1.5rem;
  min-width: 340px;
  max-width: 480px;
}

.modal-rule {
  display: block;
  margin: 0.75rem auto 1.25rem;
}

/* Horizontal layout — thumbnail beside description */
.modal-body {
  display: flex;
  align-items: flex-start;
  gap: 1.5rem;
}

/* Large building thumbnail with decorative shadows */
.modal-thumb {
  width: 9rem;
  height: 9rem;
  object-fit: contain;
  flex-shrink: 0;
  filter: drop-shadow(0 2px 6px rgba(var(--color-shadow-rgb), 0.5));
}

.modal-btn {
  margin-top: 1.5rem;
  align-self: stretch;
}
</style>
