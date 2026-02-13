<script setup>
import {computed, inject} from 'vue'
import {WORKERS_PER_LEVEL} from '@/js/engine/balancing.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  buildingKey: {
    type: String,
    required: true,
  },
})

const colony = inject('colony')
const gameState = inject('gameState')

const building = computed(() => colony.buildings[props.buildingKey])
const maxWorkers = computed(() => building.value.level * WORKERS_PER_LEVEL)
const canAssign = computed(() => colony.idleWorkers > 0 && building.value.workers < maxWorkers.value)
const canUnassign = computed(() => building.value.workers > 0)

function assign() {
  if (!canAssign.value) return
  gameState.assignWorker(props.buildingKey)
}

function unassign() {
  if (!canUnassign.value) return
  gameState.unassignWorker(props.buildingKey)
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
      <img class="worker-count-icon" src="/img/units/worker.png" :alt="t('resource.idleWorkers')">
      <span class="worker-count-text" :class="{'worker-count-text--zero': building.workers === 0}">{{ building.workers }}/{{ maxWorkers }}</span>
    </span>
    <span class="tooltip tooltip--delayed" :data-tooltip="t('worker.assign')">
      <button class="worker-btn worker-btn--plus" :disabled="!canAssign" @click="assign">
        +
      </button>
    </span>
  </div>
</template>
