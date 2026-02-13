<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {WORKER_RECRUIT_COST} from '@/js/engine/balancing.js'
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
const gameState = inject('gameState')

// Recruit worker
const canRecruit = computed(() =>
  colony.resources.canAfford(WORKER_RECRUIT_COST)
  && colony.resources.workers < colony.stockpile.workers,
)
const recruitCostEntries = computed(() => WORKER_RECRUIT_COST.entries())

function recruitWorker() {
  if (!canRecruit.value) return
  gameState.recruitWorker()
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <div class="action-row">
      <span class="tooltip tooltip--delayed" :data-tooltip="t('house.recruitWorker')">
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
  </BaseCard>
</template>

