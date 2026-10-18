<script setup>
import {ref, inject, computed, onMounted, onBeforeUnmount, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {formatNumber, formatNumberFull, formatTime} from '@/js/engine/format.js'
import {RESEARCH_COSTS, RESEARCH_MODAL_TREE} from '@/js/engine/constants.js'
import {IMG_OTHER_COMPLETED, IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {canAffordCost} from '@/js/engine/utils.js'
import {EMIT_CLOSE, RESEARCH_STATUS_ACTIVE, RESEARCH_STATUS_AVAILABLE, RESEARCH_STATUS_COMPLETED, RESEARCH_STATUS_LOCKED} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {pushFocusLayer, removeFocusLayer} from '@/js/engine/focus_stack.js'
import {t} from '@/js/i18n/localized.js'
import ModalHelpModal from '@/components/modals/help_modal.vue'

const RESEARCH_COST_ENTRIES = Object.fromEntries(
  Object.entries(RESEARCH_COSTS).map(([
    k,
    c,
  ]) => [
    k,
    [...c.entries],
  ]),
)

const emit = defineEmits([EMIT_CLOSE])
const ui = inject('ui')
const actions = inject('actions')
const visible = ref(false)
const overlay = ref(null) // Root element; everything else is inert while this modal is topmost
const showHelp = ref(false)
let rafId = null

const activeTab = ref(RESEARCH_MODAL_TREE[0].category)
const scrollRef = ref(null)
const tooltipAbove = ref({})

const activeCategory = computed(() =>
  RESEARCH_MODAL_TREE.find(entry => entry.category === activeTab.value),
)

const nodeStatusMap = computed(() => {
  const map = {}
  for (const sub of activeCategory.value.subcategories) {
    for (let idx = 0; idx < sub.researches.length; idx++) {
      const key = sub.researches[idx]
      if (ui.academy.completed.has(key)) {
        map[key] = RESEARCH_STATUS_COMPLETED
      } else if (ui.academy.activeKeys.has(key)) {
        map[key] = RESEARCH_STATUS_ACTIVE
      } else if (idx > 0 && !ui.academy.completed.has(sub.researches[idx - 1])) {
        map[key] = RESEARCH_STATUS_LOCKED
      } else {
        map[key] = RESEARCH_STATUS_AVAILABLE
      }
    }
  }
  return map
})

/** Whether the colony can afford the research cost.
 * @param {string} key - Research key
 * @returns {boolean} True if resources are sufficient
 */
function canAfford(key) {
  return canAffordCost(ui.resources, RESEARCH_COSTS[key])
}

/** Starts research when node is available and affordable.
 * @param {string} key - Research key
 * @param {string} status - Current node status (available, locked, active, completed)
 */
function handleNodeClick(key, status) {
  if (status !== RESEARCH_STATUS_AVAILABLE || !canAfford(key)) {
    return
  }
  playTap()
  actions.startResearch(key)
}

/** Count of completed researches in a subcategory.
 * @param {object} sub - Subcategory object containing a researches array
 * @returns {number} Number of completed researches
 */
function completedCount(sub) {
  return sub.researches.filter(key => ui.academy.completed.has(key)).length
}

/** Formatted bonus text for completed tiers in a subcategory.
 * @param {object} sub - Subcategory object with bonus config and researches
 * @returns {string} Formatted string like "+3" (flat) or "+15%" (percent), empty if none completed
 */
function accumulatedBonusText(sub) {
  const count = completedCount(sub)
  if (count === 0) {
    return ''
  }
  const accumulated = count * sub.bonus.value
  return sub.bonus.flat ? `+${accumulated}` : `+${Math.round(accumulated * 100)}%`
}

/** Determines tooltip direction based on node position within scroll container. */
function updateTooltipDirection(rKey, event) {
  const node = event.currentTarget
  const scroll = scrollRef.value
  if (!scroll) {
    return
  }
  const nodeRect = node.getBoundingClientRect()
  const scrollRect = scroll.getBoundingClientRect()
  const spaceBelow = scrollRect.bottom - nodeRect.bottom
  tooltipAbove.value[rKey] = spaceBelow < 80
}

/** Closes modal on Escape while it is the topmost modal (the help overlay, when open, sits above it). */
function handleEscape() {
  emit(EMIT_CLOSE)
}

onMounted(() => {
  pushFocusLayer(overlay.value)
  pushEscapeHandler(handleEscape)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onBeforeUnmount(() => {
  removeFocusLayer(overlay.value)
})

onUnmounted(() => {
  removeEscapeHandler(handleEscape)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div
    ref="overlay"
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="research-modal">
      <button class="modal-help-btn" @click="playTap(); showHelp = true">?</button>
      <button class="modal-close-x" @click="playTap(); emit(EMIT_CLOSE)">&#10005;</button>
      <h2 class="modal-title">{{ t('research.title') }}</h2>

      <!-- Tab bar -->
      <div class="research-tabs">
        <button
          v-for="cat in RESEARCH_MODAL_TREE"
          :key="cat.category"
          class="research-tab"
          :class="{ 'research-tab--active': activeTab === cat.category }"
          @click="playTap(); activeTab = cat.category"
        >
          {{ t('research.category.' + cat.category) }}
        </button>
      </div>

      <!-- Scrollable content -->
      <div ref="scrollRef" class="research-scroll thin-scrollbar">
        <div
          v-for="sub in activeCategory.subcategories"
          :key="sub.key"
          class="research-subcategory"
        >
          <h3 class="subcategory-label">
            {{ t('research.subcategory.' + sub.key) }}
            <span class="subcategory-effect">&mdash; {{ t('research.effect.' + sub.key, sub.bonus.flat ? sub.bonus.value : sub.bonus.value * 100) }}</span>
            <span v-if="completedCount(sub) > 0" class="subcategory-bonus-pill">{{ t('research.accumulated', accumulatedBonusText(sub)) }}</span>
          </h3>
          <div class="research-chain">
            <template v-for="(rKey, idx) in sub.researches" :key="rKey">
              <span v-if="idx > 0" class="chain-connector" />
              <div
                class="research-node"
                :class="[
                  'research-node--' + nodeStatusMap[rKey],
                ]"
                @click="handleNodeClick(rKey, nodeStatusMap[rKey])"
                @mouseenter="updateTooltipDirection(rKey, $event)"
              >
                <div class="node-header">
                  <span class="node-name">{{ t('research.' + rKey) }}</span>
                </div>
                <div class="node-second-row">
                  <img v-if="nodeStatusMap[rKey] === RESEARCH_STATUS_COMPLETED" class="node-check" :src="IMG_OTHER_COMPLETED" alt="">
                  <span v-else-if="nodeStatusMap[rKey] === RESEARCH_STATUS_ACTIVE" class="node-timer">
                    {{ formatTime(ui.academy.activeTimers[rKey]?.remainingSeconds ?? 0) }}
                  </span>
                  <template v-else>
                    <div
                      v-for="[resource, amount] in RESEARCH_COST_ENTRIES[rKey]"
                      :key="resource"
                      class="node-cost-item"
                    >
                      <img class="node-cost-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
                      <span class="node-cost-amount" :class="{ 'node-cost-amount--insufficient': amount > ui.resources[resource] }">{{ formatNumber(amount) }}</span>
                    </div>
                  </template>
                </div>
                <div v-if="nodeStatusMap[rKey] !== RESEARCH_STATUS_COMPLETED && nodeStatusMap[rKey] !== RESEARCH_STATUS_ACTIVE" class="action-cost-tooltip" :class="{ 'action-cost-tooltip--above': tooltipAbove[rKey] }">
                  <template v-for="[resource, amount] in RESEARCH_COST_ENTRIES[rKey]" :key="resource">
                    <span>{{ t(`resource.${resource}`) }}:</span>
                    <span class="action-cost-tooltip-amount">{{ formatNumberFull(amount) }}</span>
                  </template>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>

    <ModalHelpModal
      v-if="showHelp"
      :title="t('modal.researchHelp.title')"
      :body="t('modal.researchHelp.body')"
      @close="showHelp = false"
    />
  </div>
</template>

<style scoped>
/* ── Overlay override (top-aligned) ──────────────────────── */

.modal-overlay {
  align-items: flex-start;
  padding-top: 5.5vh;
}

/* ── Modal container ─────────────────────────────────────── */

.research-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(var(--color-shadow-rgb), 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 1rem 2rem 1.5rem;
  width: 90vw;
  max-width: 960px;
  max-height: 89vh;
  display: flex;
  flex-direction: column;
  transform: translateY(8px);
  transition: transform 0.25s ease;
}

.modal-overlay.visible .research-modal {
  transform: translateY(0);
}

/* ── Title override ──────────────────────────────────────── */

.modal-title {
  font-size: 1rem;
  margin-bottom: 1.25rem;
}

/* ── Tab bar ─────────────────────────────────────────────── */

.research-tabs {
  display: flex;
  gap: 0.25rem;
  margin-bottom: 1.25rem;
  border-bottom: 1px solid rgba(var(--color-accent-rgb), 0.12);
}

.research-tab {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 400;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: rgba(var(--color-text-rgb), 0.45);
  background: none;
  border: none;
  border-bottom: 2px solid rgba(0, 0, 0, 0);
  padding: 0.5rem 1rem;
  margin-bottom: -1px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.research-tab:hover {
  color: rgba(var(--color-text-rgb), 0.75);
}

.research-tab--active {
  color: var(--color-accent);
  border-bottom-color: var(--color-accent);
}

/* ── Scrollable content ──────────────────────────────────── */

.research-scroll {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  min-height: 0;
  padding-top: 0.15rem;
}

/* ── Subcategory section ─────────────────────────────────── */

.research-subcategory {
  margin-bottom: 1.25rem;
}

.subcategory-label {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.55);
  margin-bottom: 0.5rem;
}

.subcategory-bonus-pill {
  display: inline-block;
  font-family: var(--font-numeric);
  font-size: 0.65rem;
  font-weight: 500;
  letter-spacing: 0.03em;
  color: rgba(80, 160, 80, 1);
  background: rgba(80, 160, 80, 0.1);
  border: 1px solid rgba(80, 160, 80, 0.25);
  border-radius: 0.1875rem;
  padding: 0.05rem 0.35rem 0.1rem;
  margin-left: 0.55rem;
  vertical-align: middle;
  position: relative;
  top: -0.15rem;
  line-height: 1.4;
}

.subcategory-effect {
  font-family: var(--font-body);
  font-size: 0.75rem;
  font-weight: 400;
  letter-spacing: 0.02em;
  text-transform: none;
  color: rgba(var(--color-text-rgb), 0.55);
}

/* ── Research chain (horizontal) ─────────────────────────── */

.research-chain {
  display: flex;
  align-items: center;
}

/* ── Connector arrow ─────────────────────────────────────── */

.chain-connector {
  display: flex;
  align-items: center;
  width: 1.5rem;
  flex-shrink: 0;
}

/* Horizontal connecting line between research nodes */
.chain-connector::before {
  content: '';
  flex: 1;
  height: 1px;
  background: rgba(var(--color-accent-rgb), 0.2);
}

/* Arrow tip pointing to next research node */
.chain-connector::after {
  content: '';
  width: 0;
  height: 0;
  border-top: 3px solid rgba(0, 0, 0, 0);
  border-bottom: 3px solid rgba(0, 0, 0, 0);
  border-left: 5px solid rgba(var(--color-accent-rgb), 0.2);
}

/* ── Research node ───────────────────────────────────────── */

.research-node {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  padding: 0.55rem 0.7rem;
  min-width: 130px;
  background: rgba(var(--color-accent-rgb), 0.03);
  border: 1px solid rgba(var(--color-accent-rgb), 0.12);
  border-radius: 0.25rem;
  transition: all 0.2s ease;
}

/* Hover highlight for available or active (non-locked, non-completed) nodes */
.research-node:not(.research-node--locked):not(.research-node--completed):hover {
  border-color: rgba(var(--color-accent-rgb), 0.3);
}

/* ── Node states ─────────────────────────────────────────── */

.research-node--completed {
  border-color: rgba(80, 160, 80, 0.4);
  background: rgba(80, 160, 80, 0.05);
}

.research-node--active {
  border-color: rgba(var(--color-accent-rgb), 0.45);
  animation: research-pulse 2s ease-in-out infinite;
  will-change: outline;
}

/* Pulsing glow for active research nodes (outline is cheaper than box-shadow) */
@keyframes research-pulse {
  0%, 100% { outline: 2px solid rgba(var(--color-accent-rgb), 0.08); }
  50% { outline: 2px solid rgba(var(--color-accent-rgb), 0.25); }
}

.research-node--available {
  border-color: rgba(var(--color-accent-rgb), 0.25);
  background: rgba(var(--color-accent-rgb), 0.05);
  cursor: pointer;
}

.research-node--available:hover {
  border-color: rgba(var(--color-accent-rgb), 0.5);
  background: rgba(var(--color-accent-rgb), 0.1);
}

.research-node--locked > .node-header,
.research-node--locked > .node-second-row {
  opacity: 0.5;
}

/* ── Node content ────────────────────────────────────────── */

.node-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.3rem;
}

.node-name {
  font-family: var(--font-body);
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--color-text);
  line-height: 1.2;
}

.node-check {
  width: 0.9rem;
  height: 0.9rem;
  object-fit: contain;
  flex-shrink: 0;
}

.node-timer {
  font-family: var(--font-numeric);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-accent-rgb), 0.8);
  letter-spacing: 0.02em;
}

.node-second-row {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  flex-wrap: nowrap;
  margin-top: 0.15rem;
  min-height: 0.9rem;
}

/* Show cost tooltip on hover with delay */
.research-node:hover .action-cost-tooltip {
  display: grid;
  animation: cost-tooltip-fade 0.2s ease 1s both;
}

.node-cost-item {
  display: flex;
  align-items: center;
  gap: 0.12rem;
}

.node-cost-icon {
  width: 0.9rem;
  height: 0.9rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(var(--color-shadow-rgb), 0.3));
}

.node-cost-amount {
  font-family: var(--font-numeric);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.8);
  letter-spacing: 0.02em;
}

.node-cost-amount--insufficient {
  color: rgba(196, 80, 80, 0.7);
}

</style>
