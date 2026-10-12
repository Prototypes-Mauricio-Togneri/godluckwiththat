/**
 * Vue application entry point.
 * Creates and mounts the root App component.
 */
import {createApp} from 'vue'
import App from '@/app.vue'
import analytics from '@/js/engine/analytics.js'
import '@/assets/styles.css'

analytics.init()
createApp(App).mount('#app')
