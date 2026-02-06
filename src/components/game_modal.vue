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

      <button class="modal-close" @click="emit('close')">
        Close
      </button>
    </div>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Jost:wght@300;400;500&display=swap');

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
  background: #141416;
  border: 1px solid rgba(212, 175, 55, 0.2);
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
  font-family: 'Cinzel', serif;
  font-weight: 700;
  font-size: 1.3rem;
  color: #e8e0d0;
  margin-bottom: 1rem;
  letter-spacing: 0.03em;
}

.modal-body {
  font-family: 'Jost', sans-serif;
  font-weight: 300;
  font-size: 0.95rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.55);
  margin-bottom: 2rem;
}

.modal-close {
  font-family: 'Jost', sans-serif;
  font-weight: 400;
  font-size: 0.8rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: #e8e0d0;
  background: transparent;
  border: 1px solid rgba(212, 175, 55, 0.3);
  padding: 0.6rem 1.8rem;
  cursor: pointer;
  transition: all 0.25s ease;
}

.modal-close:hover {
  border-color: rgba(212, 175, 55, 0.8);
  color: #d4af37;
  box-shadow: 0 0 20px rgba(212, 175, 55, 0.08);
}
</style>
