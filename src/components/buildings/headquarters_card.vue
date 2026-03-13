<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_OTHER_TERRITORY, IMG_OTHER_UPGRADE, IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {formatNumber, formatNumberFull, formatTime} from '@/js/engine/format.js'
import {canAffordCost} from '@/js/engine/utils.js'
import {t} from '@/js/i18n/localized.js'

defineProps({
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

const ui = inject('ui')
const actions = inject('actions')

const nameKey = computed(() => `building.headquarters.${ui.hq.type}`)

// Construction state
const isLevelingUp = computed(() => ui.hq.isConstructing)
const levelUpProgress = computed(() => {
  if (!isLevelingUp.value || ui.hq.constructionDuration === 0) {
    return 0
  }
  return 1 - ui.hq.constructionRemaining / ui.hq.constructionDuration
})
const isUpgrading = computed(() => ui.hq.isUpgrading)
const upgradeProgress = computed(() => {
  if (!isUpgrading.value || ui.hq.upgradeDuration === 0) {
    return 0
  }
  return 1 - ui.hq.upgradeRemaining / ui.hq.upgradeDuration
})
const isBusy = computed(() => isLevelingUp.value || isUpgrading.value)

// Level up
const levelUpCost = computed(() => ui.expansionCost)
const canAffordLevelUp = computed(() => canAffordCost(ui.resources, levelUpCost.value))
const canLevelUp = computed(() => !isBusy.value && canAffordLevelUp.value)
const levelUpCostEntries = computed(() => ui.expansionCostEntries ?? [])
const levelUpTooltip = computed(() => {
  if (isLevelingUp.value) {
    return ''
  }
  if (!isBusy.value && !canAffordLevelUp.value) {
    return t('building.insufficientResources')
  }
  return t('headquarters.expandTerritory')
})

function levelUp() {
  if (!canLevelUp.value) {
    return
  }
  playTap()
  actions.expandTerritory()
}

// Upgrade type
const isMaxType = computed(() => ui.hq.isMaxType)
const nextType = computed(() => ui.hq.nextType)
const upgradeLabel = computed(() =>
  nextType.value ? t('headquarters.upgrade', t(`building.headquarters.${nextType.value}`).toLowerCase()) : '',
)
const upgradeCost = computed(() => ui.hq.upgradeCost)
const canAffordUpgrade = computed(() => upgradeCost.value !== null && canAffordCost(ui.resources, upgradeCost.value))
const canUpgrade = computed(() => !isBusy.value && canAffordUpgrade.value)
const upgradeTooltip = computed(() => {
  if (isUpgrading.value) {
    return ''
  }
  if (!isBusy.value && upgradeCost.value !== null && !canAffordUpgrade.value) {
    return t('building.insufficientResources')
  }
  return upgradeLabel.value
})
const upgradeCostEntries = computed(() => ui.hq.upgradeCostEntries ?? [])

function upgradeType() {
  if (!canUpgrade.value) {
    return
  }
  playTap()
  actions.upgradeHeadquarters()
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
          <span v-else class="action-btn-time">{{ formatTime(ui.hq.upgradeRemaining) }}</span>
        </button>
      </span>
      <span v-if="!isUpgrading" class="action-cost">
        <span v-for="[key, amount] in upgradeCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': ui.resources[key] < amount }">{{ formatNumber(amount) }}</span>
        </span>
        <div class="action-cost-tooltip">
          <template v-for="[key, amount] in upgradeCostEntries" :key="key">
            <span>{{ t(`resource.${key}`) }}:</span>
            <span class="action-cost-tooltip-amount">{{ formatNumberFull(amount) }}</span>
          </template>
        </div>
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
          <span v-else class="action-btn-time">{{ formatTime(ui.hq.constructionRemaining) }}</span>
        </button>
      </span>
      <span v-if="!isLevelingUp" class="action-cost">
        <span v-for="[key, amount] in levelUpCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': ui.resources[key] < amount }">{{ formatNumber(amount) }}</span>
        </span>
        <div class="action-cost-tooltip">
          <template v-for="[key, amount] in levelUpCostEntries" :key="key">
            <span>{{ t(`resource.${key}`) }}:</span>
            <span class="action-cost-tooltip-amount">{{ formatNumberFull(amount) }}</span>
          </template>
        </div>
      </span>
    </div>
  </BaseCard>
</template>

