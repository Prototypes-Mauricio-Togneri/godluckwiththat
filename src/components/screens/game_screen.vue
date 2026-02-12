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
import {createInitialColony, createInitialMeta, BUILDING_GRID, HQ_BUILDING_UNLOCKS, HQ_RESOURCE_UNLOCKS, HQ_TYPES, SEASON_WARM, SECONDS_PER_MINUTE, TICK_INTERVAL} from '@/js/constants.js'
import {SEASON_DURATION} from '@/js/balancing.js'
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

function formatRate(ratePerSecond) {
  const perMinute = Math.round(ratePerSecond * SECONDS_PER_MINUTE)
  if (perMinute > 0) return `+${perMinute}${t('resource.perMinute')}`
  if (perMinute < 0) return `-${Math.abs(perMinute)}${t('resource.perMinute')}`
  return `0${t('resource.perMinute')}`
}

function rateClass(ratePerSecond) {
  const perMinute = Math.round(ratePerSecond * SECONDS_PER_MINUTE)
  if (perMinute > 0) return 'production-rate--positive'
  if (perMinute < 0) return 'production-rate--negative'
  return 'production-rate--zero'
}

function seasonProgress() {
  return state.colony.seasonElapsed / SEASON_DURATION
}

function seasonEmoji() {
  return state.colony.season === SEASON_WARM ? '\u2600\uFE0F' : '\u2744\uFE0F'
}

function seasonTooltip() {
  return `${t('season.name')}: ${t('season.' + state.colony.season)}`
}

function isBuildingLocked(buildingKey) {
  if (buildingKey === 'headquarters') return false
  const currentTypeIndex = HQ_TYPES.indexOf(state.colony.buildings.headquarters.type)
  for (let i = 0; i <= currentTypeIndex; i++) {
    if (HQ_BUILDING_UNLOCKS[HQ_TYPES[i]].includes(buildingKey)) return false
  }
  return true
}

function isResourceVisible(resource) {
  const currentTypeIndex = HQ_TYPES.indexOf(state.colony.buildings.headquarters.type)
  for (let i = 0; i <= currentTypeIndex; i++) {
    if (HQ_RESOURCE_UNLOCKS[HQ_TYPES[i]].includes(resource)) return true
  }
  return false
}

const emit = defineEmits(['quit'])
const showModal = ref(false)
const state = reactive(new GameState(createInitialMeta(), createInitialColony()))
state.update(0)
provide('colony', state.colony)
provide('gameState', state)

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
  tickTimer = setInterval(gameTick, TICK_INTERVAL)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
  clearInterval(tickTimer)
})
</script>

<template>
  <div class="game-screen">
    <header class="game-header">
      <!-- Year indicator -->
      <span class="header-year">{{ t('year.label') }} <span class="header-year-num">{{ state.colony.year }}</span></span>

      <!-- Season indicator -->
      <div class="header-section header-season tooltip" :data-tooltip="seasonTooltip()">
        <span class="season-emoji">{{ seasonEmoji() }}</span>
        <div class="season-track" :class="'season-track--' + state.colony.season">
          <div class="season-fill" :style="{ width: (seasonProgress() * 100) + '%' }" />
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Resources -->
      <div class="header-section header-resources">
        <div v-if="isResourceVisible('food')" class="header-resource tooltip" :data-tooltip="t('resource.food')">
          <img class="resource-icon" src="/img/resources/food.png" :alt="t('resource.food')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.food) >= state.colony.stockpile.food }">{{ Math.floor(state.colony.resources.food) }}/{{ state.colony.stockpile.food }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.food)">{{ formatRate(state.colony.production.food) }}</span>
        </div>
        <div v-if="isResourceVisible('wood')" class="header-resource tooltip" :data-tooltip="t('resource.wood')">
          <img class="resource-icon" src="/img/resources/wood.png" :alt="t('resource.wood')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.wood) >= state.colony.stockpile.wood }">{{ Math.floor(state.colony.resources.wood) }}/{{ state.colony.stockpile.wood }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.wood)">{{ formatRate(state.colony.production.wood) }}</span>
        </div>
        <div v-if="isResourceVisible('stone')" class="header-resource tooltip" :data-tooltip="t('resource.stone')">
          <img class="resource-icon" src="/img/resources/stone.png" :alt="t('resource.stone')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.stone) >= state.colony.stockpile.stone }">{{ Math.floor(state.colony.resources.stone) }}/{{ state.colony.stockpile.stone }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.stone)">{{ formatRate(state.colony.production.stone) }}</span>
        </div>
        <div v-if="isResourceVisible('copper')" class="header-resource tooltip" :data-tooltip="t('resource.copper')">
          <img class="resource-icon" src="/img/resources/copper.png" :alt="t('resource.copper')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.copper) >= state.colony.stockpile.copper }">{{ Math.floor(state.colony.resources.copper) }}/{{ state.colony.stockpile.copper }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.copper)">{{ formatRate(state.colony.production.copper) }}</span>
        </div>
        <div v-if="isResourceVisible('iron')" class="header-resource tooltip" :data-tooltip="t('resource.iron')">
          <img class="resource-icon" src="/img/resources/iron.png" :alt="t('resource.iron')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.iron) >= state.colony.stockpile.iron }">{{ Math.floor(state.colony.resources.iron) }}/{{ state.colony.stockpile.iron }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.iron)">{{ formatRate(state.colony.production.iron) }}</span>
        </div>
        <div v-if="isResourceVisible('gold')" class="header-resource tooltip" :data-tooltip="t('resource.gold')">
          <img class="resource-icon" src="/img/resources/gold.png" :alt="t('resource.gold')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.gold) >= state.colony.stockpile.gold }">{{ Math.floor(state.colony.resources.gold) }}/{{ state.colony.stockpile.gold }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.gold)">{{ formatRate(state.colony.production.gold) }}</span>
        </div>
        <div v-if="isResourceVisible('knowledge')" class="header-resource tooltip" :data-tooltip="t('resource.knowledge')">
          <img class="resource-icon" src="/img/resources/knowledge.png" :alt="t('resource.knowledge')">
          <span class="header-value">{{ Math.floor(state.colony.resources.knowledge) }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.knowledge)">{{ formatRate(state.colony.production.knowledge) }}</span>
        </div>
        <div v-if="isResourceVisible('faith')" class="header-resource tooltip" :data-tooltip="t('resource.faith')">
          <img class="resource-icon" src="/img/resources/faith.png" :alt="t('resource.faith')">
          <span class="header-value">{{ Math.floor(state.colony.resources.faith) }}</span>
          <span class="production-rate" :class="rateClass(state.colony.production.faith)">{{ formatRate(state.colony.production.faith) }}</span>
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Colony info -->
      <div class="header-section header-colony">
        <div class="header-resource tooltip" :data-tooltip="t('resource.population')">
          <img class="resource-icon resource-icon--worker" src="/img/units/worker.png" :alt="t('resource.population')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.workers) >= state.colony.stockpile.workers }">{{ Math.floor(state.colony.resources.workers) }}/{{ state.colony.stockpile.workers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.idleWorkers')">
          <img class="resource-icon" src="/img/other/idle.png" :alt="t('resource.idleWorkers')">
          <span class="header-value" :class="{ 'header-value--alert': state.colony.idleWorkers > 0 }">{{ state.colony.idleWorkers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.territory')">
          <img class="resource-icon resource-icon--territory" src="/img/other/territory.png" :alt="t('resource.territory')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.territory) >= state.colony.stockpile.territory }">{{ Math.floor(state.colony.resources.territory) }}/{{ state.colony.stockpile.territory }}</span>
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

.header-season {
  gap: 0.5rem;
  flex-shrink: 0;
}

.header-year {
  font-family: var(--font-display);
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: rgba(var(--color-text-rgb), 0.55);
  margin-right: 1em;
}

.header-year-num {
  font-family: var(--font-numeric);
  color: var(--color-text);
  margin-left: 0.5em;
}

.header-resources {
  flex: 1;
  justify-content: center;
  gap: 2.25rem;
}

.header-colony {
  justify-content: space-evenly;
  gap: 1.5rem;
  flex-shrink: 0;
  min-width: 18rem;
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

/* ---- Season indicator ---- */

.season-emoji {
  font-size: 1.1rem;
  line-height: 1;
  filter: drop-shadow(0 0 3px rgba(0, 0, 0, 0.4));
}

.season-track {
  width: 5.5rem;
  height: 4px;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 2px;
  overflow: hidden;
}

.season-fill {
  height: 100%;
  border-radius: 2px;
  transition: width 0.3s linear;
}

.season-track--warm .season-fill {
  background: linear-gradient(90deg, #b8943e, #d4a843);
  box-shadow: 0 0 6px rgba(184, 148, 62, 0.4);
}

.season-track--cold .season-fill {
  background: linear-gradient(90deg, #5b8fb9, #7ec8e3);
  box-shadow: 0 0 6px rgba(126, 200, 227, 0.35);
}

/* ---- Values ---- */

.header-value {
  font-family: var(--font-numeric);
  font-size: 0.95rem;
  font-weight: 400;
  letter-spacing: 0.04em;
  color: var(--color-text);
}

.header-value--alert {
  color: #c0392b;
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
