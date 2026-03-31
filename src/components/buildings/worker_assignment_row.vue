<script setup>
import {computed, inject} from 'vue'
import {IMG_RESOURCE_FOOD, IMG_UNIT_WORKER} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {BULK_WORKER_AMOUNT, WORKER_RECRUIT_COST} from '@/js/engine/balancing.js'
import {formatNumber} from '@/js/engine/format.js'
import {canAffordCost} from '@/js/engine/utils.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  buildingKey: {
    type: String,
    required: true,
  },
})

const ui = inject('ui')
const actions = inject('actions')

const building = computed(() => ui.buildings[props.buildingKey])
const maxWorkers = computed(() => building.value.maxWorkers)
const canRecruit = computed(() =>
  ui.resources.workers < ui.workersCap
  && canAffordCost(ui.resources, WORKER_RECRUIT_COST),
)
const canAssign = computed(() =>
  building.value.workers < maxWorkers.value
  && (ui.idleWorkers > 0 || canRecruit.value),
)
const canUnassign = computed(() => !building.value.isEmpty)

// True when assigning would recruit a new worker (no idle workers available)
const isRecruitMode = computed(() => ui.idleWorkers === 0)
const assignTooltip = computed(() => isRecruitMode.value ? t('worker.recruit') : t('worker.assign'))
const recruitCost = computed(() => WORKER_RECRUIT_COST.entries.get('food') ?? 0)

/** Assigns worker(s) to this building (recruits if needed). Ctrl+Click assigns up to 10. */
function assign(event) {
  if (!canAssign.value) {
    return
  }
  playTap()
  const count = event.ctrlKey || event.metaKey ? BULK_WORKER_AMOUNT : 1
  actions.assignWorkers(props.buildingKey, count)
}

/** Removes worker(s) from this building back to idle. Ctrl+Click unassigns up to 10. */
function unassign(event) {
  if (!canUnassign.value) {
    return
  }
  playTap()
  const count = event.ctrlKey || event.metaKey ? BULK_WORKER_AMOUNT : 1
  actions.unassignWorkers(props.buildingKey, count)
}
</script>

<template>
  <div class="worker-row">
    <span class="tooltip tooltip--delayed" :data-tooltip="t('worker.unassign')">
      <button class="worker-btn worker-btn--minus" :disabled="!canUnassign" @click="unassign">
        &minus;
      </button>
    </span>
    <span class="worker-count">
      <img class="worker-count-icon" :src="IMG_UNIT_WORKER" :alt="t('resource.idleWorkers')">
      <span class="worker-count-text" :class="{'worker-count-text--zero': building.isEmpty}">{{ building.workers }}/{{ maxWorkers }}</span>
    </span>
    <span class="tooltip tooltip--delayed" :data-tooltip="assignTooltip">
      <button class="worker-btn worker-btn--plus" :disabled="!canAssign" @click="assign">
        +
      </button>
    </span>
    <span v-if="isRecruitMode" class="action-cost-item recruit-cost">
      <img class="action-cost-icon" :src="IMG_RESOURCE_FOOD" :alt="t('resource.food')">
      <span class="action-cost-amount">{{ formatNumber(recruitCost) }}</span>
    </span>
  </div>
</template>
