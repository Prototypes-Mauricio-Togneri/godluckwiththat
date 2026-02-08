<script setup>
import {computed} from 'vue'
import BaseCard from './base_card.vue'

const props = defineProps({
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

const nameKey = computed(() => `building.headquarters.${props.building.type}`)
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building" :name-key="nameKey" />
</template>
