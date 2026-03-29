<script setup>
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits([EMIT_CLOSE])
</script>

<template>
  <div class="screen-layout">
    <div class="screen-glow" />

    <div class="screen-content">
      <h1 class="screen-title">
        {{ t('screen.settings.title') }}
      </h1>

      <button class="btn-gold screen-btn-small" @click="playTap(); emit(EMIT_CLOSE)">
        {{ t('screen.settings.back') }}
      </button>
    </div>
  </div>
</template>
