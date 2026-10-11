<script setup>
import {ref, computed, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  body: {
    type: String,
    required: true,
  },
})

const paragraphs = computed(() => props.body.split('\n'))

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
      <h2 class="modal-title">{{ title }}</h2>
      <span class="modal-rule" />
      <p v-for="para in paragraphs" :key="para" class="modal-description">{{ para }}</p>

      <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
        {{ t('modal.help.close') }}
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Stacks above parent modal (z-index 110 vs 100) */
.modal-overlay {
  z-index: 110;
}

.modal-content {
  padding: 1.75rem 2rem 1.5rem;
  min-width: 340px;
  max-width: 480px;
}

.modal-rule {
  display: block;
  margin: 0.75rem auto 1.25rem;
}

/* Spacing between consecutive description paragraphs */
.modal-description + .modal-description {
  margin-top: 0.75rem;
}

.modal-btn {
  margin-top: 1.5rem;
  align-self: stretch;
}
</style>
