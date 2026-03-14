<script setup>
import {inject, ref, computed, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import {formatTime, formatNumber} from '@/js/engine/format.js'
import {t} from '@/js/i18n/localized.js'

const ui = inject('ui')
const emit = defineEmits([EMIT_CLOSE])
const visible = ref(false)
let rafId = null

const challenge = computed(() => ui.challenges.active)
const hasActive = computed(() => challenge.value !== null)

/** Whether a specific requirement is met. */
function isRequirementMet(type, value) {
  if (!challenge.value) {
    return false
  }
  switch (type) {
    case 'faith': return ui.resources.faith >= value
    case 'altar': return ui.buildings.altar?.level >= value
    case 'temple': return ui.buildings.temple?.level >= value
    case 'monument': return ui.buildings.monument?.level >= value
    case 'workers': return ui.resources.workers >= value
    default: return false
  }
}

/** Whether a resource requirement is met. */
function isResourceMet(resource, amount) {
  return ui.resources[resource] >= amount
}

/** Time remaining on the active challenge countdown. */
const timeRemaining = computed(() => {
  if (!challenge.value) {
    return 0
  }
  return Math.max(0, challenge.value.timeout - challenge.value.timeoutElapsed)
})

/** Progress fraction (0-1) of timeout elapsed. */
const timeoutProgress = computed(() => {
  if (!challenge.value || challenge.value.timeout === 0) {
    return 0
  }
  return Math.min(1, challenge.value.timeoutElapsed / challenge.value.timeout)
})

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
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ hasActive ? t('challenge.name.' + challenge.index) : t('challenge.title') }}</h2>
      <span class="modal-rule" />

      <!-- Active challenge section -->
      <template v-if="hasActive">
        <div class="active-challenge">
          <!-- Countdown timer -->
          <div v-if="challenge.isStarted" class="challenge-timer">
            <div class="timer-label">{{ t('challenge.timeRemaining') }}</div>
            <div class="timer-value" :class="{ 'timer-value--urgent': timeRemaining < 60 }">
              {{ formatTime(timeRemaining) }}
            </div>
            <div class="timer-bar">
              <div class="timer-bar-fill" :style="{ width: ((1 - timeoutProgress) * 100) + '%' }" />
            </div>
          </div>

          <!-- Requirements checklist -->
          <div class="requirements-section">
            <div class="section-label">{{ t('challenge.requirements') }}</div>
            <ul class="requirements-list">
              <li
                v-if="challenge.requirements.faith !== null"
                class="req-item"
                :class="{ 'req-item--met': isRequirementMet('faith', challenge.requirements.faith) }"
              >
                <span class="req-icon">{{ isRequirementMet('faith', challenge.requirements.faith) ? '✓' : '✗' }}</span>
                {{ t('challenge.requirement.faith', formatNumber(challenge.requirements.faith)) }}
              </li>
              <li
                v-if="challenge.requirements.altar !== null"
                class="req-item"
                :class="{ 'req-item--met': isRequirementMet('altar', challenge.requirements.altar) }"
              >
                <span class="req-icon">{{ isRequirementMet('altar', challenge.requirements.altar) ? '✓' : '✗' }}</span>
                {{ t('challenge.requirement.altar', challenge.requirements.altar) }}
              </li>
              <li
                v-if="challenge.requirements.temple !== null"
                class="req-item"
                :class="{ 'req-item--met': isRequirementMet('temple', challenge.requirements.temple) }"
              >
                <span class="req-icon">{{ isRequirementMet('temple', challenge.requirements.temple) ? '✓' : '✗' }}</span>
                {{ t('challenge.requirement.temple', challenge.requirements.temple) }}
              </li>
              <li
                v-if="challenge.requirements.monument !== null"
                class="req-item"
                :class="{ 'req-item--met': isRequirementMet('monument', challenge.requirements.monument) }"
              >
                <span class="req-icon">{{ isRequirementMet('monument', challenge.requirements.monument) ? '✓' : '✗' }}</span>
                {{ t('challenge.requirement.monument', challenge.requirements.monument) }}
              </li>
              <template v-if="challenge.requirements.resources !== null">
                <li
                  v-for="(amount, resource) in challenge.requirements.resources"
                  :key="resource"
                  class="req-item"
                  :class="{ 'req-item--met': isResourceMet(resource, amount) }"
                >
                  <span class="req-icon">{{ isResourceMet(resource, amount) ? '✓' : '✗' }}</span>
                  <img class="req-resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
                  {{ formatNumber(amount) }} {{ t('resource.' + resource) }}
                </li>
              </template>
              <li
                v-if="challenge.requirements.workers !== null"
                class="req-item"
                :class="{ 'req-item--met': isRequirementMet('workers', challenge.requirements.workers) }"
              >
                <span class="req-icon">{{ isRequirementMet('workers', challenge.requirements.workers) ? '✓' : '✗' }}</span>
                {{ t('challenge.requirement.workers', challenge.requirements.workers) }}
              </li>
            </ul>
          </div>
        </div>
      </template>

      <template v-else>
        <p class="no-active">{{ t('challenge.noneActive') }}</p>
      </template>

      <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
        {{ t('modal.help.close') }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 1.75rem 2rem 1.5rem;
  min-width: 360px;
  max-width: 440px;
  align-items: center;
  max-height: 85vh;
  overflow-y: auto;
}

.modal-title {
  text-align: center;
}

.modal-rule {
  margin: 0.75rem 0 1rem;
}

/* Active challenge block */
.active-challenge {
  width: 100%;
  padding: 1rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.12);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.03),
    rgba(var(--color-shadow-rgb), 0.06)
  );
  margin-bottom: 1rem;
}

/* Timer section */
.challenge-timer {
  text-align: center;
  margin-bottom: 1.5rem;
}

.timer-label {
  font-family: var(--font-body);
  font-size: 0.7rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.45);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 0.25rem;
}

.timer-value {
  font-family: var(--font-numeric);
  font-size: 1.5rem;
  font-weight: 500;
  color: rgba(var(--color-accent-rgb), 1);
  letter-spacing: 0.05em;
}

.timer-value--urgent {
  color: rgba(196, 80, 80, 1);
}

/* Timer progress bar */
.timer-bar {
  height: 3px;
  background: rgba(var(--color-text-rgb), 0.08);
  margin-top: 0.5rem;
}

.timer-bar-fill {
  height: 100%;
  background: rgba(var(--color-accent-rgb), 0.6);
  transition: width 1s linear;
}

/* Requirements */
.section-label {
  font-family: var(--font-display);
  font-weight: 400;
  font-size: 0.7rem;
  color: rgba(var(--color-text-rgb), 0.45);
  text-transform: uppercase;
  letter-spacing: 0.12em;
  margin-bottom: 0.5rem;
  align-self: flex-start;
}

.requirements-list {
  list-style: none;
  padding: 0;
  margin: 0;
  width: 100%;
}

.req-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-family: var(--font-body);
  font-size: 0.85rem;
  font-weight: 300;
  color: rgba(196, 80, 80, 0.9);
  padding: 0.3rem 0;
}

.req-item--met {
  color: rgba(80, 168, 80, 0.9);
}

.req-icon {
  font-size: 0.75rem;
  width: 1rem;
  text-align: center;
  flex-shrink: 0;
}

.req-resource-icon {
  width: 1rem;
  height: 1rem;
  flex-shrink: 0;
}

/* No active challenge */
.no-active {
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 300;
  color: rgba(var(--color-text-rgb), 0.5);
  margin-bottom: 1rem;
}

.modal-btn {
  margin-top: 0.5rem;
  align-self: stretch;
}
</style>
