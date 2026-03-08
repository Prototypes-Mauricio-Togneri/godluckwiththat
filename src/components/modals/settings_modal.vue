<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {AUTOSAVE_MAX_INTERVAL, AUTOSAVE_MIN_INTERVAL} from '@/js/engine/constants.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import storage from '@/js/engine/storage.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([EMIT_CLOSE])
const visible = ref(false)
const musicEnabled = ref(audio.musicEnabled)
const soundEnabled = ref(audio.soundEnabled)
const autosaveEnabled = ref(storage.autosaveEnabled)
const autosaveInterval = ref(storage.autosaveInterval)
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

/** Toggles autosave on/off and persists to storage. */
function toggleAutosave() {
  playTap()
  autosaveEnabled.value = !autosaveEnabled.value
  storage.autosaveEnabled = autosaveEnabled.value
}

/** Decrements the autosave interval by 1 minute (clamped to minimum). */
function decrementInterval() {
  playTap()
  if (autosaveInterval.value > AUTOSAVE_MIN_INTERVAL) {
    autosaveInterval.value--
    storage.autosaveInterval = autosaveInterval.value
  }
}

/** Increments the autosave interval by 1 minute (clamped to maximum). */
function incrementInterval() {
  playTap()
  if (autosaveInterval.value < AUTOSAVE_MAX_INTERVAL) {
    autosaveInterval.value++
    storage.autosaveInterval = autosaveInterval.value
  }
}

/** Closes modal on Escape key (capture phase). */
function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
    emit(EMIT_CLOSE)
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
    class="modal-overlay settings-overlay"
    :class="{ visible }"
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ t('modal.settings.title') }}</h2>

      <!-- Decorative rule -->
      <span class="modal-rule" />

      <div class="toggle-group">
        <div class="toggle-row">
          <span class="toggle-label">{{ t('modal.settings.music') }}</span>
          <button
            class="toggle-switch"
            :class="{ active: musicEnabled }"
            @click="toggleMusic"
          >
            <span class="toggle-knob" />
          </button>
        </div>
        <div class="toggle-row">
          <span class="toggle-label">{{ t('modal.settings.sound') }}</span>
          <button
            class="toggle-switch"
            :class="{ active: soundEnabled }"
            @click="toggleSound"
          >
            <span class="toggle-knob" />
          </button>
        </div>
        <span class="modal-rule toggle-divider" />
        <div class="toggle-row">
          <span class="toggle-label">{{ t('modal.settings.autosave') }}</span>
          <button
            class="toggle-switch"
            :class="{ active: autosaveEnabled }"
            @click="toggleAutosave"
          >
            <span class="toggle-knob" />
          </button>
        </div>
        <div class="interval-row" :class="{ disabled: !autosaveEnabled }">
          <button
            class="interval-btn"
            :disabled="!autosaveEnabled || autosaveInterval <= AUTOSAVE_MIN_INTERVAL"
            @click="decrementInterval"
          >
            &minus;
          </button>
          <span class="interval-value">
            {{ t('modal.settings.autosaveInterval', autosaveInterval) }}
          </span>
          <button
            class="interval-btn"
            :disabled="!autosaveEnabled || autosaveInterval >= AUTOSAVE_MAX_INTERVAL"
            @click="incrementInterval"
          >
            +
          </button>
        </div>
      </div>

      <div class="modal-actions">
        <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
          {{ t('modal.help.close') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Settings overlay stacks above pause modal */
.settings-overlay {
  z-index: 110;
}

.modal-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 90vw;
  align-items: center;
}

.modal-rule {
  margin: 1rem 0 1.5rem;
}

.toggle-divider {
  margin: 0.3rem auto;
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

/* ---- Interval selector ---- */

.interval-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  padding-top: 0.2rem;
  transition: opacity 0.25s ease;
}

.interval-row.disabled {
  opacity: 0.3;
}

.interval-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.6rem;
  height: 1.6rem;
  border-radius: 0.3rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.25);
  background: rgba(var(--color-accent-rgb), 0.08);
  color: rgba(var(--color-text-rgb), 0.7);
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  padding: 0;
  line-height: 1;
}

.interval-btn:hover:not(:disabled) {
  background: rgba(var(--color-accent-rgb), 0.2);
  border-color: rgba(var(--color-accent-rgb), 0.5);
  color: var(--color-accent);
}

.interval-btn:disabled {
  opacity: 0.3;
  cursor: default;
}

.interval-value {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 400;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.6);
  min-width: 3.5rem;
  text-align: center;
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
