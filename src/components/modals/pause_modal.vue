<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import audio from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([
  'close',
  'quit',
])
const visible = ref(false)
const musicEnabled = ref(audio._musicEnabled)
const soundEnabled = ref(audio._soundEnabled)
let rafId = null

function toggleMusic() {
  musicEnabled.value = !musicEnabled.value
  audio.setMusicEnabled(musicEnabled.value)
}

function toggleSound() {
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
        <button class="btn-gold modal-btn" @click="emit('close')">
          {{ t('modal.pause.continue') }}
        </button>
        <button class="btn-gold modal-btn modal-btn--quit" @click="emit('quit')">
          {{ t('modal.pause.quit') }}
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
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 90vw;
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

.toggle-switch.active {
  background: rgba(var(--color-accent-rgb), 0.25);
  border-color: rgba(var(--color-accent-rgb), 0.5);
}

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
  font-size: 0.8rem;
  letter-spacing: 0.15em;
  padding: 0.6rem 1.8rem;
}

.modal-btn:hover {
  box-shadow: 0 0 20px rgba(var(--color-accent-rgb), 0.08);
}

/* Subdued quit button */
.modal-btn--quit {
  border-color: rgba(var(--color-accent-rgb), 0.12);
  color: rgba(var(--color-text-rgb), 0.45);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.03),
    rgba(var(--color-accent-rgb), 0.01)
  );
}

.modal-btn--quit:hover {
  color: var(--color-text);
  border-color: rgba(var(--color-accent-rgb), 0.35);
}
</style>
