<script setup>
import {ref, inject, computed, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {formatTime} from '@/js/engine/format.js'
import {RESEARCH_TREE} from '@/js/engine/constants.js'
import {RESEARCH_DEFINITIONS} from '@/js/engine/balancing.js'
import {IMG_OTHER_COMPLETED, IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {t} from '@/js/i18n/localized.js'
import ModalHelpModal from '@/components/modals/help_modal.vue'

const emit = defineEmits(['close'])
const colony = inject('colony')
const gameState = inject('gameState')
const visible = ref(false)
const showHelp = ref(false)
let rafId = null

const activeTab = ref(RESEARCH_TREE[0].category)

const activeCategory = computed(() =>
  RESEARCH_TREE.find(c => c.category === activeTab.value),
)

function nodeStatus(key, researches, index) {
  if (colony.researches.isCompleted(key)) return 'completed'
  if (colony.researches.isActive(key)) return 'active'
  if (index > 0 && !colony.researches.isCompleted(researches[index - 1])) return 'locked'
  return 'available'
}

function canAfford(key) {
  return colony.resources.canAfford(RESEARCH_DEFINITIONS[key].cost)
}

function handleNodeClick(key, status) {
  if (status !== 'available' || !canAfford(key)) return
  playTap()
  gameState.startResearch(key)
}

function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
    if (showHelp.value) {
      showHelp.value = false
    } else {
      emit('close')
    }
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown, true)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown, true)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit('close')"
  >
    <div class="research-modal">
      <button class="modal-help-btn" @click="playTap(); showHelp = true">?</button>
      <button class="modal-close-x" @click="playTap(); emit('close')">&#10005;</button>
      <h2 class="modal-title">{{ t('research.title') }}</h2>

      <!-- Tab bar -->
      <div class="research-tabs">
        <button
          v-for="cat in RESEARCH_TREE"
          :key="cat.category"
          class="research-tab"
          :class="{ 'research-tab--active': activeTab === cat.category }"
          @click="playTap(); activeTab = cat.category"
        >
          {{ t('research.category.' + cat.category) }}
        </button>
      </div>

      <!-- Scrollable content -->
      <div class="research-scroll">
        <div
          v-for="sub in activeCategory.subcategories"
          :key="sub.key"
          class="research-subcategory"
        >
          <h3 class="subcategory-label">
            {{ t('research.subcategory.' + sub.key) }}
            <span class="subcategory-effect">&mdash; {{ t('research.effect.' + sub.key, sub.bonus.flat ? sub.bonus.value : sub.bonus.value * 100) }}</span>
          </h3>
          <div class="research-chain">
            <template v-for="(rKey, idx) in sub.researches" :key="rKey">
              <span v-if="idx > 0" class="chain-connector" />
              <div
                class="research-node"
                :class="[
                  'research-node--' + nodeStatus(rKey, sub.researches, idx),
                ]"
                @click="handleNodeClick(rKey, nodeStatus(rKey, sub.researches, idx))"
              >
                <div class="node-header">
                  <span class="node-name">{{ t('research.' + rKey) }}</span>
                </div>
                <div class="node-second-row">
                  <img v-if="nodeStatus(rKey, sub.researches, idx) === 'completed'" class="node-check" :src="IMG_OTHER_COMPLETED" alt="">
                  <span v-else-if="nodeStatus(rKey, sub.researches, idx) === 'active'" class="node-timer">
                    {{ formatTime(colony.researches.getActive(rKey).remainingSeconds) }}
                  </span>
                  <template v-else>
                    <div
                      v-for="[resource, amount] in RESEARCH_DEFINITIONS[rKey].cost.entries()"
                      :key="resource"
                      class="node-cost-item"
                    >
                      <img class="node-cost-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
                      <span class="node-cost-amount" :class="{ 'node-cost-amount--insufficient': amount > colony.resources[resource] }">{{ amount }}</span>
                    </div>
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
/* ── Overlay ─────────────────────────────────────────────── */

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 5.5vh;
  z-index: 100;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.modal-overlay.visible {
  opacity: 1;
}

/* ── Modal container ─────────────────────────────────────── */

.research-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
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

/* ── Title & rule ────────────────────────────────────────── */

.modal-title {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 1rem;
  color: var(--color-text);
  letter-spacing: 0.18em;
  text-transform: uppercase;
  align-self: center;
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
  border-bottom: 2px solid transparent;
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
  padding-right: 0.5rem;
  scrollbar-width: thin;
  scrollbar-color: rgba(var(--color-accent-rgb), 0.2) transparent;
}

.research-scroll::-webkit-scrollbar {
  width: 4px;
}

.research-scroll::-webkit-scrollbar-track {
  background: transparent;
}

.research-scroll::-webkit-scrollbar-thumb {
  background: rgba(var(--color-accent-rgb), 0.2);
  border-radius: 2px;
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

.chain-connector::before {
  content: '';
  flex: 1;
  height: 1px;
  background: rgba(var(--color-accent-rgb), 0.2);
}

.chain-connector::after {
  content: '';
  width: 0;
  height: 0;
  border-top: 3px solid transparent;
  border-bottom: 3px solid transparent;
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
  border-radius: 4px;
  transition: all 0.2s ease;
}

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
}

@keyframes research-pulse {
  0%, 100% { box-shadow: 0 0 4px rgba(var(--color-accent-rgb), 0.08); }
  50% { box-shadow: 0 0 14px rgba(var(--color-accent-rgb), 0.2); }
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

.research-node--locked {
  opacity: 0.35;
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

.node-cost-item {
  display: flex;
  align-items: center;
  gap: 0.12rem;
}

.node-cost-icon {
  width: 0.9rem;
  height: 0.9rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.3));
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
