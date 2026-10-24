<script setup>
import {computed, inject} from 'vue'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
  unitType: {
    type: String,
    required: true,
  },
})

const ui = inject('ui')

const unit = computed(() => ui.military.units.find(entry => entry.type === props.unitType))
</script>

<template>
  <div v-if="unit" class="unit-count-row">
    <span class="worker-count">
      <span class="unit-count-name">{{ t('unit.' + unitType) }}</span>
      <span class="worker-count-text" :class="{ 'worker-count-text--zero': unit.count === 0 }">{{ unit.count }}/{{ unit.cap }}</span>
    </span>
  </div>
</template>

<style scoped>
/* Same height as the worker row on producer cards */
.unit-count-row {
  display: flex;
  align-items: center;
  min-height: 1.75rem;
  min-height: 28cqh;
}

/* Unit type name before the count */
.unit-count-name {
  font-family: var(--font-body);
  color: rgba(var(--color-text-rgb), 0.6);
}
</style>
