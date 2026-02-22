<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_OTHER_TERRITORY, IMG_OTHER_UPGRADE, IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {formatTime} from '@/js/engine/format.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  buildingKey: {
    type: String,
    required: true,
  },
  img: {
    type: String,
    required: true,
  },
  building: {
    type: Object,
    required: true,
  },
})

const colony = inject('colony')
const gameState = inject('gameState')
const hq = computed(() => colony.buildings[props.buildingKey])

const nameKey = computed(() => `building.headquarters.${hq.value.type}`)

// Construction state
const isLevelingUp = computed(() => hq.value.isConstructing)
const levelUpProgress = computed(() => {
  if (!isLevelingUp.value || hq.value.constructionDuration === 0) return 0
  return 1 - hq.value.constructionRemaining / hq.value.constructionDuration
})
const isUpgrading = computed(() => hq.value.isUpgrading)
const upgradeProgress = computed(() => {
  if (!isUpgrading.value || hq.value.upgradeDuration === 0) return 0
  return 1 - hq.value.upgradeRemaining / hq.value.upgradeDuration
})
const isBusy = computed(() => isLevelingUp.value || isUpgrading.value)

// Level up
const levelUpCost = computed(() => hq.value.levelUpCost())
const canAffordLevelUp = computed(() => colony.resources.canAfford(levelUpCost.value))
const canLevelUp = computed(() => !isBusy.value && canAffordLevelUp.value)
const levelUpCostEntries = computed(() => levelUpCost.value?.entries() ?? new Map())
const levelUpTooltip = computed(() => {
  if (isLevelingUp.value) return ''
  if (!isBusy.value && !canAffordLevelUp.value) return t('building.insufficientResources')
  return t('headquarters.expandTerritory')
})

function levelUp() {
  if (!canLevelUp.value) return
  playTap()
  gameState.levelUpHeadquarters()
}

// Upgrade type
const isMaxType = computed(() => hq.value.isMaxType)
const nextType = computed(() => hq.value.nextType())
const upgradeLabel = computed(() =>
  nextType.value ? t('headquarters.upgrade', t(`building.headquarters.${nextType.value}`).toLowerCase()) : '',
)
const upgradeCost = computed(() => hq.value.upgradeCost())
const canAffordUpgrade = computed(() => upgradeCost.value !== null && colony.resources.canAfford(upgradeCost.value))
const canUpgrade = computed(() => !isBusy.value && canAffordUpgrade.value)
const upgradeTooltip = computed(() => {
  if (isUpgrading.value) return ''
  if (!isBusy.value && upgradeCost.value !== null && !canAffordUpgrade.value) return t('building.insufficientResources')
  return upgradeLabel.value
})
const upgradeCostEntries = computed(() => upgradeCost.value?.entries() ?? new Map())

function upgradeType() {
  if (!canUpgrade.value) return
  playTap()
  gameState.upgradeHeadquarters()
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building" :name-key="nameKey" :show-build-action="false" :show-level="false">
    <div v-if="!isMaxType" class="action-row" :class="{ 'action-row--disabled': !canUpgrade }">
      <span class="tooltip" :class="{ 'tooltip--delayed': canUpgrade }" :data-tooltip="upgradeTooltip">
        <button
          class="btn-gold action-btn"
          :class="{ 'action-btn--constructing': isUpgrading }"
          :style="isUpgrading ? { '--progress': (upgradeProgress * 100) + '%' } : undefined"
          :disabled="!canUpgrade"
          @click="upgradeType"
        >
          <img v-if="!isUpgrading" class="action-btn-icon" :src="IMG_OTHER_UPGRADE" :alt="upgradeLabel">
          <span v-else class="action-btn-time">{{ formatTime(hq.upgradeRemaining) }}</span>
        </button>
      </span>
      <span v-if="!isUpgrading" class="action-cost">
        <span v-for="[key, amount] in upgradeCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
        </span>
      </span>
    </div>

    <div class="action-row" :class="{ 'action-row--disabled': !canLevelUp }">
      <span class="tooltip" :class="{ 'tooltip--delayed': canLevelUp }" :data-tooltip="levelUpTooltip">
        <button
          class="btn-gold action-btn"
          :class="{ 'action-btn--constructing': isLevelingUp }"
          :style="isLevelingUp ? { '--progress': (levelUpProgress * 100) + '%' } : undefined"
          :disabled="!canLevelUp"
          @click="levelUp"
        >
          <img v-if="!isLevelingUp" class="action-btn-icon" :src="IMG_OTHER_TERRITORY" :alt="t('headquarters.expandTerritory')">
          <span v-else class="action-btn-time">{{ formatTime(hq.constructionRemaining) }}</span>
        </button>
      </span>
      <span v-if="!isLevelingUp" class="action-cost">
        <span v-for="[key, amount] in levelUpCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
        </span>
      </span>
    </div>
  </BaseCard>
</template>

