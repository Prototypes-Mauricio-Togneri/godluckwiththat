<script setup>
import { ref, onMounted } from 'vue'

const emit = defineEmits(['close'])
const visible = ref(false)

onMounted(() => {
  requestAnimationFrame(() => {
    visible.value = true
  })
})
</script>

<template>
  <div
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit('close')"
  >
    <div class="modal-content">
      <h2 class="modal-title">Modal Title</h2>
      <p class="modal-body">Modal content goes here.</p>

      <button class="btn-gold modal-close" @click="emit('close')">
        Close
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
  max-width: 90vw;
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
  margin-bottom: 1rem;
  letter-spacing: 0.03em;
}

.modal-body {
  font-family: var(--font-body);
  font-weight: 300;
  font-size: 0.95rem;
  line-height: 1.6;
  color: rgba(var(--color-text-rgb), 0.55);
  margin-bottom: 2rem;
}

.modal-close {
  font-size: 0.8rem;
  letter-spacing: 0.15em;
  padding: 0.6rem 1.8rem;
}

.modal-close:hover {
  box-shadow: 0 0 20px rgba(var(--color-accent-rgb), 0.08);
}
</style>
