<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
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
  'confirm',
  'close',
])
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

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <p class="modal-description">{{ t(descriptionKey) }}</p>

      <div class="modal-actions">
        <button class="btn-gold modal-btn modal-btn--cancel" @click="emit('close')">
          {{ t('modal.cancel') }}
        </button>
        <button class="modal-btn modal-btn--confirm" @click="emit('confirm')">
          {{ t(confirmKey) }}
        </button>
      </div>
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

.modal-content {
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 2.5rem;
  min-width: 340px;
  max-width: 420px;
  display: flex;
  flex-direction: column;
  align-items: center;
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
}

/* Decorative horizontal divider */
.modal-rule {
  width: 3.5rem;
  height: 1px;
  margin: 1rem 0 1.5rem;
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
  text-align: center;
  margin-bottom: 1.5rem;
}

/* ---- Button row ---- */

.modal-actions {
  display: flex;
  gap: 0.75rem;
  align-self: stretch;
}

.modal-btn {
  flex: 1;
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 400;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  padding: 0.6rem 1.8rem;
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

/* Confirm — red */
.modal-btn--confirm {
  color: #e4d5bc;
  background: linear-gradient(
    180deg,
    rgba(196, 80, 80, 0.15),
    rgba(196, 80, 80, 0.05)
  );
  border: 1px solid rgba(196, 80, 80, 0.35);
}

.modal-btn--confirm:hover {
  color: #c45050;
  background: linear-gradient(
    180deg,
    rgba(196, 80, 80, 0.22),
    rgba(196, 80, 80, 0.08)
  );
  border-color: rgba(196, 80, 80, 0.6);
  box-shadow: 0 0 20px rgba(196, 80, 80, 0.1);
}
</style>
