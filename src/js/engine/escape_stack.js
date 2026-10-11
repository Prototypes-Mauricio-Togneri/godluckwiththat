// Routes the Escape key to the topmost open modal only.
// Modals push a handler when they open and remove it when they close. A single capture-phase
// window listener calls the most recently pushed handler and stops the event there, so modals
// underneath and the game screen's pause toggle never see it.

const handlers = []

/**
 * Calls the topmost handler on Escape and stops the event from reaching any other listener.
 * @param {KeyboardEvent} event - Keyboard event
 */
function handleKeydown(event) {
  if (event.key !== 'Escape' || handlers.length === 0) {
    return
  }
  event.stopImmediatePropagation()
  handlers[handlers.length - 1]()
}

/**
 * Makes the handler the one that receives Escape until it is removed or another is pushed.
 * @param {Function} handler - Called with no arguments when Escape is pressed
 */
export function pushEscapeHandler(handler) {
  if (handlers.length === 0) {
    window.addEventListener('keydown', handleKeydown, true)
  }
  handlers.push(handler)
}

/**
 * Removes the handler, giving Escape back to the handler pushed before it.
 * @param {Function} handler - Handler previously passed to pushEscapeHandler
 */
export function removeEscapeHandler(handler) {
  const index = handlers.lastIndexOf(handler)
  if (index === -1) {
    return
  }
  handlers.splice(index, 1)
  if (handlers.length === 0) {
    window.removeEventListener('keydown', handleKeydown, true)
  }
}
