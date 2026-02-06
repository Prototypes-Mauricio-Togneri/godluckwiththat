<script setup>
import { ref } from 'vue'
import GameModal from './game_modal.vue'

const emit = defineEmits(['quit'])
const showModal = ref(false)
</script>

<template>
  <div class="game-screen">
    <header class="game-header">
      <span class="game-title">God Luck With That</span>
      <nav class="header-actions">
        <button class="header-button" @click="showModal = true">
          Open Modal
        </button>
        <button class="header-button header-button--muted" @click="emit('quit')">
          Quit
        </button>
      </nav>
    </header>

    <main class="game-content">
      <p class="placeholder-text">Game content will appear here</p>
    </main>

    <GameModal
      v-if="showModal"
      @close="showModal = false"
    />
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Jost:wght@300;400;500&display=swap');

.game-screen {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #0a0a0b;
  color: #e8e0d0;
}

.game-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid rgba(212, 175, 55, 0.12);
  background: rgba(0, 0, 0, 0.3);
}

.game-title {
  font-family: 'Cinzel', serif;
  font-weight: 700;
  font-size: 1rem;
  letter-spacing: 0.05em;
  color: rgba(212, 175, 55, 0.7);
}

.header-actions {
  display: flex;
  gap: 0.75rem;
}

.header-button {
  font-family: 'Jost', sans-serif;
  font-weight: 400;
  font-size: 0.8rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #e8e0d0;
  background: transparent;
  border: 1px solid rgba(212, 175, 55, 0.25);
  padding: 0.5rem 1.2rem;
  cursor: pointer;
  transition: all 0.25s ease;
}

.header-button:hover {
  border-color: rgba(212, 175, 55, 0.7);
  color: #d4af37;
}

.header-button--muted {
  border-color: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.4);
}

.header-button--muted:hover {
  border-color: rgba(255, 255, 255, 0.3);
  color: rgba(255, 255, 255, 0.7);
}

.game-content {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-text {
  font-family: 'Jost', sans-serif;
  font-weight: 300;
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  color: rgba(255, 255, 255, 0.12);
}
</style>
