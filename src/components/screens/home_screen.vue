<script setup>
import {computed, onMounted, ref} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {IS_DEV} from '@/js/engine/constants.js'
import {EMIT_START} from '@/js/engine/enums.js'
import storage from '@/js/engine/storage.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([EMIT_START])

const isMobile = ref(window.matchMedia('(pointer: coarse)').matches)
const savedData = ref(storage.savedGame)
const hasSavedGame = computed(() => savedData.value !== null)

onMounted(() => {
  if (IS_DEV) {
    emit(EMIT_START, savedData.value)
  }
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

      <button v-if="!isMobile && hasSavedGame" class="btn-gold start-button" @click="playTap(); emit(EMIT_START, savedData)">
        {{ t('screen.home.continue') }}
      </button>
      <button v-else-if="!isMobile" class="btn-gold start-button" @click="playTap(); emit(EMIT_START, null)">
        {{ t('screen.home.newGame') }}
      </button>
      <p v-else class="mobile-notice">
        {{ t('screen.home.mobileUnavailable') }}
      </p>
    </div>
  </div>
</template>

<style scoped>
.home-screen {
  height: 100vh;
  height: 100dvh;
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
    rgba(var(--color-accent-rgb), 0) 70%
  );
  pointer-events: none;
}

/* Content wrapper — above the glow layer */
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
  z-index: 1;
}

/* Game title heading */
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

/* Second line — accent color */
.title-line:nth-child(2) {
  color: rgba(var(--color-accent-rgb), 0.85);
}

/* Play button */
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

/* Desktop-only notice for mobile visitors */
.mobile-notice {
  font-family: var(--font-display);
  font-size: 0.95rem;
  color: var(--color-text);
  text-align: center;
  letter-spacing: 0.04em;
}

</style>
