<script setup>
import {computed} from 'vue'
import {t} from '../../js/i18n/localized.js'

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
</script>

<template>
  <div class="building-card">
    <img class="building-thumb" :src="img" :alt="t(displayNameKey)">
    <div class="building-info">
      <span class="building-name">{{ t(displayNameKey) }}</span>
      <span class="building-level">{{ t('building.level') }} {{ building.level }}</span>
      <slot />
    </div>
  </div>
</template>

<style scoped>
.building-card {
  display: flex;
  align-items: center;
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

.building-thumb {
  width: 5.5rem;
  height: 5.5rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
  flex-shrink: 0;
}

.building-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  min-width: 0;
}

.building-name {
  font-family: var(--font-body);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--color-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.building-level {
  font-family: var(--font-body);
  font-size: 0.7rem;
  font-weight: 300;
  color: rgba(var(--color-accent-rgb), 0.65);
  letter-spacing: 0.04em;
}
</style>
