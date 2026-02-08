<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {WORKER_RECRUIT_COST} from '@/js/constants.js'
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

const colony = inject('colony')

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
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <div class="house-actions">
      <div class="action-row">
        <span class="tooltip" :data-tooltip="t('house.recruitWorker')">
          <button class="btn-gold action-btn" :disabled="!canRecruit" @click="recruitWorker">
            <img class="action-btn-icon" src="/img/units/worker.png" :alt="t('house.recruitWorker')">
          </button>
        </span>
        <span class="action-cost">
          <span v-for="[key, amount] in recruitCostEntries" :key="key" class="action-cost-item">
            <img class="action-cost-icon" :src="`/img/resources/${key}.png`" :alt="t(`resource.${key}`)">
            <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
          </span>
        </span>
      </div>
    </div>
  </BaseCard>
</template>

<style scoped>
.house-actions {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
  margin-top: 0.35rem;
}
</style>
