<script setup>
import {computed, ref, shallowReactive, watch, provide, onMounted, onUnmounted} from 'vue'
import ConfirmModal from '@/components/modals/confirm_modal.vue'
import PauseModal from '@/components/modals/pause_modal.vue'
import MarketModal from '@/components/modals/market_modal.vue'
import ResearchModal from '@/components/modals/research_modal.vue'
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
import TempleCard from '@/components/buildings/temple_card.vue'
import MonumentCard from '@/components/buildings/monument_card.vue'
import BarracksCard from '@/components/buildings/barracks_card.vue'
import ArcheryCard from '@/components/buildings/archery_card.vue'
import StableCard from '@/components/buildings/stable_card.vue'
import WorkshopCard from '@/components/buildings/workshop_card.vue'
import WallCard from '@/components/buildings/wall_card.vue'
import TowerCard from '@/components/buildings/tower_card.vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {formatNumber, formatRate, formatTime} from '@/js/engine/format.js'
import State from '@/js/engine/state.js'
import {IMG_OTHER_IDLE, IMG_OTHER_LOCK, IMG_OTHER_TERRITORY, IMG_RESOURCE_MAP, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER, SND_OPEN_ACADEMY, SND_OPEN_MARKET} from '@/js/engine/assets.js'
import {createInitialColony, createInitialMeta, BUILDING_GRID, HEADER_RESOURCES, HQ_BUILDING_UNLOCKS, HQ_RESOURCE_UNLOCKS, HQ_TYPES, IMG_BUILDING_HEADQUARTERS_MAP, RESEARCH_TREE, SECONDS_PER_MINUTE, TICK_INTERVAL, TRADEABLE_RESOURCES, UNBOUNDED_RESOURCES} from '@/js/engine/constants.js'
import {SEASON_DURATION} from '@/js/engine/balancing.js'
import {BONUS_STORAGE_CAPACITY, BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_TEMPLE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP} from '@/js/engine/enums.js'
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
  [BUILDING_TEMPLE]: TempleCard,
  [BUILDING_MONUMENT]: MonumentCard,
  [BUILDING_BARRACKS]: BarracksCard,
  [BUILDING_ARCHERY]: ArcheryCard,
  [BUILDING_STABLE]: StableCard,
  [BUILDING_WORKSHOP]: WorkshopCard,
  [BUILDING_WALL]: WallCard,
  [BUILDING_TOWER]: TowerCard,
}

/** Returns the Vue component for a building key.
 * @param {string} key - Building enum key
 * @returns {object} Vue component for the building card
 */
function getCardComponent(key) {
  return CARD_COMPONENTS[key]
}

/** Returns CSS class for production rate coloring (positive, negative, or zero).
 * @param {number} ratePerSecond - Net production rate per second
 * @returns {string} CSS class name
 */
function rateClass(ratePerSecond) {
  const value = Math.round(ratePerSecond * 100) / 100
  if (value > 0) {
    return 'production-rate--positive'
  }
  if (value < 0) {
    return 'production-rate--negative'
  }
  return 'production-rate--zero'
}

/** Whether a resource has a storage cap (is not in the unbounded set).
 * @param {string} resource - Resource key
 * @returns {boolean} True if the resource is capped by storage
 */
function isBounded(resource) {
  return !UNBOUNDED_RESOURCES.includes(resource)
}

/** Percentage of storage cap filled for a resource (0-100).
 * @param {string} resource - Resource key
 * @returns {number} Fill percentage clamped to 0-100
 */
function resourceFillPercent(resource) {
  const current = ui.resources[resource]
  if (!ui.storageCap) {
    return 0
  }
  return Math.min(100, (current / ui.storageCap) * 100)
}

/** Time estimate until a resource is full or empty, or null if stable.
 * @param {string} resource - Resource key
 * @returns {string|null} Localized "full in" / "empty in" string, or null
 */
function timeEstimate(resource) {
  const rate = ui.netProduction[resource]
  if (Math.round(rate * SECONDS_PER_MINUTE) === 0) {
    return null
  }
  const current = ui.resources[resource]

  if (isBounded(resource) && rate > 0) {
    if (current >= ui.storageCap) {
      return null
    }
    return `${t('resource.fullIn')} ${formatTime((ui.storageCap - current) / rate)}`
  }

  if (rate < 0 && current > 0) {
    return `${t('resource.emptyIn')} ${formatTime(current / Math.abs(rate))}`
  }

  return null
}

/** Per-second gross production rate for a resource (before consumption).
 * @param {string} resource - Resource key
 * @returns {number} Production rate per second
 */
function grossProduction(resource) {
  return ui.production[resource]
}

/** Per-second consumption rate for a resource.
 * @param {string} resource - Resource key
 * @returns {number} Consumption rate per second (0 if none)
 */
function resourceConsumption(resource) {
  return ui.consumption[resource] ?? 0
}

/** Whether a resource has any active consumption.
 * @param {string} resource - Resource key
 * @returns {boolean} True if consumption rate is greater than zero
 */
function hasConsumption(resource) {
  return resourceConsumption(resource) > 0
}

/** Season progress as a fraction from 0 to 1. */
const seasonProgress = computed(() => ui.season.seasonElapsed / SEASON_DURATION)

/** Image path for the current season icon (warm or cold). */
const seasonIcon = computed(() => ui.season.isWarm ? IMG_SEASON_WARM : IMG_SEASON_COLD)

/** Localized tooltip text showing the current season name. */
const seasonTooltip = computed(() => `${t('season.name')}: ${t('season.' + ui.season.currentSeason)}`)

/** Building thumbnail path; special-cases HQ to use type-specific image.
 * @param {object} building - Building grid entry with key and img
 * @returns {string} Image asset path for the building
 */
function getBuildingImg(building) {
  if (building.key === BUILDING_HEADQUARTERS) {
    return IMG_BUILDING_HEADQUARTERS_MAP[ui.hqType]
  }
  return building.img
}

/** Set of unlocked building keys based on current HQ type progression. */
const unlockedBuildings = computed(() => {
  const set = new Set([BUILDING_HEADQUARTERS])
  const currentTypeIndex = HQ_TYPES.indexOf(ui.hqType)
  for (let i = 0; i <= currentTypeIndex; i++) {
    for (const key of HQ_BUILDING_UNLOCKS[HQ_TYPES[i]]) {
      set.add(key)
    }
  }
  return set
})

/** Set of visible resource keys based on current HQ type progression. */
const visibleResources = computed(() => {
  const set = new Set()
  const currentTypeIndex = HQ_TYPES.indexOf(ui.hqType)
  for (let i = 0; i <= currentTypeIndex; i++) {
    for (const key of HQ_RESOURCE_UNLOCKS[HQ_TYPES[i]]) {
      set.add(key)
    }
  }
  return set
})

const emit = defineEmits(['quit'])
const showModal = ref(false)
const paused = ref(false)
const state = new State(createInitialMeta(), createInitialColony())
state.update(0)
const showClearConfirm = ref(false)
const showResearchModal = ref(false)
const showMarketModal = ref(false)

const ui = shallowReactive({
  season: {
    currentSeason: '',
    seasonElapsed: 0,
    isWarm: true,
  },
  year: 1,
  resources: {
    territory: 0,
    workers: 0,
    food: 0,
    wood: 0,
    stone: 0,
    copper: 0,
    iron: 0,
    gold: 0,
    faith: 0,
    knowledge: 0,
  },
  storageCap: 0,
  idleWorkers: 0,
  workersCap: 0,
  territoryCap: 0,
  hqType: 'camp',
  production: {
    food: 0,
    wood: 0,
    stone: 0,
    copper: 0,
    iron: 0,
    gold: 0,
    faith: 0,
    knowledge: 0,
  },
  consumption: {
    food: 0,
    wood: 0,
  },
  netProduction: {
    food: 0,
    wood: 0,
    stone: 0,
    copper: 0,
    iron: 0,
    gold: 0,
    faith: 0,
    knowledge: 0,
  },
  buildings: {},
  hq: {},
  expansionCost: null,
  academy: {
    completed: new Set(),
    activeKeys: new Set(),
    activeTimers: {},
  },
  market: {
    feePercent: 0,
    buyPrices: {},
    sellPrices: {},
  },
  futureEvents: [],
  pastEvents: [],
})

/** Fast-path sync: updates only time-sensitive fields that change every rAF frame
 * (season elapsed, construction/upgrade remaining, research timers, event countdowns).
 */
function syncTimers() {
  const {
    colony,
  } = state
  const {
    buildings, season, events,
  } = colony

  ui.season = {
    currentSeason: season.currentSeason,
    seasonElapsed: season.seasonElapsed,
    isWarm: season.isWarm,
  }
  ui.year = colony.year

  // Only rebuild building snapshots if any construction is active
  if (state._constructingKeys.size > 0 || state._hqUpgrading) {
    const bSnap = {
      ...ui.buildings,
    }
    for (const key of state._constructingKeys) {
      const b = buildings[key]
      bSnap[key] = {
        ...bSnap[key],
        constructionRemaining: b.constructionRemaining,
        isConstructing: b.isConstructing,
        level: b.level,
        isUnbuilt: b.isUnbuilt,
      }
    }
    ui.buildings = bSnap

    if (state._hqUpgrading || buildings.headquarters.isConstructing) {
      const hq = buildings.headquarters
      ui.hq = {
        ...ui.hq,
        constructionRemaining: hq.constructionRemaining,
        isConstructing: hq.isConstructing,
        upgradeRemaining: hq.upgradeRemaining,
        isUpgrading: hq.isUpgrading,
        level: hq.level,
        isUnbuilt: hq.isUnbuilt,
        type: hq.type,
        isMaxType: hq.isMaxType,
        nextType: hq.nextType,
      }
    }
  }

  // Research timers
  if (buildings.academy.active.size > 0) {
    const activeTimers = {}
    for (const [
      key,
      research,
    ] of buildings.academy.active) {
      activeTimers[key] = {
        remainingSeconds: research.remainingSeconds,
        duration: research.duration,
      }
    }
    ui.academy = {
      ...ui.academy,
      activeTimers: activeTimers,
    }
  }

  // Event countdowns
  if (events.future.length > 0) {
    ui.futureEvents = events.sortedFuture.map(e => ({
      id: e.id,
      icon: e.icon,
      textKey: e.textKey,
      params: e.params,
      remainingSeconds: e.remainingSeconds,
    }))
  }
}

/** Converts a Cost (or null) into a flat array of [resourceKey, amount] pairs for template iteration. */
function costToEntries(cost) {
  return cost ? [...cost.entries] : []
}

/** Syncs season and year. */
function syncSeason() {
  const {
    season,
  } = state.colony
  ui.season = {
    currentSeason: season.currentSeason,
    seasonElapsed: season.seasonElapsed,
    isWarm: season.isWarm,
  }
  ui.year = state.colony.year
}

/** Syncs resources, storage cap, idle workers, workers cap, territory cap, and HQ type. */
function syncResources() {
  const {
    colony,
  } = state
  const {
    resources, buildings,
  } = colony
  ui.resources = {
    territory: resources.territory,
    workers: resources.workers,
    food: resources.food,
    wood: resources.wood,
    stone: resources.stone,
    copper: resources.copper,
    iron: resources.iron,
    gold: resources.gold,
    faith: resources.faith,
    knowledge: resources.knowledge,
  }
  const bonuses = buildings.academy.completedBonuses(RESEARCH_TREE)
  const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
  ui.storageCap = buildings.storehouse.storageCap(storageBonus)
  ui.idleWorkers = colony.idleWorkers
  ui.workersCap = buildings.house.workersCap
  ui.territoryCap = buildings.headquarters.territoryCap
  ui.hqType = buildings.headquarters.type
}

/** Syncs production, consumption, and net production rates. */
function syncProduction() {
  const {
    colony,
  } = state
  const {
    production, consumption,
  } = colony
  ui.production = {
    food: production.food,
    wood: production.wood,
    stone: production.stone,
    copper: production.copper,
    iron: production.iron,
    gold: production.gold,
    faith: production.faith,
    knowledge: production.knowledge,
  }
  ui.consumption = {
    food: consumption.food,
    wood: consumption.wood,
  }
  ui.netProduction = {
    food: colony.netProduction('food'),
    wood: colony.netProduction('wood'),
    stone: colony.netProduction('stone'),
    copper: colony.netProduction('copper'),
    iron: colony.netProduction('iron'),
    gold: colony.netProduction('gold'),
    faith: colony.netProduction('faith'),
    knowledge: colony.netProduction('knowledge'),
  }
}

/** Syncs all building snapshots. */
function syncAllBuildings() {
  const {
    buildings,
  } = state.colony
  const bSnap = {}
  for (const [
    key,
    b,
  ] of Object.entries(buildings)) {
    const cost = b.levelUpCost
    bSnap[key] = {
      level: b.level,
      isUnbuilt: b.isUnbuilt,
      isConstructing: b.isConstructing,
      constructionRemaining: b.constructionRemaining,
      constructionDuration: b.constructionDuration,
      levelUpCost: cost,
      levelUpCostEntries: costToEntries(cost),
      isProducer: 'workers' in b,
      workers: b.workers ?? 0,
      maxWorkers: b.maxWorkers ?? 0,
      isEmpty: b.isEmpty ?? true,
      isFull: b.isFull ?? false,
    }
  }
  ui.buildings = bSnap
}

/** Syncs a single building snapshot by key. */
function syncBuilding(key) {
  const b = state.colony.buildings[key]
  const cost = b.levelUpCost
  ui.buildings = {
    ...ui.buildings,
    [key]: {
      level: b.level,
      isUnbuilt: b.isUnbuilt,
      isConstructing: b.isConstructing,
      constructionRemaining: b.constructionRemaining,
      constructionDuration: b.constructionDuration,
      levelUpCost: cost,
      levelUpCostEntries: costToEntries(cost),
      isProducer: 'workers' in b,
      workers: b.workers ?? 0,
      maxWorkers: b.maxWorkers ?? 0,
      isEmpty: b.isEmpty ?? true,
      isFull: b.isFull ?? false,
    },
  }
}

/** Syncs headquarters snapshot and expansion cost. */
function syncHQ() {
  const hq = state.colony.buildings.headquarters
  const hqUpgradeCost = hq.upgradeCost
  const expCost = state.expansionCost
  ui.hq = {
    level: hq.level,
    type: hq.type,
    isUnbuilt: hq.isUnbuilt,
    isConstructing: hq.isConstructing,
    constructionRemaining: hq.constructionRemaining,
    constructionDuration: hq.constructionDuration,
    isUpgrading: hq.isUpgrading,
    upgradeRemaining: hq.upgradeRemaining,
    upgradeDuration: hq.upgradeDuration,
    isMaxType: hq.isMaxType,
    nextType: hq.nextType,
    upgradeCost: hqUpgradeCost,
    upgradeCostEntries: costToEntries(hqUpgradeCost),
    levelUpCost: hq.levelUpCost,
    isProducer: false,
  }
  ui.expansionCost = expCost
  ui.expansionCostEntries = costToEntries(expCost)
}

/** Syncs academy state (completed, active, timers). */
function syncAcademy() {
  const academy = state.colony.buildings.academy
  const activeTimers = {}
  for (const [
    key,
    research,
  ] of academy.active) {
    activeTimers[key] = {
      remainingSeconds: research.remainingSeconds,
      duration: research.duration,
    }
  }
  ui.academy = {
    completed: new Set(academy.completed),
    activeKeys: new Set(academy.active.keys()),
    activeTimers: activeTimers,
  }
}

/** Syncs market prices and fee. */
function syncMarket() {
  const market = state.colony.buildings.market
  const buyPrices = {}
  const sellPrices = {}
  for (const r of TRADEABLE_RESOURCES) {
    buyPrices[r] = market.buyPrice(r)
    sellPrices[r] = market.sellPrice(r)
  }
  ui.market = {
    feePercent: Math.round(market.effectiveTradeFee * 100),
    buyPrices: buyPrices,
    sellPrices: sellPrices,
  }
}

/** Syncs future and past events. */
function syncEvents() {
  const {
    events,
  } = state.colony
  ui.futureEvents = events.sortedFuture.map(e => ({
    id: e.id,
    icon: e.icon,
    textKey: e.textKey,
    params: e.params,
    remainingSeconds: e.remainingSeconds,
  }))
  ui.pastEvents = events.sortedPast.map(e => ({
    id: e.id,
    icon: e.icon,
    textKey: e.textKey,
    params: e.params,
  }))
}

/** Full sync: copies all values the templates need from the plain engine state into the reactive ui object. */
function syncUI() {
  syncSeason()
  syncResources()
  syncProduction()
  syncAllBuildings()
  syncHQ()
  syncAcademy()
  syncMarket()
  syncEvents()
}

syncUI()

const actions = {
  levelUpBuilding: (key) => {
    state.levelUpBuilding(key)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents()
    if (key === BUILDING_HEADQUARTERS) {
      syncHQ()
    }
  },
  expandTerritory: () => {
    state.expandTerritory()
    syncResources(); syncProduction(); syncHQ(); syncEvents()
  },
  upgradeHeadquarters: () => {
    state.upgradeHeadquarters()
    syncResources(); syncProduction(); syncHQ(); syncEvents()
  },
  recruitWorker: () => {
    state.recruitWorker()
    syncResources(); syncProduction(); syncEvents()
  },
  assignWorkers: (key, count) => {
    state.assignWorkers(key, count)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents()
  },
  unassignWorkers: (key, count) => {
    state.unassignWorkers(key, count)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents()
  },
  startResearch: (key) => {
    state.startResearch(key)
    syncResources(); syncProduction(); syncAcademy(); syncEvents()
  },
  executeTrade: (resource, direction) => {
    state.executeTrade(resource, direction)
    syncResources(); syncProduction(); syncMarket(); syncEvents()
  },
  dismissEvent: (id) => {
    state.colony.events.dismiss(id)
    syncEvents()
  },
  dismissAllPast: () => {
    state.colony.events.dismissAllPast()
    syncEvents()
  },
}

provide('ui', ui)
provide('actions', actions)
provide('openResearchModal', () => {
  audio.playSound(SND_OPEN_ACADEMY)
  showResearchModal.value = true
})
provide('openMarketModal', () => {
  audio.playSound(SND_OPEN_MARKET)
  showMarketModal.value = true
})

/** Clears all past events and closes the confirmation modal. */
function clearAllPast() {
  actions.dismissAllPast()
  showClearConfirm.value = false
}

let tickTimer = null
let lastTickTime = 0
let progressAnimFrame = null
let lastProgressTickTime = 0
const UI_SYNC_INTERVAL = 50 // ms (~20fps visual updates)
let lastUISyncTime = 0

// --- Perf overlay ---
const perfOverlay = ref(null)
let perfVisible = true
let perfFrameCount = 0
let perfFrameTimeSum = 0
let perfLastSample = 0
let perfSyncUITime = 0
let perfSyncUICount = 0
let perfSyncTimersTime = 0
let perfSyncTimersCount = 0
let perfGameTickTime = 0
let perfGameTickCount = 0
const perfHasMemory = typeof performance !== 'undefined' && !!performance.memory

/** Main 1-second game loop: applies production, consumption, and advances visual progress. */
function gameTick() {
  const now = performance.now()
  const delta = (now - lastTickTime) / 1000
  lastTickTime = now
  const tickStart = now
  state.update(delta)
  perfGameTickTime += performance.now() - tickStart
  perfGameTickCount++

  // Advance progress only when the tab is backgrounded (rAF pauses, so gameTick takes over)
  if (document.hidden) {
    const progressDelta = (now - lastProgressTickTime) / 1000
    lastProgressTickTime = now
    state.advanceSeason(progressDelta)
    state.advanceConstruction(progressDelta)
    state.advanceResearch(progressDelta)
    state.advanceEvents(progressDelta)
  }
  const syncStart = performance.now()
  syncUI()
  perfSyncUITime += performance.now() - syncStart
  perfSyncUICount++
}

/** rAF loop for smooth visual progress (season, construction, research, events). */
function progressTick() {
  if (paused.value) {
    return
  }
  const now = performance.now()
  const delta = (now - lastProgressTickTime) / 1000
  lastProgressTickTime = now
  const prevConstructing = state._constructingKeys.size
  const prevHqUpgrading = state._hqUpgrading
  const prevResearchActive = state.colony.buildings.academy.active.size
  state.advanceSeason(delta)
  state.advanceConstruction(delta)
  state.advanceResearch(delta)
  state.advanceEvents(delta)
  // Full sync when a construction, upgrade, or research just completed (always immediate)
  const justCompleted = state._constructingKeys.size < prevConstructing || (!state._hqUpgrading && prevHqUpgrading) || state.colony.buildings.academy.active.size < prevResearchActive
  if (justCompleted) {
    const t0 = performance.now()
    syncUI()
    perfSyncUITime += performance.now() - t0
    perfSyncUICount++
    lastUISyncTime = now
  } else if (now - lastUISyncTime >= UI_SYNC_INTERVAL) {
    const t0 = performance.now()
    syncTimers()
    perfSyncTimersTime += performance.now() - t0
    perfSyncTimersCount++
    lastUISyncTime = now
  }

  // Perf sampling (discard stale data after returning from background tab)
  if (delta > 1) {
    perfFrameCount = 0
    perfFrameTimeSum = 0
    perfSyncUITime = 0
    perfSyncUICount = 0
    perfSyncTimersTime = 0
    perfSyncTimersCount = 0
    perfGameTickTime = 0
    perfGameTickCount = 0
    perfLastSample = now
  }
  perfFrameCount++
  perfFrameTimeSum += delta * 1000
  if (perfVisible && now - perfLastSample >= 1000) {
    const el = perfOverlay.value
    if (el) {
      const elapsed = (now - perfLastSample) / 1000
      const fps = Math.round(perfFrameCount / elapsed)
      const avgFrame = (perfFrameTimeSum / perfFrameCount).toFixed(1)
      const avgSyncUI = perfSyncUICount ? (perfSyncUITime / perfSyncUICount).toFixed(2) : '—'
      const avgSyncTimers = perfSyncTimersCount ? (perfSyncTimersTime / perfSyncTimersCount).toFixed(2) : '—'
      const avgTick = perfGameTickCount ? (perfGameTickTime / perfGameTickCount).toFixed(2) : '—'
      let text = `FPS: ${fps}\nFrame: ${avgFrame}ms\nsyncUI: ${avgSyncUI}ms\nsyncTimers: ${avgSyncTimers}ms\ntick: ${avgTick}ms`
      if (perfHasMemory) {
        const usedBytes = performance.memory.usedJSHeapSize
        const limitBytes = performance.memory.jsHeapSizeLimit
        const usedLabel = usedBytes >= 1073741824 ? `${Math.round(usedBytes / 1073741824)} GB` : `${Math.round(usedBytes / 1048576)} MB`
        const limitLabel = limitBytes >= 1073741824 ? `${Math.round(limitBytes / 1073741824)} GB` : `${Math.round(limitBytes / 1048576)} MB`
        text += `\nHeap: ${usedLabel} / ${limitLabel}`
      }
      el.textContent = text
    }
    perfFrameCount = 0
    perfFrameTimeSum = 0
    perfSyncUITime = 0
    perfSyncUICount = 0
    perfSyncTimersTime = 0
    perfSyncTimersCount = 0
    perfGameTickTime = 0
    perfGameTickCount = 0

    perfLastSample = now
  }

  progressAnimFrame = requestAnimationFrame(progressTick)
}

/** Toggles the pause modal when Escape is pressed (ignores input fields).
 * @param {KeyboardEvent} event - Keyboard event
 */
function handleKeydown(event) {
  if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') {
    return
  }
  if (event.key === 'Escape') {
    showModal.value = !showModal.value
  }
  if (event.key === 'F3') {
    event.preventDefault()
    perfVisible = !perfVisible
    if (perfOverlay.value) {
      perfOverlay.value.style.display = perfVisible ? 'block' : 'none'
    }
    if (perfVisible) {
      perfLastSample = performance.now()
    }
  }
}

watch(showModal, (isOpen) => {
  if (isOpen) {
    paused.value = true
    clearInterval(tickTimer)
    tickTimer = null
    cancelAnimationFrame(progressAnimFrame)
    progressAnimFrame = null
  } else {
    paused.value = false
    const now = performance.now()
    lastTickTime = now
    lastProgressTickTime = now
    lastUISyncTime = now
    perfFrameCount = 0
    perfFrameTimeSum = 0
    perfSyncUITime = 0
    perfSyncUICount = 0
    perfSyncTimersTime = 0
    perfSyncTimersCount = 0
    perfGameTickTime = 0
    perfGameTickCount = 0

    perfLastSample = now
    tickTimer = setInterval(gameTick, TICK_INTERVAL)
    progressAnimFrame = requestAnimationFrame(progressTick)
  }
})

onMounted(() => {
  // Bubble phase: modals register in capture phase so they intercept Escape first
  window.addEventListener('keydown', handleKeydown)
  const now = performance.now()
  lastTickTime = now
  lastProgressTickTime = now
  lastUISyncTime = now
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
    <pre ref="perfOverlay" class="perf-overlay" />
    <header class="game-header">
      <!-- Season & year indicator -->
      <div class="header-season-group">
        <div class="header-section header-season tooltip" :data-tooltip="seasonTooltip">
          <img class="season-icon" :src="seasonIcon" alt="">
          <div class="season-track" :class="'season-track--' + ui.season.currentSeason">
            <div class="season-fill" :style="{ width: (seasonProgress * 100) + '%' }" />
          </div>
        </div>
        <span class="header-year">{{ t('year.label') }} <span class="header-year-num">{{ ui.year }}</span></span>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Resources -->
      <div class="header-section header-resources">
        <template v-for="resource in HEADER_RESOURCES" :key="resource">
          <div v-if="visibleResources.has(resource)" class="resource-box">
            <!-- Row 1: icon + current amount -->
            <div class="resource-row-top">
              <img class="resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
              <span class="resource-value" :class="{ 'resource-value--alert': isBounded(resource) && Math.floor(ui.resources[resource]) >= ui.storageCap, 'resource-value--zero': Math.floor(ui.resources[resource]) === 0 }">
                {{ formatNumber(ui.resources[resource]) }}
              </span>
            </div>

            <!-- Row 2: production rate -->
            <span class="production-rate" :class="rateClass(ui.netProduction[resource])">{{ formatRate(ui.netProduction[resource]) }}</span>

            <!-- Row 3: progress bar track (always rendered for alignment; fill bounded only) -->
            <div class="resource-row-bottom">
              <div class="resource-bar" :class="{ 'resource-bar--hidden': !isBounded(resource) }">
                <div
                  v-if="isBounded(resource)"
                  class="resource-bar-fill"
                  :class="ui.netProduction[resource] > 0 ? 'resource-bar-fill--positive' : 'resource-bar-fill--negative'"
                  :style="{ width: resourceFillPercent(resource) + '%' }"
                />
              </div>
            </div>

            <!-- Rich tooltip -->
            <div class="resource-tooltip">
              <span>{{ t('resource.' + resource) }}</span>
              <!-- Intentional: toLocaleString() instead of formatNumber() to display all digits -->
              <span class="resource-tooltip-time">{{ t('resource.amount') }}: {{ Math.floor(ui.resources[resource]).toLocaleString() }}</span>
              <span v-if="isBounded(resource)" class="resource-tooltip-time">{{ t('resource.maxCapacity') }}: {{ formatNumber(ui.storageCap) }}</span>
              <span v-if="timeEstimate(resource)" class="resource-tooltip-time">{{ timeEstimate(resource) }}</span>
              <span v-if="hasConsumption(resource)" class="resource-tooltip-time">{{ t('resource.producing') }}: {{ +grossProduction(resource).toFixed(2) }}</span>
              <span v-if="hasConsumption(resource)" class="resource-tooltip-time">{{ t('resource.consuming') }}: {{ +resourceConsumption(resource).toFixed(2) }}</span>
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
          <span class="resource-value" :class="{ 'resource-value--alert': ui.resources.workers >= ui.workersCap, 'resource-value--zero': ui.resources.workers === 0 }">{{ formatNumber(ui.resources.workers) }}/{{ formatNumber(ui.workersCap) }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.idleWorkers')">
          <img class="resource-icon" :src="IMG_OTHER_IDLE" :alt="t('resource.idleWorkers')">
          <span class="resource-value" :class="{ 'resource-value--alert': ui.idleWorkers > 0 }">{{ ui.idleWorkers }}</span>
        </div>
        <div class="header-resource tooltip" :data-tooltip="t('resource.territory')">
          <img class="resource-icon resource-icon--territory" :src="IMG_OTHER_TERRITORY" :alt="t('resource.territory')">
          <span class="resource-value" :class="{ 'resource-value--alert': ui.resources.territory >= ui.territoryCap }">{{ formatNumber(ui.resources.territory) }}/{{ formatNumber(ui.territoryCap) }}</span>
        </div>
      </div>

      <!-- Decorative divider -->
      <span class="header-divider" />

      <!-- Menu button -->
      <button class="btn-gold header-menu-button" @click="playTap(); showModal = true">
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
              v-if="unlockedBuildings.has(building.key)"
              :building-key="building.key"
              :img="getBuildingImg(building)"
              :building="ui.buildings[building.key]"
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
        <div v-if="ui.futureEvents.length">
          <h3 class="events-section-label">{{ t('events.future') }}</h3>
          <div class="events-list">
            <div v-for="event in ui.futureEvents" :key="event.id" class="event-row">
              <img class="event-icon" :src="event.icon" :alt="t(event.textKey, ...event.params)">
              <span class="event-text">{{ t(event.textKey, ...event.params) }}</span>
              <span class="event-countdown">{{ formatTime(event.remainingSeconds) }}</span>
            </div>
          </div>
        </div>

        <!-- Past events -->
        <div v-if="ui.pastEvents.length">
          <div class="events-section-header">
            <h3 class="events-section-label">{{ t('events.past') }}</h3>
            <button class="events-clear-btn" @click="playTap(); showClearConfirm = true">{{ t('events.clearAll') }}</button>
          </div>
          <div class="events-list">
            <div v-for="event in ui.pastEvents" :key="event.id" class="event-row">
              <img class="event-icon" :src="event.icon" :alt="t(event.textKey, ...event.params)">
              <span class="event-text">{{ t(event.textKey, ...event.params) }}</span>
              <button class="event-dismiss" @click="playTap(); actions.dismissEvent(event.id)">&times;</button>
            </div>
          </div>
        </div>

        <!-- Empty state -->
        <p v-if="!ui.futureEvents.length && !ui.pastEvents.length" class="events-empty">
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

    <ResearchModal
      v-if="showResearchModal"
      @close="showResearchModal = false"
    />

    <MarketModal
      v-if="showMarketModal"
      @close="showMarketModal = false"
    />
  </div>
</template>

<style scoped>
.perf-overlay {
  position: fixed;
  bottom: 0.5rem;
  left: 0.5rem;
  background: rgba(0, 0, 0, 0.7);
  color: rgba(0, 255, 0, 1);
  font-family: monospace;
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  z-index: 9999;
  pointer-events: none;
  white-space: pre;
  margin: 0;
}

/* Root layout container; fills viewport and stacks header + content vertically */
.game-screen {
  height: 100vh;
  height: 100dvh;
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
  box-shadow: 0 2px 8px rgba(var(--color-shadow-rgb), 0.3);
}

/* ---- Sections ---- */

.header-section {
  display: flex;
  align-items: center;
  gap: 1rem;
}

/* Season indicator with icon and progress bar */
.header-season {
  gap: 0.5rem;
  flex-shrink: 0;
}

/* Vertically stacks season indicator and year label */
.header-season-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.35rem;
  flex-shrink: 0;
}

/* "YEAR" label text in subdued uppercase */
.header-year {
  font-family: var(--font-display);
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: rgba(var(--color-text-rgb), 0.55);
}

/* Numeric year value displayed in monospace font */
.header-year-num {
  font-family: var(--font-numeric);
  color: var(--color-text);
  margin-left: 0.5em;
}

/* Centered resource boxes that expand to fill available header space */
.header-resources {
  flex: 1;
  justify-content: center;
  align-items: stretch;
  gap: 0.5rem;
}

/* Colony stats (population, idle workers, territory) with fixed minimum width */
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

/* Larger icon size for worker population display */
.resource-icon--worker {
  width: 1.4rem;
  height: 1.4rem;
}

/* Slightly larger icon size for territory display */
.resource-icon--territory {
  width: 1.55rem;
  height: 1.55rem;
}

/* ---- Season indicator ---- */

.season-icon {
  width: 1.25rem;
  height: 1.25rem;
}

/* Thin horizontal bar background for season progress */
.season-track {
  width: 5.5rem;
  height: 4px;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 0.125rem;
  overflow: hidden;
}

/* Animated fill bar inside the season track */
.season-fill {
  height: 100%;
  border-radius: 0.125rem;
}

/* Warm season: golden gradient fill with warm glow */
.season-track--warm .season-fill {
  background: linear-gradient(90deg, rgba(184, 148, 62, 1), rgba(212, 168, 67, 1));
  box-shadow: 0 0 6px rgba(184, 148, 62, 0.4);
}

/* Cold season: blue gradient fill with cool glow */
.season-track--cold .season-fill {
  background: linear-gradient(90deg, rgba(91, 143, 185, 1), rgba(126, 200, 227, 1));
  box-shadow: 0 0 6px rgba(126, 200, 227, 0.35);
}

/* ---- Decorative dividers between sections ---- */

.header-divider {
  width: 1px;
  height: 1.6rem;
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0),
    rgba(var(--color-accent-rgb), 0.2),
    rgba(var(--color-accent-rgb), 0)
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
  padding: 1rem 1.5rem 1.5rem;
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
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  line-height: 1;
  text-transform: uppercase;
  color: rgba(var(--color-accent-rgb), 0.75);
  text-align: center;
  margin-bottom: 0;
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
  container-type: size;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.6rem 0.75rem;
  min-height: 0;
  overflow: hidden;
  background: rgba(39, 33, 25, 0.3);
  border: 1px solid var(--color-border);
  border-radius: 0.25rem;
  opacity: 0.4;
}

.locked-icon {
  width: 40cqh;
  height: 40cqh;
  object-fit: contain;
  filter: grayscale(1);
  opacity: 0.35;
}

/* ---- Events column ---- */

.events-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

/* Row layout for past-events heading with clear-all button aligned right */
.events-section-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  padding-bottom: 0.35rem;
}

/* Remove bottom padding when label is inside the header row */
.events-section-header .events-section-label {
  padding-bottom: 0;
}

/* Destructive-style text button to clear all past events */
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
  color: rgba(196, 80, 80, 1);
}

/* Subdued uppercase section label for "Future" / "Past" event groups */
.events-section-label {
  font-family: var(--font-display);
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.4);
  padding-bottom: 0.35rem;
}

/* Vertical stack of event rows with small gaps */
.events-list {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

/* Individual event card with accent left border */
.event-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.4rem 0.55rem;
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border);
  border-left: 2px solid rgba(var(--color-accent-rgb), 0.4);
  border-radius: 0.25rem;
  transition: border-color 0.2s ease;
}

.event-row:hover {
  border-color: rgba(var(--color-accent-rgb), 0.35);
  border-left-color: rgba(var(--color-accent-rgb), 0.7);
}

/* Small event type icon with drop shadow */
.event-icon {
  width: 1.1rem;
  height: 1.1rem;
  object-fit: contain;
  flex-shrink: 0;
}

/* Event description text, truncated with ellipsis on overflow */
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

/* Monospace countdown timer for upcoming events */
.event-countdown {
  font-family: var(--font-numeric);
  font-size: 0.8rem;
  font-weight: 400;
  color: var(--color-accent);
  letter-spacing: 0.04em;
  flex-shrink: 0;
}

/* Small close button to dismiss a single past event */
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
  border-radius: 0.1875rem;
  cursor: pointer;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.event-dismiss:hover {
  color: rgba(196, 80, 80, 1);
  border-color: rgba(196, 80, 80, 0.4);
  background: rgba(196, 80, 80, 0.1);
}

/* Placeholder text shown when no events exist */
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
