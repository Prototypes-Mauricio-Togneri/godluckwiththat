// Keeps keyboard input inside the topmost open modal.
// Modals push their root element when they open and remove it when they close. Everything outside the
// topmost modal (the game header and board, and any modal underneath) is marked inert, so Tab, Enter and
// Space can't reach controls the overlay only covers visually. Overlays block the mouse but not the
// keyboard. Whenever the topmost modal changes, or an element is added next to it or next to one of its
// ancestors (e.g. a building card unlocked behind a building help modal), the marks are recomputed.
// Closing the topmost modal gives focus back to the element that had it when that modal opened.

const layers = [] // Open modals, bottom to top: {element, returnFocus}
let inertElements = [] // Elements this module marked inert, so only those are restored
let ancestorObserver = null // Watches the topmost layer's ancestors for children added after marking

/** Marks inert every element outside the topmost layer, after undoing the previous marks. */
function applyInert() {
  for (const element of inertElements) {
    element.removeAttribute('inert')
  }
  inertElements = []
  ancestorObserver?.disconnect()
  const topLayer = layers[layers.length - 1]?.element
  if (!topLayer) {
    return
  }
  ancestorObserver ??= new window.MutationObserver(applyInert)
  // Walk up to <body>, marking the siblings of the layer and of each of its ancestors
  for (let node = topLayer; node !== document.body && node.parentElement; node = node.parentElement) {
    ancestorObserver.observe(node.parentElement, {
      childList: true,
    })
    for (const sibling of node.parentElement.children) {
      if (sibling !== node && !sibling.hasAttribute('inert')) {
        sibling.setAttribute('inert', '')
        inertElements.push(sibling)
      }
    }
  }
}

/**
 * Makes the element the only interactive part of the page until it is removed or another is pushed.
 * Call from the modal's onMounted with its root element.
 * @param {HTMLElement} element - Root element of the modal that just opened
 */
export function pushFocusLayer(element) {
  // Remember what had focus before marking the page inert drops it, to give it back on close
  layers.push({
    element: element,
    returnFocus: document.activeElement,
  })
  applyInert()
}

/**
 * Removes the element, giving input back to the layer pushed before it (or the whole page), and focus
 * back to the element that had it when the element was pushed, if it was the topmost layer.
 * Call from the modal's onBeforeUnmount: the template ref is already null by onUnmounted.
 * @param {HTMLElement} element - Element previously passed to pushFocusLayer
 */
export function removeFocusLayer(element) {
  const index = layers.findLastIndex(layer => layer.element === element)
  if (index === -1) {
    return
  }
  const wasTopLayer = index === layers.length - 1
  const [removed] = layers.splice(index, 1)
  applyInert()
  // Only the topmost modal closing moves focus; one closing underneath leaves it where it is
  if (wasTopLayer && removed.returnFocus?.isConnected) {
    removed.returnFocus.focus({
      preventScroll: true,
    })
  }
}
