<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import Headquarters from '@/js/models/buildings/headquarters.js'
import {HQ_TYPES} from '@/js/constants.js'
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
const onAction = inject('onAction')
const hq = computed(() => colony.buildings[props.buildingKey])

const nameKey = computed(() => `building.headquarters.${hq.value.type}`)

// Level up
const levelUpCost = computed(() => Headquarters.levelUpCost(hq.value.level))
const canLevelUp = computed(() => levelUpCost.value.canAfford(colony.resources))
const levelUpCostEntries = computed(() => levelUpCost.value.entries())

function levelUp() {
  if (!canLevelUp.value) return
  levelUpCost.value.deductFrom(colony.resources)
  hq.value.level += 1
  onAction()
}

// Upgrade type
const isMaxType = computed(() => hq.value.type === HQ_TYPES[HQ_TYPES.length - 1])
const upgradeCost = computed(() => Headquarters.upgradeCost(hq.value.type))
const canUpgrade = computed(() => upgradeCost.value !== null && upgradeCost.value.canAfford(colony.resources))
const upgradeCostEntries = computed(() => upgradeCost.value?.entries() ?? new Map())

function upgradeType() {
  if (!canUpgrade.value) return
  upgradeCost.value.deductFrom(colony.resources)
  hq.value.type = Headquarters.nextType(hq.value.type)
  onAction()
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building" :name-key="nameKey" :show-build-action="false">
    <div class="action-row">
      <span class="tooltip" :data-tooltip="t('headquarters.levelUp')">
        <button class="btn-gold action-btn" :disabled="!canLevelUp" @click="levelUp">
          <img class="action-btn-icon" src="/img/other/upgrade.png" :alt="t('headquarters.levelUp')">
        </button>
      </span>
      <span class="action-cost">
        <span v-for="[key, amount] in levelUpCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
        </span>
      </span>
    </div>

    <div v-if="!isMaxType" class="action-row">
      <span class="tooltip" :data-tooltip="t('headquarters.upgrade')">
        <button class="btn-gold action-btn" :disabled="!canUpgrade" @click="upgradeType">
          <img class="action-btn-icon" src="/img/other/headquarters_upgrade.png" :alt="t('headquarters.upgrade')">
        </button>
      </span>
      <span class="action-cost">
        <span v-for="[key, amount] in upgradeCostEntries" :key="key" class="action-cost-item">
          <img class="action-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
          <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
        </span>
      </span>
    </div>
  </BaseCard>
</template>

