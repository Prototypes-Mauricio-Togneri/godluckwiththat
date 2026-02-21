<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_RESOURCE_MAP, IMG_UNIT_WORKER} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
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
const canAffordRecruit = computed(() => colony.resources.canAfford(WORKER_RECRUIT_COST))
const canRecruitBeforeAfford = computed(() => colony.resources.workers < colony.stockpile.workers)
const canRecruit = computed(() => canAffordRecruit.value && canRecruitBeforeAfford.value)

const recruitTooltip = computed(() => {
  if (!canAffordRecruit.value) return t('building.insufficientResources')
  if (!canRecruitBeforeAfford.value) return t('building.maxPopulationReached')
  return t('house.recruitWorker')
})
const recruitCostEntries = computed(() => WORKER_RECRUIT_COST.entries())

function recruitWorker() {
  if (!canRecruit.value) return
  playTap()
  gameState.recruitWorker()
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <template #below-action>
      <div class="action-row">
        <span class="tooltip" :class="{ 'tooltip--delayed': canRecruit }" :data-tooltip="recruitTooltip">
          <button class="btn-gold action-btn" :disabled="!canRecruit" @click="recruitWorker">
            <img class="action-btn-icon" :src="IMG_UNIT_WORKER" :alt="t('house.recruitWorker')">
          </button>
        </span>
        <span class="action-cost">
          <span v-for="[key, amount] in recruitCostEntries" :key="key" class="action-cost-item">
            <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
            <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
          </span>
        </span>
      </div>
    </template>
  </BaseCard>
</template>

