<script setup>
import {inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_RESOURCE_KNOWLEDGE} from '@/js/engine/assets.js'
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

const openResearchModal = inject('openResearchModal')
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <button class="btn-gold research-btn tooltip" :data-tooltip="t('research.title')" @click="openResearchModal">
      <img class="research-btn-icon" :src="IMG_RESOURCE_KNOWLEDGE" :alt="t('research.title')">
    </button>
  </BaseCard>
</template>

<style scoped>
.research-btn {
  margin-left: auto;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.4rem;
  line-height: 1;
}

.research-btn-icon {
  width: 1.1rem;
  height: 1.1rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}
</style>
