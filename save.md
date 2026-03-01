File Path: src/js/engine/game_state.js
Issue Type: Logical Bug
Line #: 29-33
Severity: Warning
Description & Suggested Fix: _resourcesAtCap / _resourcesNegativeProduction 
  Sets not persisted. After save/load, these Sets start empty. The first
  update() treats all capped resources as "just reached cap", re-firing
  notifications. Fix: Serialize these Sets, or deduplicate notifications on
  the event side.

File Path: src/js/models/events/events.js
  Issue Type: Logical Bug
  Line #: 13-17
  Severity: Warning
  Description & Suggested Fix: Events constructor cannot restore serialized 
    state. toJSON() serializes nextId, future, and past, but the constructor
    always initializes empty with _nextId = 1. There is no fromJSON path. If
    save/load is implemented, all events are lost and IDs collide. Fix: Accept
    optional data in the constructor or add a static fromJSON().