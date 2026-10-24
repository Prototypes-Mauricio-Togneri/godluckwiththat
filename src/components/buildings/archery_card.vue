<script setup>
import BaseCard from '@/components/buildings/base_card.vue'
import MilitaryCardButton from '@/components/buildings/military_card_button.vue'
import UnitCountRow from '@/components/buildings/unit_count_row.vue'
import {UNIT_ARCHER} from '@/js/engine/enums.js'

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
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <MilitaryCardButton />
    <template #below-action>
      <UnitCountRow :unit-type="UNIT_ARCHER" />
    </template>
  </BaseCard>
</template>
