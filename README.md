# God Luck With That

[Website](https://god-luck-with-that.web.app)

- UI bugs
  - Buttons too big? Or cards too small?
  - Fix bottom padding not being enough
- Fix bug with multiple "Population limit reached" past events
- All initial researches need food
  food + wood + knowledge
  wood + stone + knowledge
  stone + copper + knowledge
  copper + iron + knowledge
  iron + gold + knowledge
- Add punishment when missing food/wood => reduce production

- Finish all building images
  - Monument: Re-design it

- Implement save and load
  - Have save slots and autosave

- Create tutorial
  - Season has changed -> Explain their effects on production and upkeep
  - Build a house
  - Build a farm
  - Build a woodcutter
  - Create a worker
  - Assign workers
  - Build an altar
  - Show what buildings are unlocked when upgrading HQ

- Implement challenges
  - See next challenge
  - Resolve a challenge
  - Show challenge outcome
  - Choose blessing

- Create military
  - Open military window
  - See military
  - Create units
  - See upcoming attacks
  - Implement military researches

- Implement natural disasters
  - Implement random disasters
  - Implement disasters researches

- Cloud saves

- Implement story intro

-----

- FPS: 60 — Frames per second. How many times the requestAnimationFrame loop ran in the last second. 60 = smooth, drops mean the browser is struggling to keep up.                   
- Frame: 16.6ms — Average time between rAF frames in milliseconds. At 60 FPS you'd expect ~16.6ms budget per frame. Lower = more headroom. If this approaches 16ms, you're close to dropping frames.
- syncUI: 0.2ms — Average time spent in syncUI(), the full sync that copies all game state into the ui reactive object. Runs every 1s game tick and whenever a construction/research completes. This is the main thing your optimizations target.
- syncTimers: 0.03ms — Average time spent in syncTimers(), the fast-path sync that only updates time-sensitive fields (season elapsed, construction timers, research timers). Runs every rAF frame when nothing is completing. Should be much cheaper than syncUI.
- tick: 0.1ms — Average time spent in state.update(), the engine tick that recalculates production rates, applies resource gains, checks caps, etc. Runs once per second. This measures pure game logic cost, separate from UI sync.