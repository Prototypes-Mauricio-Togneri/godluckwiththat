<script setup>
import {computed, ref, watch, inject, onMounted, onBeforeUnmount, onUnmounted} from 'vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {formatNumber, formatNumberFull} from '@/js/engine/format.js'
import {TRADEABLE_RESOURCES} from '@/js/engine/constants.js'
import {MARKET_TRADE_AMOUNT, MARKET_PRICE_SHIFT, MARKET_BASE_FEE, MARKET_MIN_FEE, MARKET_FEE_REDUCTION_PER_LEVEL} from '@/js/engine/balancing.js'
import {IMG_RESOURCE_MAP, SND_MARKET_EXCHANGE} from '@/js/engine/assets.js'
import {EMIT_CLOSE, RESOURCE_GOLD, TRADE_BUY, TRADE_SELL} from '@/js/engine/enums.js'
import storage from '@/js/engine/storage.js'
import {marketTradeQuote} from '@/js/engine/utils.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {pushFocusLayer, removeFocusLayer} from '@/js/engine/focus_stack.js'
import {t} from '@/js/i18n/localized.js'
import ModalHelpModal from '@/components/modals/help_modal.vue'

const emit = defineEmits([EMIT_CLOSE])
const ui = inject('ui')
const actions = inject('actions')
const visible = ref(false)
const overlay = ref(null) // Root element; everything else is inert while this modal is topmost
const showHelp = ref(false)
let rafId = null

// ── Trade amount selector ──────────────────────────────────

const tradeAmount = ref(storage.tradeAmount)

/** Available trade amounts: 100, 1000, 10000, ... up to storageCap (stops at Infinity so a hand-edited save can't hang the loop). */
const availableAmounts = computed(() => {
  const amounts = []
  let value = MARKET_TRADE_AMOUNT
  while (value <= ui.storageCap && Number.isFinite(value)) {
    amounts.push(value)
    value *= 10
  }
  if (amounts.length === 0) {
    amounts.push(MARKET_TRADE_AMOUNT)
  }
  return amounts
})

/** Clamp tradeAmount when available options change (e.g. storehouse upgrade). */
watch(availableAmounts, (amounts) => {
  if (!amounts.includes(tradeAmount.value)) {
    tradeAmount.value = amounts[amounts.length - 1]
  }
}, {
  immediate: true,
})

/** Persist trade amount to localStorage whenever it changes. */
watch(tradeAmount, (value) => {
  storage.tradeAmount = value
})

/** Multiplier to scale base-100 prices to the selected trade amount. */
const tradeMultiplier = computed(() => tradeAmount.value / MARKET_TRADE_AMOUNT)

/** Scaled gold cost for buying a resource at the selected trade amount.
 * Uses the same per-lot pricing as the market trade itself.
 * @param {string} resource - Resource key
 * @returns {number} Total gold cost (floored)
 */
function scaledBuyPrice(resource) {
  return marketTradeQuote(ui.market.basePrices[resource], TRADE_BUY, tradeMultiplier.value, ui.market.fee).gold
}

/** Scaled gold gain for selling a resource at the selected trade amount.
 * Uses the same per-lot pricing as the market trade itself.
 * @param {string} resource - Resource key
 * @returns {number} Total gold gain (floored)
 */
function scaledSellPrice(resource) {
  return marketTradeQuote(ui.market.basePrices[resource], TRADE_SELL, tradeMultiplier.value, ui.market.fee).gold
}

function amountUp() {
  const idx = availableAmounts.value.indexOf(tradeAmount.value)
  if (idx < availableAmounts.value.length - 1) {
    tradeAmount.value = availableAmounts.value[idx + 1]
  }
}

function amountDown() {
  const idx = availableAmounts.value.indexOf(tradeAmount.value)
  if (idx > 0) {
    tradeAmount.value = availableAmounts.value[idx - 1]
  }
}

// ── Trade logic ────────────────────────────────────────────

/** Whether the colony can afford to buy this resource without exceeding storage.
 * @param {string} resource - Resource key to check
 * @returns {boolean} True if gold is sufficient and storage has room
 */
function canBuy(resource) {
  return ui.resources.gold >= scaledBuyPrice(resource)
    && ui.resources[resource] + tradeAmount.value <= ui.storageCap
}

/** Whether the colony has enough of this resource to sell without overflowing gold storage.
 * @param {string} resource - Resource key to check
 * @returns {boolean} True if resource amount is sufficient and gold storage has room
 */
function canSell(resource) {
  return ui.resources[resource] >= tradeAmount.value
    && ui.resources.gold + scaledSellPrice(resource) <= ui.storageCap
}

/** Tooltip text for the buy button, showing cost or the reason the trade is blocked.
 * @param {string} resource - Resource key to generate tooltip for
 * @returns {string} Localized tooltip string
 */
function buyTooltip(resource) {
  if (ui.resources.gold < scaledBuyPrice(resource)) {
    return t('market.notEnoughGold')
  }
  if (ui.resources[resource] + tradeAmount.value > ui.storageCap) {
    return t('market.stockpileFull', t('resource.' + resource).toLowerCase())
  }
  const name = t('resource.' + resource).toLowerCase()
  return t('market.buyTooltip', formatNumber(tradeAmount.value), name, formatNumber(scaledBuyPrice(resource)))
}

/** Tooltip text for the sell button, showing revenue or the reason the trade is blocked.
 * @param {string} resource - Resource key to generate tooltip for
 * @returns {string} Localized tooltip string
 */
function sellTooltip(resource) {
  if (ui.resources[resource] < tradeAmount.value) {
    return t('market.notEnoughResource', t('resource.' + resource).toLowerCase())
  }
  if (ui.resources.gold + scaledSellPrice(resource) > ui.storageCap) {
    return t('market.goldStockpileFull')
  }
  const name = t('resource.' + resource).toLowerCase()
  return t('market.sellTooltip', formatNumber(tradeAmount.value), name, formatNumber(scaledSellPrice(resource)))
}

/** Executes a buy trade if affordable, playing the exchange sound effect.
 * @param {string} resource - Resource key to buy
 */
function buy(resource) {
  if (!canBuy(resource)) {
    return
  }
  audio.playSound(SND_MARKET_EXCHANGE)
  actions.executeTrade(resource, TRADE_BUY, tradeAmount.value)
}

/** Executes a sell trade if the colony has enough stock, playing the exchange sound effect.
 * @param {string} resource - Resource key to sell
 */
function sell(resource) {
  if (!canSell(resource)) {
    return
  }
  audio.playSound(SND_MARKET_EXCHANGE)
  actions.executeTrade(resource, TRADE_SELL, tradeAmount.value)
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
    <div class="market-modal">
      <button class="modal-help-btn" @click="playTap(); showHelp = true">?</button>
      <button class="modal-close-x" @click="playTap(); emit(EMIT_CLOSE)">&#10005;</button>
      <h2 class="modal-title">{{ t('market.title') }}</h2>

      <!-- Resource summary -->
      <div class="market-resources">
        <div
          v-for="resource in TRADEABLE_RESOURCES"
          :key="resource"
          class="resource-box tooltip"
          :data-tooltip="t('resource.' + resource) + ': ' + formatNumberFull(ui.resources[resource])"
        >
          <div class="resource-row-top">
            <img class="resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
            <span class="resource-value">{{ formatNumber(ui.resources[resource]) }}</span>
          </div>
        </div>
        <div
          class="resource-box tooltip"
          :data-tooltip="t('resource.' + RESOURCE_GOLD) + ': ' + formatNumberFull(ui.resources[RESOURCE_GOLD])"
        >
          <div class="resource-row-top">
            <img class="resource-icon" :src="IMG_RESOURCE_MAP[RESOURCE_GOLD]" :alt="t('resource.' + RESOURCE_GOLD)">
            <span class="resource-value">{{ formatNumber(ui.resources[RESOURCE_GOLD]) }}</span>
          </div>
        </div>
      </div>

      <!-- Fee & amount controls -->
      <div class="market-controls">
        <div class="market-fee">
          {{ t('market.fee') }}: {{ ui.market.feePercent }}%
        </div>

        <div class="market-amount">
          <span class="amount-prefix">{{ t('market.amount') }}:</span>
          <button
            class="amount-btn"
            :disabled="tradeAmount <= availableAmounts[0]"
            @click="playTap(); amountDown()"
          >
            -
          </button>
          <span class="amount-label">{{ formatNumber(tradeAmount) }}</span>
          <button
            class="amount-btn"
            :disabled="tradeAmount >= availableAmounts[availableAmounts.length - 1]"
            @click="playTap(); amountUp()"
          >
            +
          </button>
        </div>
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
              class="btn-gold trade-btn tooltip"
              :class="{ 'tooltip--delayed': canSell(resource) }"
              :disabled="!canSell(resource)"
              :data-tooltip="sellTooltip(resource)"
              @click="sell(resource)"
            >
              <img class="trade-btn-icon" :src="IMG_RESOURCE_MAP.gold" alt="">
              <span
                class="trade-btn-value"
                :class="{ 'trade-btn-value--insufficient': ui.resources[resource] < tradeAmount }"
              >+{{ formatNumber(scaledSellPrice(resource)) }}</span>
            </button>

            <!-- Buy -->
            <button
              class="btn-gold trade-btn tooltip"
              :class="{ 'tooltip--delayed': canBuy(resource) }"
              :disabled="!canBuy(resource)"
              :data-tooltip="buyTooltip(resource)"
              @click="buy(resource)"
            >
              <img class="trade-btn-icon" :src="IMG_RESOURCE_MAP.gold" alt="">
              <span
                class="trade-btn-value"
                :class="{ 'trade-btn-value--insufficient': ui.resources.gold < scaledBuyPrice(resource) }"
              >-{{ formatNumber(scaledBuyPrice(resource)) }}</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <ModalHelpModal
      v-if="showHelp"
      :title="t('modal.marketHelp.title')"
      :body="t('modal.marketHelp.body', MARKET_TRADE_AMOUNT, MARKET_PRICE_SHIFT, MARKET_BASE_FEE * 100, MARKET_FEE_REDUCTION_PER_LEVEL * 100, MARKET_MIN_FEE * 100)"
      @close="showHelp = false"
    />
  </div>
</template>

<style scoped>
/* ── Modal container ─────────────────────────────────────── */

.market-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(var(--color-shadow-rgb), 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 1.25rem 2rem 1.75rem;
  width: 90vw;
  max-width: 400px;
  max-height: 89vh;
  display: flex;
  flex-direction: column;
  transform: translateY(8px);
  transition: transform 0.25s ease;
}

/* Slide-up entrance transition when overlay becomes visible */
.modal-overlay.visible .market-modal {
  transform: translateY(0);
}

/* ── Title ───────────────────────────────────────────────── */

.modal-title {
  font-size: 1rem;
  margin-bottom: 0.75rem;
}

/* ── Resource summary ────────────────────────────────────── */

.market-resources {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.5rem;
  padding-top: 1rem;
  margin-bottom: 0.75rem;
}

.market-resources .resource-box {
  flex: 1;
}

/* Subtle accent highlight on resource box hover */
.market-resources .resource-box:hover {
  border-color: rgba(var(--color-accent-rgb), 0.1);
  background: rgba(var(--color-accent-rgb), 0.03);
}

.market-resources .resource-value {
  flex: 1;
}

/* ── Fee & amount controls row ───────────────────────────── */

.market-controls {
  display: flex;
  align-items: stretch;
  justify-content: center;
  gap: 0.75rem;
  align-self: center;
  margin-bottom: 1.5rem;
}

/* ── Fee indicator ───────────────────────────────────────── */

.market-fee {
  font-family: var(--font-numeric);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.5);
  letter-spacing: 0.04em;
  text-align: center;
  display: flex;
  align-items: center;
  padding: 0.35rem 0.6rem;
  border-radius: 0.25rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.12);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.05),
    rgba(var(--color-shadow-rgb), 0.12)
  );
}

/* ── Amount selector ─────────────────────────────────────── */

.market-amount {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  padding: 0.35rem 0.4rem;
  border-radius: 0.25rem;
  border: 1px solid rgba(var(--color-accent-rgb), 0.12);
  background: linear-gradient(
    180deg,
    rgba(var(--color-accent-rgb), 0.05),
    rgba(var(--color-shadow-rgb), 0.12)
  );
}

.amount-prefix {
  font-family: var(--font-numeric);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.5);
  margin-right: 0.2rem;
  user-select: none;
}

.amount-label {
  font-family: var(--font-numeric);
  font-size: clamp(0.65rem, 0.7vw, 0.8rem);
  min-width: 3.5ch;
  margin-left: 0.3rem;
  margin-right: 0.3rem;
  text-align: center;
  color: var(--color-text);
  user-select: none;
}

.amount-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: clamp(1.4rem, 1.5vw, 1.8rem);
  height: clamp(1.4rem, 1.5vw, 1.8rem);
  padding: 0;
  border-radius: 0.2rem;
  font-size: 0.9rem;
  line-height: 1;
  color: rgba(var(--color-accent-rgb), 0.7);
  background: transparent;
  border: 1px solid rgba(var(--color-accent-rgb), 0.15);
  cursor: pointer;
  transition: background 0.15s ease, border-color 0.15s ease, color 0.15s ease;
}

.amount-btn:hover:not(:disabled) {
  background: rgba(var(--color-accent-rgb), 0.12);
  border-color: rgba(var(--color-accent-rgb), 0.5);
  color: rgba(var(--color-accent-rgb), 1);
}

.amount-btn:disabled {
  color: rgba(var(--color-accent-rgb), 0.15);
  border-color: rgba(var(--color-accent-rgb), 0.05);
  cursor: not-allowed;
}

/* ── Scrollable area ─────────────────────────────────────── */

.market-scroll {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

/* ── Column headers ──────────────────────────────────────── */

.market-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0 0.65rem;
  margin-bottom: 0.5rem;
}

.market-header-resource {
  width: 5rem;
  flex-shrink: 0;
}

.market-header-label {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.5);
  flex: 1;
  text-align: center;
}

/* ── Trade row ───────────────────────────────────────────── */

.trade-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.65rem 0.75rem;
  background: rgba(var(--color-accent-rgb), 0.03);
  border: 1px solid rgba(var(--color-accent-rgb), 0.1);
  border-radius: 0.25rem;
}

/* ── Resource identity ───────────────────────────────────── */

.trade-resource {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  width: 5rem;
  flex-shrink: 0;
}

.trade-resource-icon {
  width: 1.15rem;
  height: 1.15rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(var(--color-shadow-rgb), 0.4));
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
  gap: 0.5rem;
  flex: 1;
  max-width: 12rem;
  margin-left: auto;
}

.market-header-label,
.trade-btn {
  flex: 1;
  min-width: 3.5rem;
}

/* Dim the price value when the trade button is disabled */
.trade-btn:disabled .trade-btn-value {
  color: rgba(var(--color-text-rgb), 0.25);
}

/* Hide the tooltip when disabled, skip transition */
.trade-btn:disabled::after {
  transition: none;
  opacity: 0;
}

/* Re-show the tooltip on hover even when disabled */
.trade-btn:disabled:hover::after {
  opacity: 1;
}

.trade-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  padding: 0.45rem 0.4rem;
  border-radius: 0.1875rem;
}

.trade-btn-icon {
  width: 0.75rem;
  height: 0.75rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(var(--color-shadow-rgb), 0.3));
}

.trade-btn-value {
  font-family: var(--font-numeric);
  font-size: 0.7rem;
  font-weight: 400;
  letter-spacing: 0.02em;
}

/* Red highlight when the player lacks enough of the required resource */
.trade-btn-value--insufficient {
  color: rgba(196, 80, 80, 1);
}

</style>
