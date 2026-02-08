<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import Headquarters from '@/js/models/buildings/headquarters.js'
import {WORKER_RECRUIT_COST, HQ_TYPES} from '@/js/constants.js'
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
      <div class="hq-action-row">
        <span class="tooltip" :data-tooltip="t('headquarters.recruitWorker')">
          <button class="btn-gold hq-btn" :disabled="!canRecruit" @click="recruitWorker">
            <img class="hq-btn-icon" src="/img/units/worker.png" :alt="t('headquarters.recruitWorker')">
          </button>
        </span>
        <span class="hq-cost">
          <span v-for="[key, amount] in recruitCostEntries" :key="key" class="hq-cost-item">
            <img class="hq-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="hq-cost-amount" :class="{ 'hq-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
          </span>
        </span>
      </div>

      <div class="hq-action-row">
        <span class="tooltip" :data-tooltip="t('headquarters.levelUp')">
          <button class="btn-gold hq-btn" :disabled="!canLevelUp" @click="levelUp">
            <img class="hq-btn-icon" src="/img/other/upgrade.png" :alt="t('headquarters.levelUp')">
          </button>
        </span>
        <span class="hq-cost">
          <span v-for="[key, amount] in levelUpCostEntries" :key="key" class="hq-cost-item">
            <img class="hq-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="hq-cost-amount" :class="{ 'hq-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
          </span>
        </span>
      </div>

      <div v-if="!isMaxType" class="hq-action-row">
        <span class="tooltip" :data-tooltip="t('headquarters.upgrade')">
          <button class="btn-gold hq-btn" :disabled="!canUpgrade" @click="upgradeType">
            <img class="hq-btn-icon" src="/img/other/headquarters_upgrade.png" :alt="t('headquarters.upgrade')">
          </button>
        </span>
        <span class="hq-cost">
          <span v-for="[key, amount] in upgradeCostEntries" :key="key" class="hq-cost-item">
            <img class="hq-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="hq-cost-amount" :class="{ 'hq-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
          </span>
        </span>
      </div>
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
  font-size: 0.8rem;
  font-weight: 300;
  color: rgba(var(--color-accent-rgb), 0.55);
  letter-spacing: 0.04em;
}

.hq-workers-value {
  font-family: var(--font-body);
  font-size: 0.8rem;
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
  gap: 0.3rem;
  margin-top: 0.35rem;
}

.hq-action-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.hq-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  padding: 0;
  border-radius: 4px;
  flex-shrink: 0;
}

.hq-btn-icon {
  width: 1.6rem;
  height: 1.6rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.4));
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
  width: 0.9rem;
  height: 0.9rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.3));
}

.hq-cost-amount {
  font-family: var(--font-body);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.8);
  letter-spacing: 0.02em;
}

.hq-cost-short {
  color: #c45050;
}
</style>
