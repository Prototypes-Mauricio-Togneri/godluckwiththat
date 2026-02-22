<script setup>
import {ref} from 'vue'
import HomeScreen from '@/components/screens/home_screen.vue'
import GameScreen from '@/components/screens/game_screen.vue'
import {MUS_MUSIC} from '@/js/engine/assets.js'
import audio from '@/js/engine/audio.js'

const currentScreen = ref('home')

function startGame() {
  audio.preload()
  currentScreen.value = 'game'
  audio.playMusic(MUS_MUSIC)
}

</script>

<template>
  <HomeScreen v-if="currentScreen === 'home'" @start="startGame" />
  <GameScreen v-else-if="currentScreen === 'game'" @quit="currentScreen = 'home'" />
</template>

<style scoped>
</style>
