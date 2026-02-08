<script setup>
import {ref, reactive, onMounted, onUnmounted} from 'vue'
import PauseModal from '../modals/pause_modal.vue'
import GameState from '../../js/game_state.js'
import {createInitialColony, BUILDING_GRID} from '../../js/constants.js'
import {t} from '../../js/i18n/localized.js'

const emit = defineEmits(['quit'])
const showModal = ref(false)
const state = reactive(new GameState(createInitialColony()))

function handleKeydown(event) {
  if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') return
  if (event.key === 'Escape') {
    showModal.value = !showModal.value
  }
}

function buildingNameKey(key) {
  if (key === 'headquarters') return `building.headquarters.${state.colony.buildings.headquarters.type}`
  return `building.${key}`
}

onMounted(() => window.addEventListener('keydown', handleKeydown))
onUnmounted(() => window.removeEventListener('keydown', handleKeydown))
</script>

<template>
  <div class="game-screen">
    <header class="game-header">
      <!-- Season indicator -->
      <div class="header-section header-season">
        <span class="header-label">{{ t('season.name') }}</span>
        <span class="header-value header-value--season">{{ t('season.' + state.colony.season) }}</span>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Resources -->
      <div class="header-section header-resources">
        <div class="header-resource tooltip" :data-tooltip="t('resource.food')">
          <img class="resource-icon" src="/img/resources/food.png" :alt="t('resource.food')">
          <span class="header-value">{{ state.colony.resources.food }}/{{ state.colony.stockpile.food }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.wood')">
          <img class="resource-icon" src="/img/resources/wood.png" :alt="t('resource.wood')">
          <span class="header-value">{{ state.colony.resources.wood }}/{{ state.colony.stockpile.wood }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.stone')">
          <img class="resource-icon" src="/img/resources/stone.png" :alt="t('resource.stone')">
          <span class="header-value">{{ state.colony.resources.stone }}/{{ state.colony.stockpile.stone }}</span>
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Colony info -->
      <div class="header-section header-colony">
        <div class="header-resource tooltip" :data-tooltip="t('resource.population')">
          <img class="resource-icon resource-icon--worker" src="/img/units/worker.png" :alt="t('resource.population')">
          <span class="header-value">{{ state.colony.resources.workers }}/{{ state.colony.stockpile.workers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.idleWorkers')">
          <img class="resource-icon" src="/img/other/idle.png" :alt="t('resource.idleWorkers')">
          <span class="header-value">{{ state.colony.idleWorkers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.territory')">
          <img class="resource-icon resource-icon--territory" src="/img/other/territory.png" :alt="t('resource.territory')">
          <span class="header-value">{{ state.colony.resources.territory }}/{{ state.colony.stockpile.territory }}</span>
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Menu button -->
      <button class="btn-gold header-menu-button" @click="showModal = true">
        <svg class="menu-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <line x1="4" y1="6" x2="20" y2="6" />
          <line x1="4" y1="12" x2="20" y2="12" />
          <line x1="4" y1="18" x2="20" y2="18" />
        </svg>
      </button>
    </header>

    <main class="game-content">
      <div v-for="column in BUILDING_GRID" :key="column.headerKey" class="building-column">
        <h2 class="column-header">{{ t(column.headerKey) }}</h2>
        <div class="column-cards">
          <div v-for="building in column.buildings" :key="building.key" class="building-card">
            <img class="building-thumb" :src="building.img" :alt="t(buildingNameKey(building.key))">
            <div class="building-info">
              <span class="building-name">{{ t(buildingNameKey(building.key)) }}</span>
              <span class="building-level">{{ t('building.level') }} {{ state.colony.buildings[building.key].level }}</span>
            </div>
          </div>
        </div>
      </div>
    </main>

    <PauseModal
      v-if="showModal"
      @close="showModal = false"
      @quit="emit('quit')"
    />
  </div>
</template>

<style scoped>
.game-screen {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--color-bg);
  color: var(--color-text);
}

/* ---- Header bar ---- */

.game-header {
  display: flex;
  align-items: center;
  padding: 0.45rem 1.5rem;
  gap: 1.25rem;
  border-bottom: 1px solid var(--color-border);
  background: var(--color-bg-surface);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

/* ---- Sections ---- */

.header-section {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.header-resources,
.header-colony {
  flex: 1;
  justify-content: center;
  gap: 2.5rem;
}

/* ---- Resource stat (icon beside value) ---- */

.header-resource {
  display: flex;
  align-items: center;
  gap: 0.35rem;
}

.resource-icon {
  width: 1.5rem;
  height: 1.5rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}

.resource-icon--worker {
  width: 1.7rem;
  height: 1.7rem;
}

.resource-icon--territory {
  width: 1.9rem;
  height: 1.9rem;
}

/* ---- Labels ---- */

.header-label {
  font-family: var(--font-display);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: rgba(var(--color-accent-rgb), 0.45);
}

/* ---- Values ---- */

.header-value {
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 400;
  letter-spacing: 0.04em;
  color: var(--color-text);
}

.header-value--season {
  font-weight: 500;
  color: rgba(var(--color-accent-rgb), 0.85);
}

/* ---- Decorative dividers between sections ---- */

.header-divider {
  width: 1px;
  height: 1.6rem;
  background: linear-gradient(
    180deg,
    transparent,
    rgba(var(--color-accent-rgb), 0.2),
    transparent
  );
  flex-shrink: 0;
}

/* ---- Menu button ---- */

.header-menu-button {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.4rem;
  line-height: 1;
  flex-shrink: 0;
}

.menu-icon {
  width: 1.1rem;
  height: 1.1rem;
}

/* ---- Main content area ---- */

.game-content {
  flex: 1;
  display: flex;
  align-items: flex-start;
  padding: 1.25rem 1.5rem 1.5rem;
  gap: 1.5rem;
  overflow-y: auto;
}

/* ---- Building columns ---- */

.building-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

/* Column header — matches .header-label pattern */
.column-header {
  font-family: var(--font-display);
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  line-height: 1;
  text-transform: uppercase;
  color: rgba(var(--color-accent-rgb), 0.75);
  text-align: center;
  padding-bottom: 0.85rem;
  margin-bottom: 0.25rem;
  border-bottom: 1px solid var(--color-border);
}

/* Card stack */
.column-cards {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

/* Individual building card */
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

/* Building thumbnail */
.building-thumb {
  width: 5.5rem;
  height: 5.5rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
  flex-shrink: 0;
}

/* Name and level wrapper */
.building-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  min-width: 0;
}

/* Building name */
.building-name {
  font-family: var(--font-body);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--color-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Level display */
.building-level {
  font-family: var(--font-body);
  font-size: 0.7rem;
  font-weight: 300;
  color: rgba(var(--color-accent-rgb), 0.65);
  letter-spacing: 0.04em;
}
</style>
