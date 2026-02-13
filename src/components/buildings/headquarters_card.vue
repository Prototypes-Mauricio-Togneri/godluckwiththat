<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {HQ_TYPES} from '@/js/engine/constants.js'
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

// Level up
const levelUpCost = computed(() => hq.value.levelUpCost())
const canLevelUp = computed(() => colony.resources.canAfford(levelUpCost.value))
const levelUpCostEntries = computed(() => levelUpCost.value.entries())

function levelUp() {
  if (!canLevelUp.value) return
  gameState.levelUpHeadquarters()
}

// Upgrade type
const isMaxType = computed(() => hq.value.type === HQ_TYPES[HQ_TYPES.length - 1])
const upgradeCost = computed(() => hq.value.upgradeCost())
const canUpgrade = computed(() => upgradeCost.value !== null && colony.resources.canAfford(upgradeCost.value))
const upgradeCostEntries = computed(() => upgradeCost.value?.entries() ?? new Map())

function upgradeType() {
  if (!canUpgrade.value) return
  gameState.upgradeHeadquarters()
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building" :name-key="nameKey" :show-build-action="false" :show-level="false">
    <div v-if="!isMaxType" class="action-row">
      <span class="tooltip tooltip--delayed" :data-tooltip="t('headquarters.upgrade')">
        <button class="btn-gold action-btn" :disabled="!canUpgrade" @click="upgradeType">
          <img class="action-btn-icon" src="/img/other/upgrade.png" :alt="t('headquarters.upgrade')">
        </button>
      </span>
      <span class="action-cost">
        <span v-for="[key, amount] in upgradeCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
        </span>
      </span>
    </div>

    <div class="action-row">
      <span class="tooltip tooltip--delayed" :data-tooltip="t('headquarters.expandTerritory')">
        <button class="btn-gold action-btn" :disabled="!canLevelUp" @click="levelUp">
          <img class="action-btn-icon" src="/img/other/territory.png" :alt="t('headquarters.expandTerritory')">
        </button>
      </span>
      <span class="action-cost">
        <span v-for="[key, amount] in levelUpCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
        </span>
      </span>
    </div>
  </BaseCard>
</template>

