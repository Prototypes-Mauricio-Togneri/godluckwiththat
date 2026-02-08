<script setup>
import {computed, inject} from 'vue'
import BaseCard from './base_card.vue'
import Headquarters from '../../js/models/buildings/headquarters.js'
import {WORKER_RECRUIT_COST, HQ_TYPES} from '../../js/constants.js'
import {t} from '../../js/i18n/localized.js'

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
const hq = computed(() => colony.buildings[props.buildingKey])

const nameKey = computed(() => `building.headquarters.${hq.value.type}`)

// Worker display
const totalWorkers = computed(() => colony.resources.workers)
const idleWorkers = computed(() => colony.idleWorkers)

// Recruit worker
const canRecruit = computed(() =>
  WORKER_RECRUIT_COST.canAfford(colony.resources)
  && colony.resources.workers < colony.stockpile.workers,
)
const recruitCostEntries = computed(() => WORKER_RECRUIT_COST.entries())

function recruitWorker() {
  if (!canRecruit.value) return
  WORKER_RECRUIT_COST.deductFrom(colony.resources)
  colony.resources.workers += 1
  colony.idleWorkers += 1
}

// Level up
const levelUpCost = computed(() => Headquarters.levelUpCost(hq.value.level))
const canLevelUp = computed(() => levelUpCost.value.canAfford(colony.resources))
const levelUpCostEntries = computed(() => levelUpCost.value.entries())

function levelUp() {
  if (!canLevelUp.value) return
  levelUpCost.value.deductFrom(colony.resources)
  hq.value.level += 1
}

// Upgrade type
const isMaxType = computed(() => hq.value.type === HQ_TYPES[HQ_TYPES.length - 1])
const upgradeCost = computed(() => Headquarters.upgradeCost(hq.value.type))
const canUpgrade = computed(() => upgradeCost.value !== null && upgradeCost.value.canAfford(colony.resources))
const upgradeCostEntries = computed(() => upgradeCost.value?.entries() ?? [])

function upgradeType() {
  if (!canUpgrade.value) return
  upgradeCost.value.deductFrom(colony.resources)
  hq.value.type = Headquarters.nextType(hq.value.type)
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building" :name-key="nameKey">
    <div class="hq-workers">
      <span class="hq-workers-label">{{ t('headquarters.workers') }}</span>
      <span class="hq-workers-value">{{ idleWorkers }}<span class="hq-workers-sep">/</span>{{ totalWorkers }}</span>
    </div>

    <div class="hq-actions">
      <button class="btn-gold hq-btn" :disabled="!canRecruit" @click="recruitWorker">
        <span class="hq-btn-label">{{ t('headquarters.recruitWorker') }}</span>
        <span class="hq-cost">
          <span v-for="[key, amount] in recruitCostEntries" :key="key" class="hq-cost-item">
            <img class="hq-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="hq-cost-amount">{{ amount }}</span>
          </span>
        </span>
      </button>

      <button class="btn-gold hq-btn" :disabled="!canLevelUp" @click="levelUp">
        <span class="hq-btn-label">{{ t('headquarters.levelUp') }}</span>
        <span class="hq-cost">
          <span v-for="[key, amount] in levelUpCostEntries" :key="key" class="hq-cost-item">
            <img class="hq-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="hq-cost-amount">{{ amount }}</span>
          </span>
        </span>
      </button>

      <button v-if="!isMaxType" class="btn-gold hq-btn" :disabled="!canUpgrade" @click="upgradeType">
        <span class="hq-btn-label">{{ t('headquarters.upgrade') }}</span>
        <span class="hq-cost">
          <span v-for="[key, amount] in upgradeCostEntries" :key="key" class="hq-cost-item">
            <img class="hq-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="hq-cost-amount">{{ amount }}</span>
          </span>
        </span>
      </button>
    </div>
  </BaseCard>
</template>

<style scoped>
.hq-workers {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  margin-top: 0.1rem;
}

.hq-workers-label {
  font-family: var(--font-body);
  font-size: 0.7rem;
  font-weight: 300;
  color: rgba(var(--color-accent-rgb), 0.55);
  letter-spacing: 0.04em;
}

.hq-workers-value {
  font-family: var(--font-body);
  font-size: 0.7rem;
  font-weight: 500;
  color: var(--color-text);
  letter-spacing: 0.02em;
}

.hq-workers-sep {
  margin: 0 0.1rem;
  color: rgba(var(--color-accent-rgb), 0.35);
  font-weight: 300;
}

.hq-actions {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  margin-top: 0.35rem;
}

.hq-btn {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.4rem;
  padding: 0.2rem 0.4rem;
  font-size: 0.6rem;
  letter-spacing: 0.08em;
  border-radius: 3px;
  line-height: 1;
}

.hq-btn-label {
  font-family: var(--font-body);
}

.hq-cost {
  display: flex;
  align-items: center;
  gap: 0.35rem;
}

.hq-cost-item {
  display: flex;
  align-items: center;
  gap: 0.12rem;
}

.hq-cost-icon {
  width: 0.8rem;
  height: 0.8rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.3));
}

.hq-cost-amount {
  font-family: var(--font-body);
  font-size: 0.6rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.8);
  letter-spacing: 0.02em;
}
</style>
