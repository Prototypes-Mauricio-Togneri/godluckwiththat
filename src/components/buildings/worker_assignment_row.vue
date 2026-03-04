<script setup>
import {computed, inject} from 'vue'
import {IMG_UNIT_WORKER} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {BULK_WORKER_AMOUNT, WORKER_RECRUIT_COST} from '@/js/engine/balancing.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  buildingKey: {
    type: String,
    required: true,
  },
})

const colony = inject('colony')
const state = inject('state')

const building = computed(() => colony.buildings[props.buildingKey])
const maxWorkers = computed(() => building.value.maxWorkers)
const canRecruit = computed(() =>
  colony.resources.workers < colony.buildings.house.workersCap
  && colony.resources.canAfford(WORKER_RECRUIT_COST),
)
const canAssign = computed(() =>
  building.value.workers < maxWorkers.value
  && (colony.idleWorkers > 0 || canRecruit.value),
)
const canUnassign = computed(() => !building.value.isEmpty)

/** Assigns worker(s) to this building (recruits if needed). Ctrl+Click assigns up to 10. */
function assign(event) {
  if (!canAssign.value) {
    return
  }
  playTap()
  const count = event.ctrlKey || event.metaKey ? BULK_WORKER_AMOUNT : 1
  state.assignWorkers(props.buildingKey, count)
}

/** Removes worker(s) from this building back to idle. Ctrl+Click unassigns up to 10. */
function unassign(event) {
  if (!canUnassign.value) {
    return
  }
  playTap()
  const count = event.ctrlKey || event.metaKey ? BULK_WORKER_AMOUNT : 1
  state.unassignWorkers(props.buildingKey, count)
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
    <span class="tooltip tooltip--delayed" :data-tooltip="t('worker.assign')">
      <button class="worker-btn worker-btn--plus" :disabled="!canAssign" @click="assign">
        +
      </button>
    </span>
  </div>
</template>
