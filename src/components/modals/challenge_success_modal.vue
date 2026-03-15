<script setup>
import {inject, ref, onMounted, onUnmounted} from 'vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {SND_NOTIFICATION_BLESSING} from '@/js/engine/assets.js'
import {t} from '@/js/i18n/localized.js'

const ui = inject('ui')
const actions = inject('actions')
const visible = ref(false)
let rafId = null

/** Returns a human-readable description for a blessing. */
function blessingDescription(blessing) {
  const pct = blessing.productivity ? Math.round(blessing.productivity * 100) : 0
  const sec = blessing.timeout ?? 0
  switch (blessing.type) {
    case 'fertileSoil': return t('blessing.fertileSoil.description', pct, sec)
    case 'forestBloom': return t('blessing.forestBloom.description', pct, sec)
    case 'giftFromTheHeavens': return t('blessing.giftFromTheHeavens.description')
    case 'holyExpansion': return t('blessing.holyExpansion.description', blessing.territory)
    case 'richMines': return t('blessing.richMines.description', pct, sec)
    case 'celestialProsperity': return t('blessing.celestialProsperity.description', pct, sec)
    case 'rapidConstruction': return t('blessing.rapidConstruction.description', Math.round((blessing.construction ?? 0) * 100), sec)
    case 'favorableWeather': return t('blessing.favorableWeather.description', sec)
    case 'wisdomOfTheGods': return t('blessing.wisdomOfTheGods.description', pct, sec)
    case 'blessedMarkets': return t('blessing.blessedMarkets.description', sec)
    default: return ''
  }
}

/** Block Escape — this modal cannot be dismissed. */
function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown, true)
  audio.playSound(SND_NOTIFICATION_BLESSING)
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
      <h2 class="modal-title modal-title--reward">{{ t('challenge.reward.title') }}</h2>
      <span class="modal-rule modal-rule--reward" />

      <p class="modal-description">{{ t('challenge.reward.description') }}</p>

      <!-- Blessing choices -->
      <div class="blessing-choices">
        <div
          v-for="(blessing, index) in ui.challenges.activeBlessingChoices"
          :key="index"
          class="blessing-card"
        >
          <div class="blessing-name">{{ t('blessing.' + blessing.type) }}</div>
          <p class="blessing-description">{{ blessingDescription(blessing) }}</p>
          <button class="btn-gold blessing-btn" @click="playTap(); actions.selectBlessing(index)">
            {{ t('challenge.reward.choose') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 1.75rem 2.5rem 1.5rem;
  min-width: 380px;
  max-width: 520px;
  align-items: center;
}

.modal-title--reward {
  color: rgba(var(--color-accent-rgb), 1);
}

.modal-rule--reward {
  margin: 1rem 0 1.25rem;
}

.modal-description {
  text-align: center;
  margin-bottom: 1.25rem;
}

/* Blessing cards laid out side by side */
.blessing-choices {
  display: flex;
  gap: 0.75rem;
  width: 100%;
}

.blessing-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 1rem 0.75rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.15);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.04),
    rgba(var(--color-shadow-rgb), 0.08)
  );
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.blessing-card:hover {
  border-color: rgba(var(--color-accent-rgb), 0.35);
  box-shadow: 0 0 12px rgba(var(--color-accent-rgb), 0.08);
}

.blessing-name {
  font-family: var(--font-display);
  font-weight: 600;
  font-size: 0.85rem;
  color: rgba(var(--color-accent-rgb), 1);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  text-align: center;
  margin-bottom: 0.5rem;
}

.blessing-description {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 300;
  color: rgba(var(--color-text-rgb), 0.65);
  text-align: center;
  line-height: 1.5;
  flex: 1;
  margin-bottom: 0.75rem;
}

.blessing-btn {
  font-size: 0.7rem;
  letter-spacing: 0.12em;
  padding: 0.45rem 1.2rem;
  align-self: stretch;
}
</style>
