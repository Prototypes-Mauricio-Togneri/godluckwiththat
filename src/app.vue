<script setup>
import {ref} from 'vue'
import HomeScreen from '@/components/screens/home_screen.vue'
import GameScreen from '@/components/screens/game_screen.vue'
import {MUS_MUSIC_1, MUS_MUSIC_2, MUS_MUSIC_3, MUS_MUSIC_4} from '@/js/engine/assets.js'
import audio from '@/js/engine/audio.js'
import {createInitialColony, createInitialMeta} from '@/js/engine/constants.js'
import State from '@/js/engine/state.js'

const currentScreen = ref('home')
const gameState = ref(null)

/** Preloads audio, creates or restores State, switches to game screen, and starts background music. */
function startGame(savedData) {
  audio.preload()
  let state = savedData ? State.fromJSON(savedData) : null
  if (!state) {
    state = new State(createInitialMeta(), createInitialColony())
    state.update(0)
  }
  gameState.value = state
  currentScreen.value = 'game'
  audio.playMusicPlaylist([
    MUS_MUSIC_1,
    MUS_MUSIC_2,
    MUS_MUSIC_3,
    MUS_MUSIC_4,
  ])
}

/** Stops music and returns to the home screen. */
function quitGame() {
  audio.stopMusic()
  gameState.value = null
  currentScreen.value = 'home'
}

</script>

<template>
  <HomeScreen v-if="currentScreen === 'home'" @start="startGame" />
  <GameScreen v-else-if="currentScreen === 'game'" :initial-state="gameState" @quit="quitGame" />
</template>

