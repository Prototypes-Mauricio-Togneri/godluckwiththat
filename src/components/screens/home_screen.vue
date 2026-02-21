<script setup>
import {onMounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits(['start'])

onMounted(() => {
  // TODO: temporary auto-start for development
  if (window.location.hostname === 'localhost') emit('start')
})
</script>

<template>
  <div class="home-screen">
    <div class="glow" />

    <div class="content">
      <h1 class="title">
        <span class="title-line">{{ t('screen.home.title.line1').toUpperCase() }}</span>
        <span class="title-line">{{ t('screen.home.title.line2').toUpperCase() }}</span>
      </h1>

      <button class="btn-gold start-button" @click="playTap(); emit('start')">
        {{ t('screen.home.play') }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.home-screen {
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--color-bg);
  position: relative;
  overflow: hidden;
}

/* Warm torchlight glow behind title */
.glow {
  position: absolute;
  top: 40%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 700px;
  height: 700px;
  background: radial-gradient(
    ellipse,
    rgba(var(--color-accent-rgb), 0.1) 0%,
    rgba(var(--color-accent-rgb), 0.04) 40%,
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
.title {
  font-family: var(--font-display);
  font-weight: 900;
  font-size: clamp(2.8rem, 8vw, 5.5rem);
  line-height: 1.1;
  text-align: center;
  color: var(--color-text);
  letter-spacing: 0.02em;
}

.title-line {
  display: block;
}

.title-line:nth-child(2) {
  color: rgba(var(--color-accent-rgb), 0.85);
}

.start-button {
  font-size: 1rem;
  letter-spacing: 0.2em;
  padding: 0.9rem 2.8rem;
}

.start-button:hover {
  box-shadow: 0 0 30px rgba(var(--color-accent-rgb), 0.1);
}

.start-button:active {
  transform: scale(0.97);
}

</style>
