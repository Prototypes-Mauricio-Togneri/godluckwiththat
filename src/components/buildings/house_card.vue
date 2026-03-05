<script setup>
import {computed, inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_RESOURCE_MAP, IMG_UNIT_WORKER} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {WORKER_RECRUIT_COST} from '@/js/engine/balancing.js'
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

// Recruit worker
const canAffordRecruit = computed(() => canAffordCost(ui.resources, WORKER_RECRUIT_COST))
const canRecruitBeforeAfford = computed(() => ui.resources.workers < ui.workersCap)
const canRecruit = computed(() => canAffordRecruit.value && canRecruitBeforeAfford.value)

const recruitTooltip = computed(() => {
  if (!canAffordRecruit.value) {
    return t('building.insufficientResources')
  }
  if (!canRecruitBeforeAfford.value) {
    return t('building.maxPopulationReached')
  }
  return t('house.recruitWorker')
})
const recruitCostEntries = computed(() => WORKER_RECRUIT_COST.entries)

/** Recruits a new worker if affordable and below population cap. */
function recruitWorker() {
  if (!canRecruit.value) {
    return
  }
  playTap()
  actions.recruitWorker()
}
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <template #below-action>
      <div class="action-row" :class="{ 'action-row--disabled': !canRecruit }">
        <span class="tooltip" :class="{ 'tooltip--delayed': canRecruit }" :data-tooltip="recruitTooltip">
          <button class="btn-gold action-btn" :disabled="!canRecruit" @click="recruitWorker">
            <img class="action-btn-icon" :src="IMG_UNIT_WORKER" :alt="t('house.recruitWorker')">
          </button>
        </span>
        <span class="action-cost">
          <span v-for="[key, amount] in recruitCostEntries" :key="key" class="action-cost-item">
            <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
            <span class="action-cost-amount" :class="{ 'action-cost-short': ui.resources[key] < amount }">{{ amount }}</span>
          </span>
        </span>
      </div>
    </template>
  </BaseCard>
</template>

