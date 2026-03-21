// Pre-import balancing.js to establish correct module load order.
// balancing.js imports Cost from cost.js and calls new Cost() at module scope.
// When balancing.js is loaded first, cost.js gets a live binding for
// RESOURCE_TIME_WEIGHTS (used lazily in toSeconds getter), then Cost finishes
// evaluating, and balancing.js can call new Cost() successfully.
import '@/js/engine/balancing.js'
