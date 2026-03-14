<script setup>
import {inject, ref, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {t} from '@/js/i18n/localized.js'

const ui = inject('ui')
const actions = inject('actions')
const visible = ref(false)
let rafId = null

/** Block Escape — this modal cannot be dismissed. */
function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
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
  <div class="modal-overlay" :class="{ visible }">
    <div class="modal-content">
      <h2 class="modal-title modal-title--failure">{{ t('challenge.failure.title') }}</h2>
      <span class="modal-rule modal-rule--failure" />

      <p class="modal-description">{{ t('challenge.failure.description') }}</p>

      <template v-if="ui.challenges.activePunishment">
        <!-- Punishment name -->
        <div class="punishment-name">{{ t('punishment.' + ui.challenges.activePunishment.type) }}</div>

        <!-- Punishment effects list -->
        <ul class="punishment-list">
          <li v-if="ui.challenges.activePunishment.faith" class="punishment-item">
            {{ t('punishment.faithLoss', Math.round(ui.challenges.activePunishment.faith * 100)) }}
          </li>
          <li v-if="ui.challenges.activePunishment.productivity" class="punishment-item">
            {{ t('punishment.productivityLoss', Math.round(ui.challenges.activePunishment.productivity * 100)) }}
          </li>
          <li v-if="ui.challenges.activePunishment.resources" class="punishment-item">
            {{ t('punishment.resourceLoss', Math.round(ui.challenges.activePunishment.resources * 100)) }}
          </li>
          <li v-if="ui.challenges.activePunishment.workers" class="punishment-item">
            {{ t('punishment.workerLoss', ui.challenges.activePunishment.workers) }}
          </li>
          <li v-if="ui.challenges.activePunishment.levels" class="punishment-item">
            {{ t('punishment.buildingLoss', ui.challenges.activePunishment.levels) }}
          </li>
        </ul>

        <button class="btn-gold modal-btn modal-btn--danger" @click="playTap(); actions.acknowledgePunishment()">
          {{ t('challenge.failure.acknowledge') }}
        </button>
      </template>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 340px;
  max-width: 420px;
  align-items: center;
}

.modal-title--failure {
  color: rgba(196, 80, 80, 1);
}

.modal-rule--failure {
  margin: 1rem 0 1.25rem;
  background: linear-gradient(
    90deg,
    rgba(196, 80, 80, 0),
    rgba(196, 80, 80, 0.45),
    rgba(196, 80, 80, 0)
  );
}

.modal-description {
  text-align: center;
  margin-bottom: 1rem;
}

.punishment-name {
  font-family: var(--font-display);
  font-weight: 600;
  font-size: 1.1rem;
  color: rgba(196, 80, 80, 1);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  margin-bottom: 0.75rem;
}

.punishment-list {
  list-style: none;
  padding: 0;
  margin: 0 0 1.5rem;
  width: 100%;
}

.punishment-item {
  font-family: var(--font-body);
  font-size: 0.9rem;
  font-weight: 300;
  color: rgba(var(--color-text-rgb), 0.7);
  padding: 0.35rem 0;
  border-bottom: 1px solid rgba(var(--color-accent-rgb), 0.06);
  text-align: center;
}

.punishment-item:last-child {
  border-bottom: none;
}

.modal-btn {
  align-self: stretch;
}
</style>
