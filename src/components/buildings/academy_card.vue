<script setup>
import {inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_RESOURCE_KNOWLEDGE} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
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
    <button class="btn-gold card-modal-btn tooltip" :data-tooltip="t('research.title')" @click="playTap(); openResearchModal()">
      <img class="card-modal-btn-icon" :src="IMG_RESOURCE_KNOWLEDGE" :alt="t('research.title')">
    </button>
  </BaseCard>
</template>

