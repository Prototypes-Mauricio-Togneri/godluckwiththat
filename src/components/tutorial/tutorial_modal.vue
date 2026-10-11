<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
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
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ t(titleKey) }}</h2>
      <span class="modal-rule" />
      <p class="modal-description">{{ t(bodyKey) }}</p>

      <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
        {{ t('tutorial.modal.dismiss') }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 1.75rem 2rem 1.5rem;
  min-width: 340px;
  max-width: 480px;
}

.modal-rule {
  display: block;
  margin: 0.75rem auto 1.25rem;
}

.modal-btn {
  margin-top: 1.5rem;
  align-self: stretch;
}
</style>
