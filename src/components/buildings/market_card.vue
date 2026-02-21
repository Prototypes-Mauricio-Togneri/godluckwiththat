<script setup>
import {inject} from 'vue'
import BaseCard from '@/components/buildings/base_card.vue'
import {IMG_OTHER_COIN} from '@/js/engine/assets.js'
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

const openMarketModal = inject('openMarketModal')
</script>

<template>
  <BaseCard :building-key="buildingKey" :img="img" :building="building">
    <button class="btn-gold card-modal-btn tooltip" :data-tooltip="t('market.title')" @click="playTap(); openMarketModal()">
      <img class="card-modal-btn-icon" :src="IMG_OTHER_COIN" :alt="t('market.title')">
    </button>
  </BaseCard>
</template>
