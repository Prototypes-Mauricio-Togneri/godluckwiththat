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
        <button class="btn-gold header-button" @click="showModal = true">
          Open Modal
        </button>
        <button class="btn-gold header-button header-button--muted" @click="emit('quit')">
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
.game-screen {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--color-bg);
  color: var(--color-text);
}

.game-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid var(--color-border);
  background: var(--color-bg-surface);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.game-title {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 1rem;
  letter-spacing: 0.05em;
  color: rgba(var(--color-accent-rgb), 0.7);
}

.header-actions {
  display: flex;
  gap: 0.75rem;
}

.header-button {
  font-size: 0.8rem;
  letter-spacing: 0.12em;
  padding: 0.5rem 1.2rem;
}

.header-button--muted {
  border-color: rgba(var(--color-text-rgb), 0.1);
  color: rgba(var(--color-text-rgb), 0.4);
}

.header-button--muted:hover {
  border-color: rgba(var(--color-text-rgb), 0.3);
  color: rgba(var(--color-text-rgb), 0.7);
}

.game-content {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-text {
  font-family: var(--font-body);
  font-weight: 300;
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  color: rgba(var(--color-text-rgb), 0.12);
}
</style>
