<script setup>
import BaseCard from '@/components/buildings/base_card.vue'
import MilitaryCardButton from '@/components/buildings/military_card_button.vue'

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
  </BaseCard>
</template>
