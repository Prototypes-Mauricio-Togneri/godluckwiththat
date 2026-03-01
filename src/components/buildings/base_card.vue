<script setup>
import {computed, inject, ref} from 'vue'
import BuildingHelpModal from '@/components/modals/building_help_modal.vue'
import WorkerAssignmentRow from '@/components/buildings/worker_assignment_row.vue'
import {IMG_OTHER_BUILD, IMG_OTHER_UPGRADE, IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {playTap} from '@/js/engine/audio.js'
import {formatTime} from '@/js/engine/format.js'
import {BUILDING_CLASS_MAP} from '@/js/engine/constants.js'
import Producer from '@/js/models/buildings/producer.js'
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
  showBuildAction: {
    type: Boolean,
    default: true,
  },
  showLevel: {
    type: Boolean,
    default: true,
  },
})

const colony = inject('colony')
const gameState = inject('gameState')

const displayNameKey = computed(() => props.nameKey || `building.${props.buildingKey}`)
const showHelp = ref(false)

// Build / level-up action
const hasAction = computed(() => props.showBuildAction && props.buildingKey in BUILDING_CLASS_MAP)
const isBuildable = computed(() => hasAction.value && props.building.isUnbuilt)
const actionCost = computed(() =>
  hasAction.value ? props.building.levelUpCost : null,
)
const territoryFull = computed(() => colony.resources.territory >= colony.buildings.headquarters.territoryCap)
const isConstructing = computed(() => props.building.isConstructing)
const canActBase = computed(() =>
  actionCost.value !== null
  && !isConstructing.value,
)
const canAfford = computed(() =>
  actionCost.value !== null
  && colony.resources.canAfford(actionCost.value),
)
const canAct = computed(() => canActBase.value && !territoryFull.value && canAfford.value)

const actionTooltip = computed(() => {
  if (isConstructing.value) {
    return ''
  }
  if (canActBase.value && !canAfford.value) {
    return t('building.insufficientResources')
  }
  if (canActBase.value && territoryFull.value) {
    return t('building.maxTerritoryReached')
  }
  return isBuildable.value ? t('building.build') + ' ' + t(displayNameKey.value).toLowerCase() : t('building.levelUp')
})
const actionCostEntries = computed(() => actionCost.value?.entries() ?? new Map())
const isWorkerAssignable = computed(() => props.building instanceof Producer)

const constructionProgress = computed(() => {
  if (!isConstructing.value || props.building.constructionDuration === 0) {
    return 0
  }
  return 1 - props.building.constructionRemaining / props.building.constructionDuration
})

function act() {
  if (!canAct.value) {
    return
  }
  playTap()
  gameState.levelUpBuilding(props.buildingKey)
}
</script>

<template>
  <div class="building-card" :class="{ 'building-card--constructing': isConstructing }">
    <button
      class="help-btn tooltip tooltip--delayed"
      :data-tooltip="t('modal.buildingHelp.tooltip')"
      @click="playTap(); showHelp = true"
    >
      ?
    </button>

    <div class="building-thumb-wrapper">
      <img class="building-thumb" :class="{ 'building-thumb-unbuilt': building.isUnbuilt }" :src="img" :alt="t(displayNameKey)">
      <span v-if="showLevel" class="building-level-badge">{{ building.level }}</span>
    </div>
    <div class="building-info">
      <span class="building-name">{{ t(displayNameKey) }}</span>
      <div v-if="hasAction || !isBuildable" class="slot-actions">
        <div v-if="hasAction" class="action-row" :class="{ 'action-row--disabled': !canAct }">
          <span class="tooltip" :class="{ 'tooltip--delayed': canAct }" :data-tooltip="actionTooltip">
            <button
              class="btn-gold action-btn"
              :class="{ 'action-btn--constructing': isConstructing }"
              :style="isConstructing ? { '--progress': (constructionProgress * 100) + '%' } : undefined"
              :disabled="!canAct"
              @click="act"
            >
              <img v-if="!isConstructing" class="action-btn-icon" :src="isBuildable ? IMG_OTHER_BUILD : IMG_OTHER_UPGRADE" :alt="isBuildable ? t('building.build') : t('building.levelUp')">
              <span v-else class="action-btn-time">{{ formatTime(building.constructionRemaining) }}</span>
            </button>
          </span>
          <span v-if="!isConstructing" class="action-cost">
            <span v-for="[key, amount] in actionCostEntries" :key="key" class="action-cost-item">
              <img class="action-cost-icon" :src="IMG_RESOURCE_MAP[key]" :alt="t(`resource.${key}`)">
              <span class="action-cost-amount" :class="{ 'action-cost-short': colony.resources[key] < amount }">{{ amount }}</span>
            </span>
          </span>
          <slot v-if="!isWorkerAssignable && !isBuildable" />
        </div>
        <slot v-if="hasAction && !isWorkerAssignable && !isBuildable" name="below-action" />
        <div v-if="isWorkerAssignable && !isBuildable" class="worker-slot-row">
          <WorkerAssignmentRow :building-key="buildingKey" />
          <slot v-if="isWorkerAssignable" />
        </div>
        <slot v-if="!hasAction && !isBuildable" />
      </div>
    </div>

    <BuildingHelpModal
      v-if="showHelp"
      :name-key="displayNameKey"
      :building-key="buildingKey"
      :img="img"
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
  min-height: 0;
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border);
  border-radius: 0.25rem;
}

.building-card--constructing {
  border-color: rgba(var(--color-accent-rgb), 0.25);
}

/* Help icon — top-right corner */
.help-btn {
  position: absolute;
  top: 0.6rem;
  right: 0.6rem;
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
  width: var(--thumb-h);
  height: var(--thumb-h);
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(var(--color-shadow-rgb), 0.4));
  transition: filter 0.3s ease;
}

.building-thumb-unbuilt {
  filter: grayscale(1) drop-shadow(0 0 2px rgba(var(--color-shadow-rgb), 0.4));
}

/* Level number overlay at bottom-right of thumbnail */
.building-level-badge {
  position: absolute;
  bottom: 0;
  right: 0;
  font-family: var(--font-numeric);
  font-size: 0.8rem;
  font-weight: 500;
  line-height: 1;
  color: var(--color-text);
  background: rgba(var(--color-shadow-rgb), 0.6);
  padding: 0.3rem 0.4rem;
}

.building-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  min-width: 0;
  align-self: stretch;
}

.worker-slot-row {
  display: flex;
  align-items: center;
}

.building-name {
  font-family: var(--font-body);
  font-size: 1.1rem;
  font-weight: 400;
  color: var(--color-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
