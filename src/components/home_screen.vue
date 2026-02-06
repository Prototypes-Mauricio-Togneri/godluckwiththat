<script setup>
import { ref, onMounted } from 'vue'

const emit = defineEmits(['start'])
const visible = ref(false)

onMounted(() => {
  requestAnimationFrame(() => {
    visible.value = true
  })
})
</script>

<template>
  <div class="home-screen" :class="{ visible }">
    <div class="glow" />

    <div class="content">
      <p class="prelude">an incremental game</p>

      <h1 class="title">
        <span class="title-line">God Luck</span>
        <span class="title-line">With That</span>
      </h1>

      <button class="start-button" @click="emit('start')">
        Start Game
      </button>
    </div>

    <p class="footer-note">A game of divine mismanagement</p>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Jost:wght@300;400;500&display=swap');

.home-screen {
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #0a0a0b;
  position: relative;
  overflow: hidden;
  opacity: 0;
  transition: opacity 0.8s ease;
}

.home-screen.visible {
  opacity: 1;
}

/* Radial celestial glow behind title */
.glow {
  position: absolute;
  top: 40%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 600px;
  height: 600px;
  background: radial-gradient(
    circle,
    rgba(212, 175, 55, 0.08) 0%,
    rgba(212, 175, 55, 0.03) 35%,
    transparent 70%
  );
  pointer-events: none;
}

.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
  z-index: 1;
}

.prelude {
  font-family: 'Jost', sans-serif;
  font-weight: 300;
  font-size: 0.85rem;
  letter-spacing: 0.35em;
  text-transform: uppercase;
  color: rgba(212, 175, 55, 0.5);
  opacity: 0;
  animation: fade-up 0.8s ease 0.3s forwards;
}

.title {
  font-family: 'Cinzel', serif;
  font-weight: 900;
  font-size: clamp(2.8rem, 8vw, 5.5rem);
  line-height: 1.1;
  text-align: center;
  color: #e8e0d0;
  letter-spacing: 0.02em;
}

.title-line {
  display: block;
  opacity: 0;
  animation: fade-up 0.6s ease forwards;
}

.title-line:nth-child(1) {
  animation-delay: 0.5s;
}

.title-line:nth-child(2) {
  animation-delay: 0.7s;
  color: rgba(212, 175, 55, 0.85);
}

.start-button {
  font-family: 'Jost', sans-serif;
  font-weight: 400;
  font-size: 1rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: #e8e0d0;
  background: transparent;
  border: 1px solid rgba(212, 175, 55, 0.3);
  padding: 0.9rem 2.8rem;
  cursor: pointer;
  transition: all 0.3s ease;
  opacity: 0;
  animation: fade-up 0.6s ease 1s forwards;
}

.start-button:hover {
  border-color: rgba(212, 175, 55, 0.8);
  color: #d4af37;
  box-shadow: 0 0 30px rgba(212, 175, 55, 0.1);
}

.start-button:active {
  transform: scale(0.97);
}

.footer-note {
  position: absolute;
  bottom: 2rem;
  font-family: 'Jost', sans-serif;
  font-weight: 300;
  font-size: 0.75rem;
  letter-spacing: 0.15em;
  color: rgba(255, 255, 255, 0.15);
  z-index: 1;
  opacity: 0;
  animation: fade-in 1s ease 1.4s forwards;
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}
</style>
