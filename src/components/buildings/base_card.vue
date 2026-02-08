<script setup>
import {computed, ref} from 'vue'
import BuildingHelpModal from '@/components/modals/building_help_modal.vue'
import {BUILDING_IMG_PATH} from '@/js/constants.js'
import {t} from '@/js/i18n/localized.js'

const props = defineProps({
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
  nameKey: {
    type: String,
    default: '',
  },
})

const displayNameKey = computed(() => props.nameKey || `building.${props.buildingKey}`)
const showHelp = ref(false)
</script>

<template>
  <div class="building-card">
    <button
      class="help-btn tooltip"
      :data-tooltip="t('modal.buildingHelp.tooltip')"
      @click="showHelp = true"
    >
      ?
    </button>

    <div class="building-thumb-wrapper">
      <img class="building-thumb" :src="BUILDING_IMG_PATH + img" :alt="t(displayNameKey)">
      <span class="building-level-badge">{{ building.level }}</span>
    </div>
    <div class="building-info">
      <span class="building-name">{{ t(displayNameKey) }}</span>
      <slot />
    </div>

    <BuildingHelpModal
      v-if="showHelp"
      :name-key="displayNameKey"
      :building-key="buildingKey"
      @close="showHelp = false"
    />
  </div>
</template>

<style scoped>
.building-card {
  position: relative;
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 0.6rem 0.75rem;
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border);
  border-radius: 4px;
  transition: border-color 0.2s ease;
}

.building-card:hover {
  border-color: rgba(var(--color-accent-rgb), 0.35);
}

/* Help icon — top-right corner */
.help-btn {
  position: absolute;
  top: 0.45rem;
  right: 0.45rem;
  width: 1.25rem;
  height: 1.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--font-body);
  font-size: 0.65rem;
  font-weight: 500;
  line-height: 1;
  color: rgba(var(--color-accent-rgb), 0.65);
  background: none;
  border: 1px solid rgba(var(--color-accent-rgb), 0.3);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s ease;
  padding: 0;
  z-index: 1;
}

.help-btn:hover {
  color: var(--color-accent);
  border-color: rgba(var(--color-accent-rgb), 0.5);
  background: rgba(var(--color-accent-rgb), 0.08);
}

.building-thumb-wrapper {
  position: relative;
  flex-shrink: 0;
}

.building-thumb {
  display: block;
  width: 5.5rem;
  height: 5.5rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}

/* Level number overlay at bottom-right of thumbnail */
.building-level-badge {
  position: absolute;
  bottom: 0;
  right: 0;
  font-family: var(--font-body);
  font-size: 0.9rem;
  font-weight: 500;
  line-height: 1;
  color: var(--color-text);
  background: rgba(0, 0, 0, 0.6);
  padding: 0.3rem 0.4rem;
}

.building-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  min-width: 0;
}

.building-name {
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 400;
  color: var(--color-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
