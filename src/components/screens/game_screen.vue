<script setup>
import {computed, ref, shallowReactive, watch, provide, onMounted, onUnmounted} from 'vue'
import ChallengeFailureModal from '@/components/modals/challenge_failure_modal.vue'
import ChallengeDetailModal from '@/components/modals/challenge_detail_modal.vue'
import ChallengeSuccessModal from '@/components/modals/challenge_success_modal.vue'
import ChallengeWinModal from '@/components/modals/challenge_win_modal.vue'
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
import {formatNumber, formatNumberFull, formatRate, formatTime} from '@/js/engine/format.js'
import storage from '@/js/engine/storage.js'
import {IMG_OTHER_IDLE, IMG_OTHER_LOCK, IMG_OTHER_PRODUCTIVITY, IMG_OTHER_TERRITORY, IMG_RESOURCE_MAP, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER, SND_OPEN_ACADEMY, SND_OPEN_MARKET} from '@/js/engine/assets.js'
import TutorialBanner from '@/components/tutorial/tutorial_banner.vue'
import TutorialModal from '@/components/tutorial/tutorial_modal.vue'
import SettingsModal from '@/components/modals/settings_modal.vue'
import {BUILDING_IMAGE_MAP, BUILDING_GRID, GAME_SPEED_DEFAULT, GAME_SPEED_OPTIONS, HEADER_RESOURCES, HQ_BUILDING_UNLOCKS, HQ_RESOURCE_UNLOCKS, HQ_TYPES, IMG_BUILDING_HEADQUARTERS_MAP, RESEARCH_TREE, SECONDS_PER_MINUTE, TICK_INTERVAL, TRADEABLE_RESOURCES, TUTORIAL_MODALS, TUTORIAL_STEPS, UNBOUNDED_RESOURCES} from '@/js/engine/constants.js'
import {BULK_WORKER_AMOUNT, SEASON_DURATION} from '@/js/engine/balancing.js'
import {BONUS_STORAGE_CAPACITY, BUILDING_ACADEMY, BUILDING_ALTAR, CHALLENGE_MODAL_FAILURE, CHALLENGE_MODAL_REWARD, CHALLENGE_MODAL_WIN, CHALLENGE_STATUS_STARTED, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_TEMPLE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP, EMIT_QUIT, EMIT_RESTART, EVENT_TYPE_CHALLENGE_STARTED} from '@/js/engine/enums.js'
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

/**
 * Returns true when a resource card should show a penalized (red) state:
 * - net production is zero or negative, OR
 * - the resource is storage-bounded and has reached the cap
 */
function isResourcePenalized(resource) {
  return ui.netProduction[resource] <= 0
    || (isBounded(resource) && Math.floor(ui.resources[resource]) >= ui.storageCap)
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
const seasonTooltip = computed(() => t('season.' + ui.season.currentSeason + 'Season'))

// Dismiss idle workers
const canDismiss = computed(() => ui.idleWorkers > 0)
const dismissTooltip = computed(() => canDismiss.value ? t('house.dismissWorker') : t('house.noIdleWorkers'))

function dismissWorker(event) {
  if (!canDismiss.value) {
    return
  }
  playTap()
  const count = event.ctrlKey || event.metaKey ? BULK_WORKER_AMOUNT : 1
  state.dismissWorkers(count)
  syncResources(); syncProduction(); syncEvents(); syncTutorial()
}

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

const props = defineProps({
  initialState: {
    type: Object,
    required: true,
  },
})

const emit = defineEmits([
  EMIT_QUIT,
  EMIT_RESTART,
])
const showModal = ref(false)
const state = props.initialState
const showClearConfirm = ref(false)
const showConfirmQuit = ref(false)
const showConfirmRestart = ref(false)
const showSettingsModal = ref(false)
const showResearchModal = ref(false)
const showMarketModal = ref(false)
const showChallengeModal = ref(false)
const showSaveIndicator = ref(false)
const hasSavedGame = ref(storage.savedGame !== null)
let saveIndicatorTimer = null
let autosaveTimer = null

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
  productivity: 1,
  gameSpeed: GAME_SPEED_DEFAULT,
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
  challenges: {
    active: null,
    totalCount: 10,
    allCompleted: false,
    activeBlessingChoices: [],
    activePunishment: null,
  },
  challengeModal: null,
  tutorial: {
    stepTextKey: null,
    stepBuilding: null,
    stepBuildingImg: null,
    stepNumber: 0,
    totalSteps: 0,
    isActive: false,
    activeModal: null,
    activeModalTitle: null,
    activeModalBody: null,
  },
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
    const buildingSnapshot = {
      ...ui.buildings,
    }
    for (const key of state._constructingKeys) {
      const building = buildings[key]
      buildingSnapshot[key] = {
        ...buildingSnapshot[key],
        constructionRemaining: building.constructionRemaining,
        isConstructing: building.isConstructing,
        level: building.level,
        isUnbuilt: building.isUnbuilt,
      }
    }
    ui.buildings = buildingSnapshot

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
    ui.futureEvents = events.sortedFuture.map(event => ({
      id: event.id,
      icon: event.icon,
      textKey: event.textKey,
      params: event.params,
      remainingSeconds: event.remainingSeconds,
      action: event.action,
      requirementsMet: event.type === EVENT_TYPE_CHALLENGE_STARTED && state.areChallengeRequirementsMet(),
    }))
  } else {
    ui.futureEvents = []
  }

  // Challenge timer (smooth countdown)
  if (ui.challenges.active && state.meta.challenges.active && state.meta.challenges.active.status === CHALLENGE_STATUS_STARTED) {
    const active = state.meta.challenges.active
    ui.challenges = {
      ...ui.challenges,
      active: {
        ...ui.challenges.active,
        timeoutElapsed: active.timeoutElapsed,
      },
    }
  }

  // Challenge modal state (may have changed from advanceChallenges)
  if (state.challengeModal !== ui.challengeModal) {
    syncChallenges()
  }

  if (state.meta.tutorial.activeModal) {
    syncTutorial()
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
  ui.productivity = colony.productivity
  ui.gameSpeed = state.meta.gameSpeed
}

/** Syncs all building snapshots. */
function syncAllBuildings() {
  const {
    buildings,
  } = state.colony
  const buildingSnapshot = {}
  for (const [
    key,
    building,
  ] of Object.entries(buildings)) {
    const cost = building.levelUpCost
    buildingSnapshot[key] = {
      level: building.level,
      isUnbuilt: building.isUnbuilt,
      isConstructing: building.isConstructing,
      constructionRemaining: building.constructionRemaining,
      constructionDuration: building.constructionDuration,
      levelUpCost: cost,
      levelUpCostEntries: costToEntries(cost),
      isProducer: 'workers' in building,
      workers: building.workers ?? 0,
      maxWorkers: building.maxWorkers ?? 0,
      isEmpty: building.isEmpty ?? true,
      isFull: building.isFull ?? false,
    }
  }
  ui.buildings = buildingSnapshot
}

/** Syncs a single building snapshot by key. */
function syncBuilding(key) {
  const building = state.colony.buildings[key]
  const cost = building.levelUpCost
  ui.buildings = {
    ...ui.buildings,
    [key]: {
      level: building.level,
      isUnbuilt: building.isUnbuilt,
      isConstructing: building.isConstructing,
      constructionRemaining: building.constructionRemaining,
      constructionDuration: building.constructionDuration,
      levelUpCost: cost,
      levelUpCostEntries: costToEntries(cost),
      isProducer: 'workers' in building,
      workers: building.workers ?? 0,
      maxWorkers: building.maxWorkers ?? 0,
      isEmpty: building.isEmpty ?? true,
      isFull: building.isFull ?? false,
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
  for (const resource of TRADEABLE_RESOURCES) {
    buyPrices[resource] = market.buyPrice(resource)
    sellPrices[resource] = market.sellPrice(resource)
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
  ui.futureEvents = events.sortedFuture.map(event => ({
    id: event.id,
    icon: event.icon,
    textKey: event.textKey,
    params: event.params,
    remainingSeconds: event.remainingSeconds,
    action: event.action,
    requirementsMet: event.type === EVENT_TYPE_CHALLENGE_STARTED && state.areChallengeRequirementsMet(),
  }))
  ui.pastEvents = events.sortedPast.map(event => ({
    id: event.id,
    icon: event.icon,
    textKey: event.textKey,
    params: event.params,
  }))
}

/** Syncs tutorial state. */
function syncTutorial() {
  const {
    tutorial,
  } = state.meta
  const step = TUTORIAL_STEPS[tutorial.currentStep]
  const modalConfig = tutorial.activeModal ? TUTORIAL_MODALS[tutorial.activeModal] : null
  ui.tutorial = {
    stepTextKey: step?.textKey ?? null,
    stepHintKey: step?.hintKey ?? null,
    stepBuilding: step?.building ?? null,
    stepBuildingImg: step?.building ? BUILDING_IMAGE_MAP[step.building] : null,
    stepNumber: tutorial.currentStep + 1,
    totalSteps: TUTORIAL_STEPS.length,
    isActive: tutorial.isActive,
    activeModal: tutorial.activeModal,
    activeModalTitle: modalConfig?.titleKey ?? null,
    activeModalBody: modalConfig?.bodyKey ?? null,
  }
}

/** Syncs challenge state. */
function syncChallenges() {
  const {
    challenges,
  } = state.meta
  const active = challenges.active
  ui.challenges = {
    active: active
      ? {
        index: active.index,
        status: active.status,
        isStarted: active.status === CHALLENGE_STATUS_STARTED,
        timeout: active.timeout,
        timeoutElapsed: active.timeoutElapsed,
        requirements: active.requirements,
        blessings: active.blessings,
        punishment: active.punishment,
      }
      : null,
    totalCount: challenges.totalCount,
    allCompleted: challenges.allCompleted,
    activeBlessingChoices: active ? active.blessings.map(blessing => ({
      type: blessing.type,
      timeout: blessing.timeout,
      productivity: blessing.productivity,
      resources: blessing.resources,
      territory: blessing.territory,
      construction: blessing.construction,
      warm: blessing.warm,
      cold: blessing.cold,
    })) : [],
    activePunishment: active ? {
      type: active.punishment.type,
      timeout: active.punishment.timeout,
      faith: active.punishment.faith,
      productivityFarm: active.punishment.productivityFarm,
      productivityWoodcutter: active.punishment.productivityWoodcutter,
      productivityMines: active.punishment.productivityMines,
      productivityGeneral: active.punishment.productivityGeneral,
      resources: active.punishment.resources,
      workers: active.punishment.workers,
      levels: active.punishment.levels,
    } : null,
  }
  ui.challengeModal = state.challengeModal
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
  syncChallenges()
  syncTutorial()
}

syncUI()

const actions = {
  levelUpBuilding: (key) => {
    state.levelUpBuilding(key)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents(); syncTutorial()
    if (key === BUILDING_HEADQUARTERS) {
      syncHQ()
    }
  },
  downgradeBuilding: (key) => {
    state.downgradeBuilding(key)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents(); syncTutorial()
  },
  expandTerritory: () => {
    state.expandTerritory()
    syncResources(); syncProduction(); syncHQ(); syncEvents(); syncTutorial()
  },
  upgradeHeadquarters: () => {
    state.upgradeHeadquarters()
    syncResources(); syncProduction(); syncHQ(); syncEvents(); syncTutorial()
  },
  recruitWorker: () => {
    state.recruitWorker()
    syncResources(); syncProduction(); syncEvents(); syncTutorial()
  },
  assignWorkers: (key, count) => {
    state.assignWorkers(key, count)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents(); syncTutorial()
  },
  unassignWorkers: (key, count) => {
    state.unassignWorkers(key, count)
    syncResources(); syncProduction(); syncBuilding(key); syncEvents(); syncTutorial()
  },
  startResearch: (key) => {
    state.startResearch(key)
    syncResources(); syncProduction(); syncAcademy(); syncEvents(); syncTutorial()
  },
  executeTrade: (resource, direction, amount) => {
    state.executeTrade(resource, direction, amount)
    syncResources(); syncProduction(); syncMarket(); syncEvents(); syncTutorial()
  },
  dismissEvent: (id) => {
    state.colony.events.dismiss(id)
    syncEvents()
  },
  dismissAllPast: () => {
    state.colony.events.dismissAllPast()
    syncEvents()
  },
  selectBlessing: (index) => {
    state.selectBlessing(index)
    syncUI()
  },
  acknowledgePunishment: () => {
    state.acknowledgePunishment()
    syncUI()
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
provide('openChallengeModal', () => {
  showChallengeModal.value = true
})

/** Saves the current game state to localStorage and closes the pause modal. */
function saveGame() {
  storage.savedGame = state.toJSON()
  hasSavedGame.value = true
  showModal.value = false
}

/** Shows the save indicator for 1.5 seconds. */
function flashSaveIndicator() {
  showSaveIndicator.value = true
  clearTimeout(saveIndicatorTimer)
  saveIndicatorTimer = setTimeout(() => {
    showSaveIndicator.value = false
  }, 1500)
}

/** Starts the autosave interval if autosave is enabled. */
function startAutosave() {
  stopAutosave()
  if (storage.autosaveEnabled) {
    autosaveTimer = setInterval(() => {
      storage.savedGame = state.toJSON()
      hasSavedGame.value = true
      flashSaveIndicator()
    }, storage.autosaveInterval * 60 * 1000)
  }
}

/** Stops the autosave interval. */
function stopAutosave() {
  clearInterval(autosaveTimer)
  autosaveTimer = null
}

/** Handles settings modal close — restarts autosave timer with current settings. */
function closeSettings() {
  showSettingsModal.value = false
  if (!showModal.value) {
    startAutosave()
  }
}

/** Loads the saved game state from localStorage. */
function loadGame() {
  const savedData = storage.savedGame
  if (savedData) {
    showModal.value = false
    emit(EMIT_RESTART, savedData)
  }
}

/** Opens the settings modal on top of the pause modal. */
function openSettings() {
  showSettingsModal.value = true
}

/** Shows the confirm restart modal from the pause menu. */
function handleRestartRequest() {
  showModal.value = false
  showConfirmRestart.value = true
}

/** Cancels restart and returns to the pause modal. */
function cancelRestart() {
  showConfirmRestart.value = false
  showModal.value = true
}

/** Restarts the game with a fresh state. */
function confirmRestart() {
  storage.deleteSavedGame()
  hasSavedGame.value = false
  emit(EMIT_RESTART, null)
}

/** Shows the confirm quit modal from the pause menu. */
function handleQuitRequest() {
  showModal.value = false
  showConfirmQuit.value = true
}

/** Cancels quit and returns to the pause modal. */
function cancelQuit() {
  showConfirmQuit.value = false
  showModal.value = true
}

/** Quits to the home screen without saving. */
function confirmQuit() {
  emit(EMIT_QUIT)
}

/** Clears all past events and closes the confirmation modal. */
function clearAllPast() {
  actions.dismissAllPast()
  showClearConfirm.value = false
}

/** Handles clicking a future event with an action. */
function handleEventAction(action) {
  if (action === 'openChallengeModal') {
    showChallengeModal.value = true
  }
}

/** Handles "Continue Playing" from win modal. Unpauses without creating duplicate loops
 * since the existing setInterval/rAF loops are still alive (they just skip when paused).
 */
function handleWinContinue() {
  state.continueAfterWin()
  const now = performance.now()
  lastTickTime = now
  lastProgressTickTime = now
  lastUISyncTime = now
  syncUI()
}

/** Handles "Return Home" from win modal. */
function handleWinQuit() {
  emit(EMIT_QUIT)
}

/** Dismisses the active tutorial modal, unpauses, and syncs UI. */
function dismissTutorialModal() {
  const tutorial = state.meta.tutorial
  if (tutorial.activeModal) {
    tutorial.dismissedModals.add(tutorial.activeModal)
    tutorial.activeModal = null
    state.paused = false
    syncUI()
  }
}

/** Increases game speed to the next available option. No-op at maximum. */
function speedUp() {
  const idx = GAME_SPEED_OPTIONS.indexOf(state.meta.gameSpeed)
  if (idx < GAME_SPEED_OPTIONS.length - 1) {
    state.meta.gameSpeed = GAME_SPEED_OPTIONS[idx + 1]
    ui.gameSpeed = state.meta.gameSpeed
  }
}

/** Decreases game speed to the previous available option. No-op at minimum. */
function speedDown() {
  const idx = GAME_SPEED_OPTIONS.indexOf(state.meta.gameSpeed)
  if (idx > 0) {
    state.meta.gameSpeed = GAME_SPEED_OPTIONS[idx - 1]
    ui.gameSpeed = state.meta.gameSpeed
  }
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
  if (state.paused) {
    lastTickTime = now
    lastProgressTickTime = now
    return
  }
  const delta = (now - lastTickTime) / 1000 * state.meta.gameSpeed
  lastTickTime = now
  const tickStart = now
  state.update(delta)
  state.checkTutorial()
  perfGameTickTime += performance.now() - tickStart
  perfGameTickCount++

  // Advance progress only when the tab is backgrounded (rAF pauses, so gameTick takes over)
  if (document.hidden) {
    const progressDelta = (now - lastProgressTickTime) / 1000 * state.meta.gameSpeed
    lastProgressTickTime = now
    state.advanceSeason(progressDelta)
    state.advanceConstruction(progressDelta)
    state.advanceResearch(progressDelta)
    state.advanceChallenges(progressDelta)
    state.advanceEvents(progressDelta)
  }
  const syncStart = performance.now()
  syncUI()
  perfSyncUITime += performance.now() - syncStart
  perfSyncUICount++
}

/** rAF loop for smooth visual progress (season, construction, research, events). */
function progressTick() {
  if (state.paused) {
    progressAnimFrame = requestAnimationFrame(progressTick)
    return
  }
  const now = performance.now()
  const delta = (now - lastProgressTickTime) / 1000 * state.meta.gameSpeed
  lastProgressTickTime = now
  const prevConstructing = state._constructingKeys.size
  const prevHqUpgrading = state._hqUpgrading
  const prevResearchActive = state.colony.buildings.academy.active.size
  state.advanceSeason(delta)
  state.advanceConstruction(delta)
  state.advanceResearch(delta)
  state.advanceChallenges(delta)
  if (state.challengeModal && showChallengeModal.value) {
    showChallengeModal.value = false
  }
  state.advanceEvents(delta)
  // Full sync when a construction, upgrade, or research just completed, or a tutorial modal was triggered (always immediate)
  const justCompleted = state._constructingKeys.size < prevConstructing || (!state._hqUpgrading && prevHqUpgrading) || state.colony.buildings.academy.active.size < prevResearchActive || state.paused
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
    const element = perfOverlay.value
    if (element) {
      const elapsed = (now - perfLastSample) / 1000
      const fps = Math.round(perfFrameCount / elapsed)
      const avgFrame = (Math.floor((perfFrameTimeSum / perfFrameCount) * 10) / 10).toFixed(1)
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
      element.textContent = text
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
  if (event.key === 'F9') {
    event.preventDefault()
    storage.savedGame = state.toJSON()
    hasSavedGame.value = true
    flashSaveIndicator()
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
    state.paused = true
    clearInterval(tickTimer)
    tickTimer = null
    cancelAnimationFrame(progressAnimFrame)
    progressAnimFrame = null
    stopAutosave()
  } else if (!showConfirmQuit.value && !showConfirmRestart.value) {
    state.paused = false
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
    startAutosave()
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
  startAutosave()
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
  clearInterval(tickTimer)
  cancelAnimationFrame(progressAnimFrame)
  clearTimeout(saveIndicatorTimer)
  stopAutosave()
})
</script>

<template>
  <div class="game-screen">
    <pre ref="perfOverlay" class="perf-overlay" />
    <header class="game-header">
      <!-- Season & year indicator -->
      <div class="header-season-group">
        <div class="header-section header-season tooltip" :data-tooltip="seasonTooltip">
          <div class="season-track" :class="'season-track--' + ui.season.currentSeason">
            <div class="season-fill" :style="{ width: (seasonProgress * 100) + '%' }" />
          </div>
        </div>
        <span class="header-year">
          <img class="season-icon" :src="seasonIcon" alt="">
          {{ t('screen.game.header.year') }} <span class="header-year-num">{{ ui.year }}</span>
        </span>
      </div>

      <!-- Resources -->
      <div class="header-section header-resources">
        <!-- Productivity indicator -->
        <div class="resource-box productivity-box" :class="{ 'productivity-box--penalized': ui.productivity < 1 }">
          <div class="resource-row-top">
            <img class="resource-icon resource-icon--productivity" :src="IMG_OTHER_PRODUCTIVITY" :alt="t('resource.productivity')">
            <span class="resource-value" :class="{ 'resource-value--zero': ui.productivity < 1 }">{{ Math.floor(ui.productivity * 100) }}%</span>
          </div>
          <div class="resource-row-bottom">
            <div class="resource-bar">
              <div
                class="resource-bar-fill"
                :class="ui.productivity < 1 ? 'resource-bar-fill--negative' : 'resource-bar-fill--positive'"
                :style="{ width: (ui.productivity * 100) + '%' }"
              />
            </div>
          </div>
          <div class="resource-tooltip">
            <span>{{ t('resource.productivity') }}</span>
            <span class="resource-tooltip-time">{{ Math.floor(ui.productivity * 100) }}%</span>
          </div>
        </div>

        <template v-for="resource in HEADER_RESOURCES" :key="resource">
          <div v-if="visibleResources.has(resource)" class="resource-box" :class="{ 'resource-box--penalized': isResourcePenalized(resource) }">
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
              <span class="resource-tooltip-time">{{ t('resource.amount') }}: {{ formatNumberFull(ui.resources[resource]) }}</span>
              <span v-if="isBounded(resource)" class="resource-tooltip-time">{{ t('resource.maxCapacity') }}: {{ formatNumber(ui.storageCap) }}</span>
              <span v-if="timeEstimate(resource)" class="resource-tooltip-time">{{ timeEstimate(resource) }}</span>
              <span v-if="hasConsumption(resource)" class="resource-tooltip-time">{{ t('resource.producing') }}: {{ +grossProduction(resource).toFixed(2) }}</span>
              <span v-if="hasConsumption(resource)" class="resource-tooltip-time">{{ t('resource.consuming') }}: {{ +resourceConsumption(resource).toFixed(2) }}</span>
            </div>
          </div>
        </template>
      </div>

      <!-- Speed control -->
      <div class="header-speed" :class="{ 'header-speed--fast': ui.gameSpeed > 1 }">
        <button class="speed-btn tooltip tooltip--delayed" :data-tooltip="t('screen.game.header.speedDown')" :disabled="ui.gameSpeed <= GAME_SPEED_OPTIONS[0]" @click="playTap(); speedDown()">&laquo;</button>
        <span class="speed-label tooltip tooltip--delayed" :data-tooltip="t('screen.game.header.gameSpeed')">{{ t('screen.game.header.speed', ui.gameSpeed) }}</span>
        <button class="speed-btn tooltip tooltip--delayed" :data-tooltip="t('screen.game.header.speedUp')" :disabled="ui.gameSpeed >= GAME_SPEED_OPTIONS[GAME_SPEED_OPTIONS.length - 1]" @click="playTap(); speedUp()">&raquo;</button>
      </div>

      <!-- Colony info -->
      <div class="header-section header-colony">
        <div class="resource-box colony-box colony-box--population tooltip" :data-tooltip="t('resource.population')">
          <div class="header-resource">
            <img class="resource-icon resource-icon--worker" :src="IMG_UNIT_WORKER" :alt="t('resource.population')">
            <span class="resource-value" :class="{ 'resource-value--alert': ui.resources.workers >= ui.workersCap, 'resource-value--zero': ui.resources.workers === 0 }">{{ formatNumber(ui.resources.workers) }}/{{ formatNumber(ui.workersCap) }}</span>
          </div>
        </div>
        <div class="resource-box colony-box colony-box--idle">
          <div class="header-resource">
            <div class="tooltip" :data-tooltip="t('resource.idleWorkers')">
              <span class="header-resource-inner">
                <img class="resource-icon" :src="IMG_OTHER_IDLE" :alt="t('resource.idleWorkers')">
                <span class="resource-value resource-value--idle" :class="{ 'resource-value--alert': ui.idleWorkers > 0 }">{{ ui.idleWorkers }}</span>
              </span>
            </div>
            <span class="tooltip tooltip--delayed" :data-tooltip="dismissTooltip">
              <button class="worker-btn worker-btn--minus dismiss-btn" :disabled="!canDismiss" @click="dismissWorker">&minus;</button>
            </span>
          </div>
        </div>
        <div class="resource-box colony-box colony-box--territory tooltip" :data-tooltip="t('resource.territory')">
          <div class="header-resource">
            <img class="resource-icon resource-icon--territory" :src="IMG_OTHER_TERRITORY" :alt="t('resource.territory')">
            <span class="resource-value" :class="{ 'resource-value--alert': ui.resources.territory >= ui.territoryCap }">{{ formatNumber(ui.resources.territory) }}/{{ formatNumber(ui.territoryCap) }}</span>
          </div>
        </div>
      </div>

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
            <div
              v-for="event in ui.futureEvents"
              :key="event.id"
              class="event-row"
              :class="{ 'event-row--clickable': event.action, 'event-row--met': event.requirementsMet }"
              @click="event.action && handleEventAction(event.action)"
            >
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
      :has-saved-game="hasSavedGame"
      @close="showModal = false"
      @save="saveGame"
      @load="loadGame"
      @settings="openSettings"
      @restart="handleRestartRequest"
      @quit="handleQuitRequest"
    />

    <SettingsModal
      v-if="showSettingsModal"
      @close="closeSettings"
    />

    <ConfirmModal
      v-if="showConfirmQuit"
      title-key="modal.confirmQuit.title"
      description-key="modal.confirmQuit.message"
      confirm-key="modal.confirmQuit.quit"
      @close="cancelQuit"
      @confirm="confirmQuit"
    />

    <ConfirmModal
      v-if="showConfirmRestart"
      title-key="modal.confirmRestart.title"
      description-key="modal.confirmRestart.message"
      confirm-key="modal.confirmRestart.restart"
      @confirm="confirmRestart"
      @close="cancelRestart"
    />

    <ConfirmModal
      v-if="showClearConfirm"
      title-key="modal.confirmClearEvents.title"
      description-key="modal.confirmClearEvents.message"
      confirm-key="modal.confirmClearEvents.clear"
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

    <ChallengeDetailModal
      v-if="showChallengeModal"
      @close="showChallengeModal = false"
    />

    <ChallengeSuccessModal
      v-if="ui.challengeModal === CHALLENGE_MODAL_REWARD"
    />

    <ChallengeFailureModal
      v-if="ui.challengeModal === CHALLENGE_MODAL_FAILURE"
    />

    <ChallengeWinModal
      v-if="ui.challengeModal === CHALLENGE_MODAL_WIN"
      @continue="handleWinContinue"
      @quit="handleWinQuit"
    />

    <Transition name="tutorial-banner" mode="out-in">
      <TutorialBanner
        v-if="ui.tutorial.isActive"
        :key="ui.tutorial.stepNumber"
        :text-key="ui.tutorial.stepTextKey"
        :hint-key="ui.tutorial.stepHintKey"
        :building-img="ui.tutorial.stepBuildingImg"
        :step-number="ui.tutorial.stepNumber"
        :total-steps="ui.tutorial.totalSteps"
      />
    </Transition>

    <TutorialModal
      v-if="ui.tutorial.activeModal"
      :title-key="ui.tutorial.activeModalTitle"
      :body-key="ui.tutorial.activeModalBody"
      @close="dismissTutorialModal"
    />

    <Transition name="save-indicator">
      <div v-if="showSaveIndicator" class="save-indicator">{{ t('notifications.gameSaved') }}</div>
    </Transition>
  </div>
</template>

<style scoped>
.perf-overlay {
  position: fixed;
  bottom: 0.8rem;
  left: 1.4rem;
  background: rgba(255, 255, 255, 0.05);
  color: rgba(0, 255, 0, 1);
  font-family: monospace;
  font-size: 0.75rem;
  padding: 0.5rem 0.7rem;
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
  padding: 0.45rem clamp(0.4rem, 0.8vw, 1rem);
  gap: clamp(0.25rem, 0.4vw, 0.5rem);
  border-bottom: 1px solid var(--color-border);
  background: var(--color-bg-surface);
  box-shadow: 0 2px 8px rgba(var(--color-shadow-rgb), 0.3);
}

/* ---- Sections ---- */

.header-section {
  display: flex;
  align-items: center;
  gap: clamp(0.4rem, 0.7vw, 1rem);
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
  gap: 0.5rem;
  flex-shrink: 0;
}

/* "YEAR" label text in subdued uppercase */
.header-year {
  display: flex;
  align-items: baseline;
  margin-top: 0.3em;
  gap: 0.3rem;
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
  gap: clamp(0.2rem, 0.4vw, 0.5rem);
  min-width: 0;
}

/* Responsive overrides for header resource boxes */
.header-resources .resource-box {
  padding: 0.3rem clamp(0.2rem, 0.4vw, 0.5rem);
  flex-shrink: 1;
  min-width: 0;
}

.header-resources .resource-icon {
  width: clamp(0.9rem, 1vw, 1.25rem);
  height: clamp(0.9rem, 1vw, 1.25rem);
}

.header-resources .resource-value {
  font-size: clamp(0.65rem, 0.7vw, 0.8rem);
  min-width: 5ch;
}

/* ---- Speed control ---- */

/* Compact speed control group: « 1x » */
.header-speed {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  flex-shrink: 0;
  padding: 0.35rem clamp(0.2rem, 0.35vw, 0.4rem);
  border-radius: 0.25rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.12);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.05),
    rgba(var(--color-shadow-rgb), 0.12)
  );
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

/* Subtle gold glow when game is accelerated */
.header-speed--fast {
  border-color: rgba(var(--color-accent-rgb), 0.35);
  box-shadow: 0 0 6px rgba(var(--color-accent-rgb), 0.1);
}

/* Speed value label (e.g. "2x") */
.speed-label {
  font-family: var(--font-numeric);
  font-size: clamp(0.65rem, 0.7vw, 0.8rem);
  min-width: 2.2ch;
  margin-left: clamp(0.1rem, 0.25vw, 0.3rem);
  margin-right: clamp(0.1rem, 0.25vw, 0.3rem);
  text-align: center;
  color: var(--color-text);
  user-select: none;
}

/* Accelerated speed label gets gold tint */
.header-speed--fast .speed-label {
  color: rgba(var(--color-accent-rgb), 1);
}

/* « and » navigation buttons */
.speed-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: clamp(1.4rem, 1.5vw, 1.8rem);
  height: clamp(1.4rem, 1.5vw, 1.8rem);
  padding: 0;
  border-radius: 0.2rem;
  font-size: clamp(0.85rem, 0.9vw, 1.05rem);
  line-height: 1;
  color: rgba(var(--color-accent-rgb), 0.7);
  background: transparent;
  border: 1px solid rgba(var(--color-accent-rgb), 0.15);
  cursor: pointer;
  transition: background 0.15s ease, border-color 0.15s ease, color 0.15s ease;
}

.speed-btn:hover:not(:disabled) {
  background: rgba(var(--color-accent-rgb), 0.12);
  border-color: rgba(var(--color-accent-rgb), 0.5);
  color: rgba(var(--color-accent-rgb), 1);
}

.speed-btn:disabled {
  color: rgba(var(--color-accent-rgb), 0.15);
  border-color: rgba(var(--color-accent-rgb), 0.05);
  cursor: not-allowed;
}

/* Colony stats (population, idle workers, territory) */
.header-colony {
  align-items: stretch;
  gap: clamp(0.25rem, 0.4vw, 0.5rem);
  /* Resist shrinking but allow it under viewport pressure (30% of normal rate) */
  flex-shrink: 0.3;
  white-space: nowrap;
}

/* ---- Resource stat (icon beside value) ---- */

.header-resource {
  display: flex;
  align-items: center;
  gap: 0.35rem;
}

/* Inner wrapper to scope the idle-workers tooltip away from the dismiss button */
.header-resource-inner {
  display: flex;
  align-items: center;
  gap: 0.35rem;
}

/* Override cqh sizing for dismiss button in header context */
.dismiss-btn {
  width: clamp(1.4rem, 1.5vw, 1.8rem);
  height: clamp(1.4rem, 1.5vw, 1.8rem);
  padding: 0 0 0.15rem;
  font-size: clamp(0.85rem, 0.9vw, 1.1rem);
  margin-left: clamp(0.2rem, 0.4vw, 0.5rem);
}

/* Wider gap between icon and value for worker population display */
.colony-box--population .header-resource {
  gap: 0.6rem;
}

/* Larger icon size for worker population display */
.resource-icon--worker {
  width: clamp(1.1rem, 1.2vw, 1.4rem);
  height: clamp(1.1rem, 1.2vw, 1.4rem);
}

/* Slightly larger icon size for territory display */
.resource-icon--territory {
  width: clamp(1.2rem, 1.3vw, 1.55rem);
  height: clamp(1.2rem, 1.3vw, 1.55rem);
}

/* Slightly larger icon size for productivity display */
.resource-icon--productivity {
  width: clamp(0.9rem, 1vw, 1.2rem);
  height: clamp(0.9rem, 1vw, 1.2rem);
}

/* ---- Season indicator ---- */

.season-icon {
  width: 0.9rem;
  height: 0.9rem;
  align-self: center;
}

/* Thin horizontal bar background for season progress */
.season-track {
  width: clamp(3.5rem, 4vw, 5.5rem);
  height: 4px;
  margin-top: 0.25rem;
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

/* ---- Menu button ---- */

.header-menu-button {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.4rem;
  margin-left: clamp(0.2rem, 0.5vw, 0.7rem);
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
  padding: 1rem 1.5rem 0.75rem;
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

/* Clickable future events (e.g. challenges) */
.event-row--clickable {
  cursor: pointer;
}

/* Challenge event with all requirements met */
.event-row--met .event-text {
  color: rgba(80, 168, 80, 0.9);
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

/* ---- Save indicator ---- */

.save-indicator {
  position: fixed;
  bottom: 1.5rem;
  right: 1.5rem;
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.14em;
  color: rgba(var(--color-accent-rgb), 0.95);
  background:
    linear-gradient(
      135deg,
      rgba(var(--color-accent-rgb), 0.12) 0%,
      rgba(var(--color-accent-rgb), 0.04) 100%
    );
  border: 1px solid rgba(var(--color-accent-rgb), 0.15);
  padding: 0.4rem 1.1rem;
  border-radius: 0.2rem;
  pointer-events: none;
  z-index: 9000;
  box-shadow: 0 2px 12px rgba(var(--color-accent-rgb), 0.1);
  text-shadow: 0 0 8px rgba(var(--color-accent-rgb), 0.3);
}

.tutorial-banner-enter-active {
  transition: opacity 0.3s ease-out, transform 0.3s ease-out;
}

.tutorial-banner-leave-active {
  transition: opacity 0.2s ease-in, transform 0.2s ease-in;
}

.tutorial-banner-enter-from {
  opacity: 0;
  transform: translateY(2rem);
}

.tutorial-banner-leave-to {
  opacity: 0;
  transform: translateY(1rem);
}

.save-indicator-enter-active {
  transition: opacity 0.2s ease-out, transform 0.2s ease-out;
}

.save-indicator-leave-active {
  transition: opacity 0.8s ease-in, transform 0.8s ease-in;
}

.save-indicator-enter-from {
  opacity: 0;
  transform: translateY(0.5rem);
}

.save-indicator-leave-to {
  opacity: 0;
  transform: translateY(-0.25rem);
}

</style>
