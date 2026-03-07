<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([
  'close',
  'save',
  'quit',
])
const visible = ref(false)
const musicEnabled = ref(audio.musicEnabled)
const soundEnabled = ref(audio.soundEnabled)
let rafId = null

/** Toggles background music on/off. */
function toggleMusic() {
  playTap()
  musicEnabled.value = !musicEnabled.value
  audio.setMusicEnabled(musicEnabled.value)
}

/** Toggles sound effects on/off. */
function toggleSound() {
  playTap()
  soundEnabled.value = !soundEnabled.value
  audio.setSoundEnabled(soundEnabled.value)
}

onMounted(() => {
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
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
      <h2 class="modal-title">{{ t('modal.pause.title') }}</h2>

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <div class="toggle-group">
        <div class="toggle-row">
          <span class="toggle-label">{{ t('modal.pause.music') }}</span>
          <button
            class="toggle-switch"
            :class="{ active: musicEnabled }"
            @click="toggleMusic"
          >
            <span class="toggle-knob" />
          </button>
        </div>
        <div class="toggle-row">
          <span class="toggle-label">{{ t('modal.pause.sound') }}</span>
          <button
            class="toggle-switch"
            :class="{ active: soundEnabled }"
            @click="toggleSound"
          >
            <span class="toggle-knob" />
          </button>
        </div>
      </div>

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit('close')">
          {{ t('modal.pause.continue') }}
        </button>
        <button class="btn-gold modal-btn" @click="playTap(); emit('save')">
          {{ t('modal.pause.save') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--danger" @click="playTap(); emit('quit')">
          {{ t('modal.pause.quit') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Pause modal content — centered narrow panel */
.modal-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 90vw;
  align-items: center;
}

.modal-rule {
  margin: 1rem 0 1.5rem;
}

/* ---- Toggle rows ---- */

.toggle-group {
  align-self: stretch;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
  margin-bottom: 1.25rem;
  margin-inline: -1rem;
}

.toggle-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-inline: 0.25rem;
}

.toggle-label {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 400;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.6);
}

/* Toggle switch — pill-shaped on/off control */
.toggle-switch {
  position: relative;
  width: 2.4rem;
  height: 1.3rem;
  border-radius: 0.65rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.15);
  background: rgba(var(--color-accent-rgb), 0.06);
  cursor: pointer;
  transition: all 0.25s ease;
  padding: 0;
}

/* Active state — intensified background */
.toggle-switch.active {
  background: rgba(var(--color-accent-rgb), 0.25);
  border-color: rgba(var(--color-accent-rgb), 0.5);
}

/* Sliding knob inside toggle */
.toggle-knob {
  position: absolute;
  top: 2px;
  left: 2px;
  width: calc(1.3rem - 6px);
  height: calc(1.3rem - 6px);
  border-radius: 50%;
  background: rgba(var(--color-text-rgb), 0.3);
  transition: all 0.25s ease;
}

/* Active knob — slides right, accent color */
.toggle-switch.active .toggle-knob {
  left: calc(100% - 1.3rem + 4px);
  background: var(--color-accent);
  box-shadow: 0 0 6px rgba(var(--color-accent-rgb), 0.4);
}

/* ---- Button column ---- */

.modal-actions {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  align-self: stretch;
  margin-inline: -1rem;
}

.modal-btn {
  width: 100%;
}

</style>
