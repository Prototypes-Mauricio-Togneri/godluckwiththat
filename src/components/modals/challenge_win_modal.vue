<script setup>
import {ref, onMounted, onBeforeUnmount, onUnmounted} from 'vue'
import {IMG_OTHER_PORTAL} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CONTINUE, EMIT_QUIT} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {pushFocusLayer, removeFocusLayer} from '@/js/engine/focus_stack.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([
  EMIT_CONTINUE,
  EMIT_QUIT,
])
const visible = ref(false)
const overlay = ref(null) // Root element; everything else is inert while this modal is topmost
let rafId = null

/** Block Escape while topmost — this modal cannot be dismissed with it. */
function handleEscape() {
  // Swallows Escape so modals underneath and the pause toggle never see it
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
  <div ref="overlay" class="modal-overlay" :class="{ visible }">
    <div class="modal-content">
      <h2 class="modal-title modal-title--win">{{ t('challenge.win.title') }}</h2>
      <span class="modal-rule modal-rule--win" />

      <img class="portal-img" :src="IMG_OTHER_PORTAL" alt="">

      <p class="modal-description">{{ t('challenge.win.description') }}</p>

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CONTINUE)">
          {{ t('challenge.win.continue') }}
        </button>
        <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_QUIT)">
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
