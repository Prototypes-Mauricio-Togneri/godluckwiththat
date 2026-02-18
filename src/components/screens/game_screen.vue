<script setup>
import {ref, reactive, computed, provide, onMounted, onUnmounted} from 'vue'
import ConfirmModal from '@/components/modals/confirm_modal.vue'
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
import GameState from '@/js/engine/game_state.js'
import {IMG_OTHER_IDLE, IMG_OTHER_LOCK, IMG_OTHER_TERRITORY, IMG_RESOURCE_MAP, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER} from '@/js/engine/assets.js'
import {createInitialColony, createInitialEvents, createInitialMeta, BUILDING_GRID, HEADER_RESOURCES, HQ_BUILDING_UNLOCKS, HQ_RESOURCE_UNLOCKS, HQ_TYPES, SECONDS_PER_MINUTE, TICK_INTERVAL, UNBOUNDED_RESOURCES} from '@/js/engine/constants.js'
import {SEASON_DURATION} from '@/js/engine/balancing.js'
import {BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_SHRINE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TEMPLE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'

const CARD_COMPONENTS = {
  [BUILDING_HEADQUARTERS]: HeadquartersCard,
  [BUILDING_HOUSE]: HouseCard,
  [BUILDING_ACADEMY]: AcademyCard,
  [BUILDING_STOREHOUSE]: StorehouseCard,
  [BUILDING_MARKET]: MarketCard,
  [BUILDING_FARM]: FarmCard,
  [BUILDING_WOODCUTTER]: WoodcutterCard,
  [BUILDING_QUARRY]: QuarryCard,
  [BUILDING_COPPER_MINE]: CopperMineCard,
  [BUILDING_IRON_MINE]: IronMineCard,
  [BUILDING_GOLD_MINE]: GoldMineCard,
  [BUILDING_ALTAR]: AltarCard,
  [BUILDING_SHRINE]: ShrineCard,
  [BUILDING_TEMPLE]: TempleCard,
  [BUILDING_MONUMENT]: MonumentCard,
  [BUILDING_BARRACKS]: BarracksCard,
  [BUILDING_ARCHERY]: ArcheryCard,
  [BUILDING_STABLE]: StableCard,
  [BUILDING_WORKSHOP]: WorkshopCard,
  [BUILDING_WALL]: WallCard,
  [BUILDING_TOWER]: TowerCard,
}

function getCardComponent(key) {
  return CARD_COMPONENTS[key]
}

const NUMBER_SUFFIXES = [
  '',
  'K',
  'M',
  'B',
  'T',
]

function formatNumber(n) {
  const floored = Math.floor(n)
  if (floored < 1000) return String(floored)
  const tier = Math.min(Math.floor(Math.log10(floored) / 3), NUMBER_SUFFIXES.length - 1)
  const scaled = floored / Math.pow(1000, tier)
  const fixed = scaled.toFixed(1)
  const short = fixed.endsWith('.0') ? fixed.slice(0, -2) : fixed
  return short + NUMBER_SUFFIXES[tier]
}

function formatRate(ratePerSecond) {
  const value = Math.round(ratePerSecond * 10) / 10
  if (value > 0) return `${value.toFixed(1)}${t('resource.perSecond')}`
  if (value < 0) return `-${Math.abs(value).toFixed(1)}${t('resource.perSecond')}`
  return `0.0${t('resource.perSecond')}`
}

function rateClass(ratePerSecond) {
  const value = Math.round(ratePerSecond * 10) / 10
  if (value > 0) return 'production-rate--positive'
  if (value < 0) return 'production-rate--negative'
  return 'production-rate--zero'
}

function isBounded(resource) {
  return !UNBOUNDED_RESOURCES.includes(resource)
}

function resourceFillPercent(resource) {
  const current = state.colony.resources[resource]
  const capacity = state.colony.stockpile[resource]
  if (!capacity) return 0
  return Math.min(100, (current / capacity) * 100)
}

function formatTime(totalSeconds) {
  const seconds = Math.floor(totalSeconds)
  if (seconds < 0) return null
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const secs = seconds % 60
  const pad = n => String(n).padStart(2, '0')
  if (hours > 0) return `${pad(hours)}:${pad(minutes)}:${pad(secs)}`
  return `${pad(minutes)}:${pad(secs)}`
}

function timeEstimate(resource) {
  const rate = state.colony.production[resource]
  if (Math.round(rate * SECONDS_PER_MINUTE) === 0) return null
  const current = state.colony.resources[resource]

  if (isBounded(resource) && rate > 0) {
    const capacity = state.colony.stockpile[resource]
    if (current >= capacity) return null
    return `${t('resource.fullIn')} ${formatTime((capacity - current) / rate)}`
  }

  if (rate < 0 && current > 0) {
    return `${t('resource.emptyIn')} ${formatTime(current / Math.abs(rate))}`
  }

  return null
}

function seasonProgress() {
  return state.colony.seasonElapsed / SEASON_DURATION
}

function seasonIcon() {
  return state.colony.isWarmSeason ? IMG_SEASON_WARM : IMG_SEASON_COLD
}

function seasonTooltip() {
  return `${t('season.name')}: ${t('season.' + state.colony.season)}`
}

function isBuildingLocked(buildingKey) {
  if (buildingKey === BUILDING_HEADQUARTERS) return false
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
const state = reactive(new GameState(createInitialMeta(), createInitialColony(), createInitialEvents()))
state.update(0)
provide('colony', state.colony)
provide('gameState', state)

const futureEvents = computed(() => state.events.future())
const pastEvents = computed(() => state.events.past())

const showClearConfirm = ref(false)

function clearAllPast() {
  state.events.dismissAllPast()
  showClearConfirm.value = false
}

let tickTimer = null
let lastTickTime = 0
let progressAnimFrame = null
let lastProgressTickTime = 0

function gameTick() {
  const now = performance.now()
  const delta = (now - lastTickTime) / 1000
  lastTickTime = now
  state.update(delta)

  // Advance smooth progress from main tick too — covers backgrounded tabs where requestAnimationFrame pauses
  const progressDelta = (now - lastProgressTickTime) / 1000
  lastProgressTickTime = now
  state.advanceSeason(progressDelta)
  state.advanceConstruction(progressDelta)
  state.events.tick(progressDelta)
}

function progressTick() {
  const now = performance.now()
  const delta = (now - lastProgressTickTime) / 1000
  lastProgressTickTime = now
  state.advanceSeason(delta)
  state.advanceConstruction(delta)
  state.events.tick(delta)
  progressAnimFrame = requestAnimationFrame(progressTick)
}

function handleKeydown(event) {
  if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') return
  if (event.key === 'Escape') {
    showModal.value = !showModal.value
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
  const now = performance.now()
  lastTickTime = now
  lastProgressTickTime = now
  tickTimer = setInterval(gameTick, TICK_INTERVAL)
  progressAnimFrame = requestAnimationFrame(progressTick)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
  clearInterval(tickTimer)
  cancelAnimationFrame(progressAnimFrame)
})
</script>

<template>
  <div class="game-screen">
    <header class="game-header">
      <!-- Year indicator -->
      <span class="header-year">{{ t('year.label') }} <span class="header-year-num">{{ state.colony.year }}</span></span>

      <!-- Season indicator -->
      <div class="header-section header-season tooltip" :data-tooltip="seasonTooltip()">
        <img class="season-icon" :src="seasonIcon()" alt="">
        <div class="season-track" :class="'season-track--' + state.colony.season">
          <div class="season-fill" :style="{ width: (seasonProgress() * 100) + '%' }" />
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Resources -->
      <div class="header-section header-resources">
        <template v-for="resource in HEADER_RESOURCES" :key="resource">
          <div v-if="isResourceVisible(resource)" class="resource-box">
            <!-- Row 1: icon + current amount + rate -->
            <div class="resource-row-top">
              <img class="resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
              <span class="header-value" :class="{ 'header-value--alert': isBounded(resource) && Math.floor(state.colony.resources[resource]) >= state.colony.stockpile[resource], 'header-value--zero': Math.floor(state.colony.resources[resource]) === 0 }">
                {{ formatNumber(state.colony.resources[resource]) }}
              </span>
              <span class="production-rate" :class="rateClass(state.colony.production[resource])">{{ formatRate(state.colony.production[resource]) }}</span>
            </div>

            <!-- Row 2: full-width progress bar (bounded only) -->
            <div v-if="isBounded(resource)" class="resource-row-bottom">
              <div class="resource-bar">
                <div
                  class="resource-bar-fill"
                  :class="state.colony.production[resource] > 0 ? 'resource-bar-fill--positive' : 'resource-bar-fill--negative'"
                  :style="{ width: resourceFillPercent(resource) + '%' }"
                />
              </div>
            </div>

            <!-- Rich tooltip -->
            <div class="resource-tooltip">
              <span>{{ t('resource.' + resource) }}</span>
              <span v-if="isBounded(resource)" class="resource-tooltip-time">{{ t('resource.maxCapacity') }}: {{ formatNumber(state.colony.stockpile[resource]) }}</span>
              <span v-if="timeEstimate(resource)" class="resource-tooltip-time">{{ timeEstimate(resource) }}</span>
            </div>
          </div>
        </template>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Colony info -->
      <div class="header-section header-colony">
        <div class="header-resource tooltip" :data-tooltip="t('resource.population')">
          <img class="resource-icon resource-icon--worker" :src="IMG_UNIT_WORKER" :alt="t('resource.population')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.workers) >= state.colony.stockpile.workers, 'header-value--zero': state.colony.resources.workers === 0 }">{{ formatNumber(state.colony.resources.workers) }}/{{ formatNumber(state.colony.stockpile.workers) }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.idleWorkers')">
          <img class="resource-icon" :src="IMG_OTHER_IDLE" :alt="t('resource.idleWorkers')">
          <span class="header-value" :class="{ 'header-value--alert': state.colony.idleWorkers > 0 }">{{ state.colony.idleWorkers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.territory')">
          <img class="resource-icon resource-icon--territory" :src="IMG_OTHER_TERRITORY" :alt="t('resource.territory')">
          <span class="header-value" :class="{ 'header-value--alert': Math.floor(state.colony.resources.territory) >= state.colony.stockpile.territory }">{{ formatNumber(state.colony.resources.territory) }}/{{ formatNumber(state.colony.stockpile.territory) }}</span>
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
              class="building-card-locked tooltip tooltip--delayed"
              :data-tooltip="t('building.locked')"
            >
              <img class="locked-icon" :src="IMG_OTHER_LOCK" :alt="t('building.locked')">
            </div>
          </template>
        </div>
      </div>

      <!-- Events column -->
      <div class="events-column">
        <h2 class="column-header">{{ t('events.title') }}</h2>

        <!-- Future events -->
        <div v-if="futureEvents.length" class="events-section">
          <h3 class="events-section-label">{{ t('events.future') }}</h3>
          <div class="events-list">
            <div v-for="event in futureEvents" :key="event.id" class="event-row">
              <img class="event-icon" :src="event.icon" :alt="t(event.textKey, ...event.params)">
              <span class="event-text">{{ t(event.textKey, ...event.params) }}</span>
              <span class="event-countdown">{{ formatTime(event.remainingSeconds) }}</span>
            </div>
          </div>
        </div>

        <!-- Past events -->
        <div v-if="pastEvents.length" class="events-section">
          <div class="events-section-header">
            <h3 class="events-section-label">{{ t('events.past') }}</h3>
            <button class="events-clear-btn" @click="showClearConfirm = true">{{ t('events.clearAll') }}</button>
          </div>
          <div class="events-list">
            <div v-for="event in pastEvents" :key="event.id" class="event-row">
              <img class="event-icon" :src="event.icon" :alt="t(event.textKey, ...event.params)">
              <span class="event-text">{{ t(event.textKey, ...event.params) }}</span>
              <button class="event-dismiss" @click="state.events.dismiss(event.id)">&times;</button>
            </div>
          </div>
        </div>

        <!-- Empty state -->
        <p v-if="!futureEvents.length && !pastEvents.length" class="events-empty">
          {{ t('events.empty') }}
        </p>
      </div>
    </main>

    <PauseModal
      v-if="showModal"
      @close="showModal = false"
      @quit="emit('quit')"
    />

    <ConfirmModal
      v-if="showClearConfirm"
      title-key="events.clearAllTitle"
      description-key="events.clearAllDescription"
      confirm-key="events.clearAllConfirm"
      @confirm="clearAllPast"
      @close="showClearConfirm = false"
    />
  </div>
</template>

<style scoped>
.game-screen {
  --thumb-h: calc((100vh - 18.1rem - 16px) / 6);
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
  align-items: stretch;
  gap: 0.5rem;
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
  width: 1.25rem;
  height: 1.25rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}

.resource-icon--worker {
  width: 1.4rem;
  height: 1.4rem;
}

.resource-icon--territory {
  width: 1.55rem;
  height: 1.55rem;
}

/* ---- Season indicator ---- */

.season-icon {
  width: 1.25rem;
  height: 1.25rem;
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
  font-size: 0.8rem;
  font-weight: 400;
  letter-spacing: 0.04em;
  color: var(--color-text);
  min-width: 6ch;
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.header-value--alert {
  color: #c0392b;
}

.header-value--zero {
  color: #c45050;
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
  align-items: stretch;
  padding: 1.25rem 1.5rem 1.5rem;
  gap: 1.5rem;
  overflow: hidden;
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

/* Card stack — 6 equal rows so every card gets 1/6 of available height */
.column-cards {
  flex: 1;
  display: grid;
  grid-template-rows: repeat(6, 1fr);
  gap: 0.5rem;
}

/* Locked building placeholder — mirrors .building-card shell */
.building-card-locked {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.6rem 0.75rem;
  min-height: 0;
  overflow: hidden;
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

/* ---- Events column ---- */

.events-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.events-section-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  padding-bottom: 0.35rem;
}

.events-section-header .events-section-label {
  padding-bottom: 0;
}

.events-clear-btn {
  font-family: var(--font-display);
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(196, 80, 80, 0.5);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  transition: color 0.2s ease;
}

.events-clear-btn:hover {
  color: #c45050;
}

.events-section-label {
  font-family: var(--font-display);
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.4);
  padding-bottom: 0.35rem;
}

.events-list {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

.event-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.4rem 0.55rem;
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border);
  border-left: 2px solid rgba(var(--color-accent-rgb), 0.4);
  border-radius: 4px;
  transition: border-color 0.2s ease;
}

.event-row:hover {
  border-color: rgba(var(--color-accent-rgb), 0.35);
  border-left-color: rgba(var(--color-accent-rgb), 0.7);
}

.event-icon {
  width: 1.1rem;
  height: 1.1rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
  flex-shrink: 0;
}

.event-text {
  flex: 1;
  font-family: var(--font-body);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--color-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  min-width: 0;
}

.event-countdown {
  font-family: var(--font-numeric);
  font-size: 0.8rem;
  font-weight: 400;
  color: var(--color-accent);
  letter-spacing: 0.04em;
  flex-shrink: 0;
}

.event-dismiss {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.3rem;
  height: 1.3rem;
  padding: 0 0 1px;
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 400;
  line-height: 1;
  color: rgba(var(--color-text-rgb), 0.25);
  background: none;
  border: 1px solid rgba(var(--color-text-rgb), 0.08);
  border-radius: 3px;
  cursor: pointer;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.event-dismiss:hover {
  color: #c45050;
  border-color: rgba(196, 80, 80, 0.4);
  background: rgba(196, 80, 80, 0.1);
}

.events-empty {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 300;
  color: rgba(var(--color-text-rgb), 0.3);
  text-align: center;
  padding: 2rem 0;
  letter-spacing: 0.02em;
}

</style>
