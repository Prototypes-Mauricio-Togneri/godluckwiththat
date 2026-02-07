/**
 * Vue application entry point.
 * Creates and mounts the root App component.
 */
import {
  createApp,
} from 'vue'
import App from '../app.vue'
import '../assets/styles.css'

createApp(App).mount('#app')
