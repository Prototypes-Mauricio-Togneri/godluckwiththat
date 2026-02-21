/**
 * Vue application entry point.
 * Creates and mounts the root App component.
 */
import {createApp} from 'vue'
import App from '@/app.vue'
import '@/assets/styles.css'
import audio from '@/js/engine/audio.js'

audio.preload()
createApp(App).mount('#app')
