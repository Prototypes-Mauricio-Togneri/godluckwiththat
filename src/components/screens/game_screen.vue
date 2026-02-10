<script setup>
import {ref, reactive, provide, onMounted, onUnmounted} from 'vue'
import PauseModal from '@/components/modals/pause_modal.vue'
import HeadquartersCard from '@/components/buildings/headquarters_card.vue'
import HouseCard from '@/components/buildings/house_card.vue'
import AcademyCard from '@/components/buildings/academy_card.vue'
import StorehouseCard from '@/components/buildings/storehouse_card.vue'
import MarketCard from '@/components/buildings/market_card.vue'
import FarmCard from '@/components/buildings/farm_card.vue'
import WoodcutterCard from '@/components/buildings/woodcutter_card.vue'
import QuarryCard from '@/components/buildings/quarry_card.vue'
import CopperMineCard from '@/components/buildings/copper_mine_card.vue'
import IronMineCard from '@/components/buildings/iron_mine_card.vue'
import GoldMineCard from '@/components/buildings/gold_mine_card.vue'
import AltarCard from '@/components/buildings/altar_card.vue'
import ShrineCard from '@/components/buildings/shrine_card.vue'
import TempleCard from '@/components/buildings/temple_card.vue'
import MonumentCard from '@/components/buildings/monument_card.vue'
import BarracksCard from '@/components/buildings/barracks_card.vue'
import ArcheryCard from '@/components/buildings/archery_card.vue'
import StableCard from '@/components/buildings/stable_card.vue'
import WorkshopCard from '@/components/buildings/workshop_card.vue'
import WallCard from '@/components/buildings/wall_card.vue'
import TowerCard from '@/components/buildings/tower_card.vue'
import GameState from '@/js/game_state.js'
import {TICK_INTERVAL_MS} from '@/js/balancing.js'
import {createInitialColony, createInitialMeta, BUILDING_GRID, HQ_BUILDING_UNLOCKS, HQ_TYPES} from '@/js/constants.js'
import {t} from '@/js/i18n/localized.js'

const CARD_COMPONENTS = {
  headquarters: HeadquartersCard,
  house: HouseCard,
  academy: AcademyCard,
  storehouse: StorehouseCard,
  market: MarketCard,
  farm: FarmCard,
  woodcutter: WoodcutterCard,
  quarry: QuarryCard,
  copperMine: CopperMineCard,
  ironMine: IronMineCard,
  goldMine: GoldMineCard,
  altar: AltarCard,
  shrine: ShrineCard,
  temple: TempleCard,
  monument: MonumentCard,
  barracks: BarracksCard,
  archery: ArcheryCard,
  stable: StableCard,
  workshop: WorkshopCard,
  wall: WallCard,
  tower: TowerCard,
}

function getCardComponent(key) {
  return CARD_COMPONENTS[key]
}

function isBuildingLocked(buildingKey) {
  if (buildingKey === 'headquarters') return false
  const currentTypeIndex = HQ_TYPES.indexOf(state.colony.buildings.headquarters.type)
  for (let i = 0; i <= currentTypeIndex; i++) {
    if (HQ_BUILDING_UNLOCKS[HQ_TYPES[i]].includes(buildingKey)) return false
  }
  return true
}

const emit = defineEmits(['quit'])
const showModal = ref(false)
const state = reactive(new GameState(createInitialMeta(), createInitialColony()))
provide('colony', state.colony)

let tickTimer = null
let lastTickTime = 0

function gameTick() {
  const now = performance.now()
  const delta = (now - lastTickTime) / 1000
  lastTickTime = now
  state.update(delta)
}

function handleKeydown(event) {
  if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') return
  if (event.key === 'Escape') {
    showModal.value = !showModal.value
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
  lastTickTime = performance.now()
  tickTimer = setInterval(gameTick, TICK_INTERVAL_MS)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
  clearInterval(tickTimer)
})
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
          <span class="header-value">{{ Math.floor(state.colony.resources.food) }}/{{ state.colony.stockpile.food }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.wood')">
          <img class="resource-icon" src="/img/resources/wood.png" :alt="t('resource.wood')">
          <span class="header-value">{{ Math.floor(state.colony.resources.wood) }}/{{ state.colony.stockpile.wood }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.stone')">
          <img class="resource-icon" src="/img/resources/stone.png" :alt="t('resource.stone')">
          <span class="header-value">{{ Math.floor(state.colony.resources.stone) }}/{{ state.colony.stockpile.stone }}</span>
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Colony info -->
      <div class="header-section header-colony">
        <div class="header-resource tooltip" :data-tooltip="t('resource.population')">
          <img class="resource-icon resource-icon--worker" src="/img/units/worker.png" :alt="t('resource.population')">
          <span class="header-value">{{ Math.floor(state.colony.resources.workers) }}/{{ state.colony.stockpile.workers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.idleWorkers')">
          <img class="resource-icon" src="/img/other/idle.png" :alt="t('resource.idleWorkers')">
          <span class="header-value">{{ state.colony.idleWorkers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.territory')">
          <img class="resource-icon resource-icon--territory" src="/img/other/territory.png" :alt="t('resource.territory')">
          <span class="header-value">{{ Math.floor(state.colony.resources.territory) }}/{{ state.colony.stockpile.territory }}</span>
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
          <template v-for="building in column.buildings" :key="building.key">
            <component
              :is="getCardComponent(building.key)"
              v-if="!isBuildingLocked(building.key)"
              :building-key="building.key"
              :img="building.img"
              :building="state.colony.buildings[building.key]"
            />
            <div
              v-else
              class="building-card-locked tooltip"
              :data-tooltip="t('building.locked')"
            >
              <img class="locked-icon" src="/img/other/lock.png" :alt="t('building.locked')">
            </div>
          </template>
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
  font-family: var(--font-numeric);
  font-size: 0.95rem;
  font-weight: 400;
  letter-spacing: 0.04em;
  color: var(--color-text);
}

.header-value--season {
  font-family: var(--font-body);
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

/* Locked building placeholder — mirrors .building-card shell */
.building-card-locked {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.6rem 0.75rem;
  min-height: 6.7rem;
  background: rgba(39, 33, 25, 0.3);
  border: 1px solid var(--color-border);
  border-radius: 4px;
  opacity: 0.4;
}

.locked-icon {
  width: 3rem;
  height: 3rem;
  object-fit: contain;
  filter: grayscale(1) drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
  opacity: 0.35;
}

</style>
