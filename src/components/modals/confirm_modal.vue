<script setup>
import {ref, onMounted, onBeforeUnmount, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CONFIRM, EMIT_CLOSE} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {pushFocusLayer, removeFocusLayer} from '@/js/engine/focus_stack.js'
import {t} from '@/js/i18n/localized.js'

defineProps({
  titleKey: {
    type: String,
    required: true,
  },
  descriptionKey: {
    type: String,
    required: true,
  },
  confirmKey: {
    type: String,
    default: 'modal.confirm',
  },
})

const emit = defineEmits([
  EMIT_CONFIRM,
  EMIT_CLOSE,
])
const visible = ref(false)
const overlay = ref(null) // Root element; everything else is inert while this modal is topmost
let rafId = null

/** Closes modal on Escape while it is the topmost modal. */
function handleEscape() {
  emit(EMIT_CLOSE)
}

onMounted(() => {
  pushFocusLayer(overlay.value)
  pushEscapeHandler(handleEscape)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onBeforeUnmount(() => {
  removeFocusLayer(overlay.value)
})

onUnmounted(() => {
  removeEscapeHandler(handleEscape)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div
    ref="overlay"
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ t(titleKey) }}</h2>

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <p class="modal-description">{{ t(descriptionKey) }}</p>

      <div class="modal-actions">
        <button class="btn-gold modal-btn modal-btn--cancel" @click="playTap(); emit(EMIT_CLOSE)">
          {{ t('modal.cancel') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--danger" @click="playTap(); emit(EMIT_CONFIRM)">
          {{ t(confirmKey) }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 420px;
  align-items: center;
}

.modal-rule {
  margin: 1rem 0 1.5rem;
}

.modal-description {
  text-align: center;
  margin-bottom: 1.5rem;
}

/* ---- Button row ---- */

.modal-actions {
  display: flex;
  gap: 0.75rem;
  align-self: stretch;
  margin-inline: -1rem;
}

.modal-btn {
  flex: 1;
  font-family: var(--font-body);
  font-weight: 400;
  text-transform: uppercase;
  cursor: pointer;
  transition: all 0.25s ease;
}

/* Cancel — subdued gold */
.modal-btn--cancel {
  border-color: rgba(var(--color-accent-rgb), 0.12);
  color: rgba(var(--color-text-rgb), 0.45);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.03),
    rgba(var(--color-accent-rgb), 0.01)
  );
}

.modal-btn--cancel:hover {
  color: var(--color-text);
  border-color: rgba(var(--color-accent-rgb), 0.35);
  box-shadow: 0 0 20px rgba(var(--color-accent-rgb), 0.08);
}

</style>
