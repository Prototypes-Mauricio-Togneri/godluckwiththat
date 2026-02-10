<script setup>
import {computed, inject} from 'vue'
import {WORKERS_PER_LEVEL} from '@/js/balancing.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  buildingKey: {
    type: String,
    required: true,
  },
})

const colony = inject('colony')

const building = computed(() => colony.buildings[props.buildingKey])
const maxWorkers = computed(() => building.value.level * WORKERS_PER_LEVEL)
const canAssign = computed(() => colony.idleWorkers > 0 && building.value.workers < maxWorkers.value)
const canUnassign = computed(() => building.value.workers > 0)

function assign() {
  if (!canAssign.value) return
  colony.buildings[props.buildingKey].workers += 1
  colony.idleWorkers -= 1
}

function unassign() {
  if (!canUnassign.value) return
  colony.buildings[props.buildingKey].workers -= 1
  colony.idleWorkers += 1
}
</script>

<template>
  <div class="worker-row">
    <span class="tooltip" :data-tooltip="t('worker.unassign')">
      <button class="worker-btn worker-btn--minus" :disabled="!canUnassign" @click="unassign">
        &minus;
      </button>
    </span>
    <span class="worker-count">
      <img class="worker-count-icon" src="/img/units/worker.png" :alt="t('resource.idleWorkers')">
      <span class="worker-count-text">{{ building.workers }}/{{ maxWorkers }}</span>
    </span>
    <span class="tooltip" :data-tooltip="t('worker.assign')">
      <button class="worker-btn worker-btn--plus" :disabled="!canAssign" @click="assign">
        +
      </button>
    </span>
  </div>
</template>
