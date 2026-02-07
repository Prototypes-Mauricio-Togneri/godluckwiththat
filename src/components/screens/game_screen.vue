<script setup>
import { ref } from 'vue'
import GameModal from '../modals/game_modal.vue'
import {
  INITIAL_SEASON,
  INITIAL_FOOD,
  MAX_FOOD,
  INITIAL_WOOD,
  MAX_WOOD,
  INITIAL_STONE,
  MAX_STONE,
  INITIAL_POPULATION,
  MAX_POPULATION,
  INITIAL_IDLE_WORKERS,
  INITIAL_TERRITORY,
  MAX_TERRITORY,
  TOOLTIP_FOOD,
  TOOLTIP_WOOD,
  TOOLTIP_STONE,
  TOOLTIP_POPULATION,
  TOOLTIP_IDLE_WORKERS,
  TOOLTIP_TERRITORY,
} from '../../constants.js'

const showModal = ref(false)

// Season
const season = ref(INITIAL_SEASON)

// Resources
const food = ref(INITIAL_FOOD)
const foodMax = ref(MAX_FOOD)
const wood = ref(INITIAL_WOOD)
const woodMax = ref(MAX_WOOD)
const stone = ref(INITIAL_STONE)
const stoneMax = ref(MAX_STONE)

// Colony
const population = ref(INITIAL_POPULATION)
const populationMax = ref(MAX_POPULATION)
const idleWorkers = ref(INITIAL_IDLE_WORKERS)
const territory = ref(INITIAL_TERRITORY)
const territoryMax = ref(MAX_TERRITORY)
</script>

<template>
  <div class="game-screen">
    <header class="game-header">
      <!-- Season indicator -->
      <div class="header-section header-season">
        <span class="header-label">Season</span>
        <span class="header-value header-value--season">{{ season }}</span>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Resources -->
      <div class="header-section header-resources">
        <div class="header-resource tooltip" :data-tooltip="TOOLTIP_FOOD">
          <img class="resource-icon" src="/img/resources/food.png" alt="Food">
          <span class="header-value">{{ food }}/{{ foodMax }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="TOOLTIP_WOOD">
          <img class="resource-icon" src="/img/resources/wood.png" alt="Wood">
          <span class="header-value">{{ wood }}/{{ woodMax }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="TOOLTIP_STONE">
          <img class="resource-icon" src="/img/resources/stone.png" alt="Stone">
          <span class="header-value">{{ stone }}/{{ stoneMax }}</span>
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Colony info -->
      <div class="header-section header-colony">
        <div class="header-resource tooltip" :data-tooltip="TOOLTIP_POPULATION">
          <img class="resource-icon resource-icon--worker" src="/img/units/worker.png" alt="Population">
          <span class="header-value">{{ population }}/{{ populationMax }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="TOOLTIP_IDLE_WORKERS">
          <img class="resource-icon" src="/img/other/idle.png" alt="Idle workers">
          <span class="header-value">{{ idleWorkers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="TOOLTIP_TERRITORY">
          <img class="resource-icon resource-icon--territory" src="/img/other/territory.png" alt="Territory">
          <span class="header-value">{{ territory }}/{{ territoryMax }}</span>
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
    </main>

    <GameModal
      v-if="showModal"
      @close="showModal = false"
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

/* ---- Individual stat (label above value) ---- */

.header-stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.15rem;
}

/* ---- Resource stat (icon beside value) ---- */

.header-resource {
  display: flex;
  align-items: center;
  gap: 0.35rem;
}

.resource-icon {
  width: 1.3rem;
  height: 1.3rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}

.resource-icon--worker {
  width: 1.5rem;
  height: 1.5rem;
}

.resource-icon--territory {
  width: 1.7rem;
  height: 1.7rem;
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
  text-transform: capitalize;
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
  align-items: center;
  justify-content: center;
}
</style>
