import {defineConfig, mergeConfig} from 'vitest/config'
import viteConfig from './vite.config.js'

export default mergeConfig(viteConfig, defineConfig({
  test: {
    include: ['tests/**/*.test.js'],
    setupFiles: ['tests/helpers/setup.js'],
    coverage: {
      provider: 'v8',
      include: ['src/js/**/*.js'],
      exclude: [
        'src/js/engine/assets.js',
        'src/js/engine/audio.js',
        'src/js/engine/main.js',
        'src/js/engine/storage.js',
        'src/js/i18n/ca.js',
        'src/js/i18n/en.js',
        'src/js/i18n/es.js',
        'src/js/i18n/fr.js',
        'src/js/i18n/it.js',
      ],
      reporter: [
        'text',
        'html',
      ],
      reportsDirectory: 'coverage',
    },
  },
}))
