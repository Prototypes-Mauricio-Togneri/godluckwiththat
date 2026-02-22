<script setup>
import {ref, inject, computed, onMounted, onUnmounted} from 'vue'
import {playTap} from '@/js/engine/audio.js'
import {formatNumber} from '@/js/engine/format.js'
import {TRADEABLE_RESOURCES} from '@/js/engine/constants.js'
import {MARKET_TRADE_AMOUNT} from '@/js/engine/balancing.js'
import {IMG_RESOURCE_MAP} from '@/js/engine/assets.js'
import {t} from '@/js/i18n/localized.js'

const emit = defineEmits(['close'])
const colony = inject('colony')
const gameState = inject('gameState')
const visible = ref(false)
let rafId = null

const fee = computed(() => gameState.effectiveTradeFee())
const feePercent = computed(() => Math.round(fee.value * 100))

function buyPrice(resource) {
  return Math.floor(colony.marketPrices[resource] * (1 + fee.value))
}

function sellPrice(resource) {
  return Math.floor(colony.marketPrices[resource] * (1 - fee.value))
}

function canBuy(resource) {
  return colony.resources.gold >= buyPrice(resource)
    && colony.resources[resource] + MARKET_TRADE_AMOUNT <= colony.stockpile[resource]
}

function canSell(resource) {
  return colony.resources[resource] >= MARKET_TRADE_AMOUNT
    && colony.resources.gold + sellPrice(resource) <= colony.stockpile.gold
}

function buy(resource) {
  playTap()
  if (!canBuy(resource)) return
  gameState.executeTrade(resource, 'buy')
}

function sell(resource) {
  playTap()
  if (!canSell(resource)) return
  gameState.executeTrade(resource, 'sell')
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
    <div class="market-modal">
      <button class="modal-close-x" @click="playTap(); emit('close')">&#10005;</button>
      <h2 class="modal-title">{{ t('market.title') }}</h2>

      <!-- Fee indicator -->
      <div class="market-fee">
        {{ t('market.fee') }}: {{ feePercent }}%
      </div>

      <!-- Column headers -->
      <div class="market-header">
        <span class="market-header-resource" />
        <div class="market-header-actions">
          <span class="market-header-label">{{ t('market.sell') }}</span>
          <span class="market-header-label">{{ t('market.buy') }}</span>
        </div>
      </div>

      <!-- Trade rows -->
      <div class="market-scroll">
        <div
          v-for="resource in TRADEABLE_RESOURCES"
          :key="resource"
          class="trade-row"
        >
          <!-- Resource identity -->
          <div class="trade-resource">
            <img class="trade-resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
            <span class="trade-resource-name">{{ t('resource.' + resource) }}</span>
          </div>

          <!-- Trade actions -->
          <div class="trade-actions">
            <!-- Sell -->
            <button
              class="btn-gold trade-btn"
              :disabled="!canSell(resource)"
              @click="sell(resource)"
            >
              <img class="trade-btn-icon" :src="IMG_RESOURCE_MAP.gold" alt="">
              <span
                class="trade-btn-value trade-btn-value--gain"
                :class="{ 'trade-btn-value--insufficient': colony.resources[resource] < MARKET_TRADE_AMOUNT }"
              >+{{ formatNumber(sellPrice(resource)) }}</span>
            </button>

            <!-- Buy -->
            <button
              class="btn-gold trade-btn"
              :disabled="!canBuy(resource)"
              @click="buy(resource)"
            >
              <img class="trade-btn-icon" :src="IMG_RESOURCE_MAP.gold" alt="">
              <span
                class="trade-btn-value trade-btn-value--cost"
                :class="{ 'trade-btn-value--insufficient': colony.resources.gold < buyPrice(resource) }"
              >-{{ formatNumber(buyPrice(resource)) }}</span>
            </button>
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

.market-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 1rem 2rem 1.5rem;
  width: 90vw;
  max-width: 540px;
  max-height: 89vh;
  display: flex;
  flex-direction: column;
  transform: translateY(8px);
  transition: transform 0.25s ease;
}

.modal-overlay.visible .market-modal {
  transform: translateY(0);
}

/* ── Title ───────────────────────────────────────────────── */

.modal-title {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 1rem;
  color: var(--color-text);
  letter-spacing: 0.18em;
  text-transform: uppercase;
  align-self: center;
  margin-bottom: 0.5rem;
}

/* ── Fee indicator ───────────────────────────────────────── */

.market-fee {
  font-family: var(--font-numeric);
  font-size: 0.7rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.4);
  letter-spacing: 0.04em;
  text-align: center;
  margin-bottom: 1rem;
}

/* ── Scrollable area ─────────────────────────────────────── */

.market-scroll {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  padding-right: 0.5rem;
  scrollbar-width: thin;
  scrollbar-color: rgba(var(--color-accent-rgb), 0.2) transparent;
}

.market-scroll::-webkit-scrollbar {
  width: 4px;
}

.market-scroll::-webkit-scrollbar-track {
  background: transparent;
}

.market-scroll::-webkit-scrollbar-thumb {
  background: rgba(var(--color-accent-rgb), 0.2);
  border-radius: 2px;
}

/* ── Column headers ──────────────────────────────────────── */

.market-header {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0 0.65rem;
  margin-bottom: 0.35rem;
}

.market-header-resource {
  min-width: 5.5rem;
}

.market-header-actions {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  margin-left: auto;
}

.market-header-label {
  font-family: var(--font-display);
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.35);
  flex: 1;
  text-align: center;
}

/* ── Trade row ───────────────────────────────────────────── */

.trade-row {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.55rem 0.65rem;
  background: rgba(var(--color-accent-rgb), 0.03);
  border: 1px solid rgba(var(--color-accent-rgb), 0.1);
  border-radius: 4px;
  transition: border-color 0.2s ease;
}

.trade-row:hover {
  border-color: rgba(var(--color-accent-rgb), 0.2);
}

/* ── Resource identity ───────────────────────────────────── */

.trade-resource {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  min-width: 5.5rem;
}

.trade-resource-icon {
  width: 1.15rem;
  height: 1.15rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}

.trade-resource-name {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 500;
  color: var(--color-text);
}

/* ── Trade action buttons ────────────────────────────────── */

.market-header-actions,
.trade-actions {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  margin-left: auto;
}

.market-header-label,
.trade-btn {
  flex: 1;
  min-width: 5.5rem;
}

.trade-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.15rem;
  padding: 0.55rem 0.6rem;
  border-radius: 3px;
}

.trade-btn-icon {
  width: 0.75rem;
  height: 0.75rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.3));
}

.trade-btn-value {
  font-family: var(--font-numeric);
  font-size: 0.7rem;
  font-weight: 400;
  letter-spacing: 0.02em;
}

.trade-btn-value--gain {
  color: #50a850;
}

.trade-btn-value--cost {
  color: rgba(var(--color-text-rgb), 0.7);
}

.trade-btn-value--insufficient {
  color: #c45050;
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
