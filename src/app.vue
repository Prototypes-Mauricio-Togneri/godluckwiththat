<script setup>
import { ref } from 'vue'
import HomeScreen from './components/home_screen.vue'
import GameScreen from './components/game_screen.vue'

const currentScreen = ref('home')

function startGame() {
  currentScreen.value = 'game'
}

function goHome() {
  currentScreen.value = 'home'
}
</script>

<template>
  <HomeScreen v-if="currentScreen === 'home'" @start="startGame" />
  <GameScreen v-else-if="currentScreen === 'game'" @quit="goHome" />
</template>

<style scoped>
</style>
