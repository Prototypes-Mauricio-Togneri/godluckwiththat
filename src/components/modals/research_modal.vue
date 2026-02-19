<script setup>
import {ref, inject, computed, onMounted, onUnmounted} from 'vue'
import {RESEARCH_TREE} from '@/js/engine/constants.js'
import {RESEARCH_DEFINITIONS} from '@/js/engine/balancing.js'
import {IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits(['close'])
const colony = inject('colony')
const visible = ref(false)
let rafId = null

const activeTab = ref(RESEARCH_TREE[0].category)

const activeCategory = computed(() =>
  RESEARCH_TREE.find(c => c.category === activeTab.value),
)

function nodeStatus(key, researches, index) {
  if (colony.researches.isCompleted(key)) return 'completed'
  if (colony.researches.isActive(key)) return 'active'
  if (index > 0 && !colony.researches.isCompleted(researches[index - 1])) return 'locked'
  if (colony.buildings.academy.level < RESEARCH_DEFINITIONS[key].academyLevel) return 'locked'
  return 'available'
}

function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
    emit('close')
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
      <button class="modal-close-x" @click="emit('close')">&#10005;</button>
      <h2 class="modal-title">{{ t('research.title') }}</h2>

      <!-- Tab bar -->
      <div class="research-tabs">
        <button
          v-for="cat in RESEARCH_TREE"
          :key="cat.category"
          class="research-tab"
          :class="{ 'research-tab--active': activeTab === cat.category }"
          @click="activeTab = cat.category"
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
          <h3 class="subcategory-label">{{ t('research.subcategory.' + sub.key) }}</h3>
          <div class="research-chain">
            <template v-for="(rKey, idx) in sub.researches" :key="rKey">
              <span v-if="idx > 0" class="chain-connector" />
              <div
                class="research-node"
                :class="'research-node--' + nodeStatus(rKey, sub.researches, idx)"
              >
                <div class="node-header">
                  <span class="node-name">{{ t('research.' + rKey) }}</span>
                  <span v-if="nodeStatus(rKey, sub.researches, idx) === 'completed'" class="node-check">&#10003;</span>
                </div>
                <div class="node-cost">
                  <div
                    v-for="[resource, amount] in RESEARCH_DEFINITIONS[rKey].cost.entries()"
                    :key="resource"
                    class="node-cost-item"
                  >
                    <img class="node-cost-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
                    <span class="node-cost-amount">{{ amount }}</span>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
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
  align-items: center;
  justify-content: center;
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
  max-height: 85vh;
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
  max-width: 160px;
  background: rgba(var(--color-accent-rgb), 0.03);
  border: 1px solid rgba(var(--color-accent-rgb), 0.12);
  border-radius: 4px;
  transition: all 0.2s ease;
}

.research-node:hover {
  border-color: rgba(var(--color-accent-rgb), 0.3);
}

/* ── Node states ─────────────────────────────────────────── */

.research-node--completed {
  border-color: rgba(var(--color-accent-rgb), 0.35);
  background: rgba(var(--color-accent-rgb), 0.07);
  box-shadow: 0 0 8px rgba(var(--color-accent-rgb), 0.08);
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
}

.research-node--locked {
  opacity: 0.35;
  pointer-events: auto;
}

.research-node--locked:hover {
  opacity: 0.55;
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
  font-size: 0.8rem;
  font-weight: 500;
  color: var(--color-text);
  line-height: 1.2;
}

.node-check {
  font-size: 0.7rem;
  color: var(--color-accent);
  flex-shrink: 0;
}

.node-cost {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  flex-wrap: wrap;
  margin-top: 0.15rem;
}

.node-cost-item {
  display: flex;
  align-items: center;
  gap: 0.1rem;
}

.node-cost-icon {
  width: 0.75rem;
  height: 0.75rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.3));
}

.node-cost-amount {
  font-family: var(--font-numeric);
  font-size: 0.62rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.65);
}

/* ── Close button ────────────────────────────────────────── */

.modal-close-x {
  position: absolute;
  top: 0.75rem;
  right: 0.75rem;
  background: rgba(180, 60, 60, 0.12);
  border: 1px solid transparent;
  border-radius: 3px;
  color: rgba(var(--color-text-rgb), 0.45);
  font-size: 0.85rem;
  line-height: 1;
  width: 1.5rem;
  height: 1.5rem;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.modal-close-x:hover {
  color: #c45050;
  border-color: rgba(180, 60, 60, 0.4);
}
</style>
