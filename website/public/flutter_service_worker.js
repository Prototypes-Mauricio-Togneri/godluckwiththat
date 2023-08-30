'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "25888719d8543a4006b7b0f483df5e86",
"assets/NOTICES": "58d4cc89a1a002e0c3e704efdd52ec04",
"assets/FontManifest.json": "aad96165ca38f600fc8fcd94439f2f8b",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/images/buildings/misc/headquarters.png": "639d54b48f735ac2d1fa3f5addee9975",
"assets/assets/images/buildings/misc/house.png": "8c06a8c31142b9c114dc67e8b78e437f",
"assets/assets/images/buildings/misc/market.png": "d09513c2c65328976d3e1c13203bcb3f",
"assets/assets/images/buildings/misc/warehouse.png": "ae8a442e5391e7dca04b73fba09ef5de",
"assets/assets/images/buildings/producers/well.png": "78e16d2feb899e3186bfbd9d30e98235",
"assets/assets/images/buildings/producers/quarry.png": "a47fa69133559357df0fb696e494ff99",
"assets/assets/images/buildings/producers/woodcutter.png": "b5b453817a5a2e342eeaf4d7327b5ad0",
"assets/assets/images/buildings/producers/farm.png": "d92b579b3d5c31ce94376d55c9eb87b6",
"assets/assets/images/resources/food.png": "631410e94860a452f317a5ae1f98230e",
"assets/assets/images/resources/villager.png": "577d3d1c604c17e01d1a752de896edef",
"assets/assets/images/resources/stone.png": "16e063c1893fd9eb4b9c3055145b0c8a",
"assets/assets/images/resources/wood.png": "7f51b9969e030b346e207ae0181b6d4e",
"assets/assets/images/resources/water.png": "19947cb28a87532095c396275a1894d8",
"assets/assets/images/other/upgrade.png": "3320fa1d357dd741fe3ac1993ade9648",
"assets/assets/images/other/exploration.png": "959cbcba5200388de149667c641af592",
"assets/assets/images/other/idle.png": "8137c462f6c620c4cb4f5c154e497779",
"assets/assets/images/patches/food.png": "e6d0752665299281c2a427daa12b7f8e",
"assets/assets/images/patches/stone.png": "29f161d77eaa59d18fb38c36a097f2dd",
"assets/assets/images/patches/wood.png": "a526897f2e2452a716e23ac4ba929133",
"assets/assets/images/patches/water.png": "89e036c5a5bba1c0c0fba0f589826b2b",
"assets/assets/fonts/instructions.ttf": "5b30cad42c83ebe2abc418ca76d5f5aa",
"assets/fonts/MaterialIcons-Regular.otf": "ea717783e9c8317f6864e8aa52c7fb9e",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "17536a251de2cbc4fc5b47b43a6fc927",
"assets/AssetManifest.json": "faca57ee033e4df42c6ec776802e06cf",
"manifest.json": "1c2ac60477aabe7c778332e57ecdd493",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"firebase-messaging-sw.js": "e0686571a0a35317bff827da98a51b0e",
"favicon.ico": "64a97e63b08c74c530da44669689f227",
"version.json": "00baa0c933ecda7333399fe5f0ede794",
"index.html": "5571d5bc497132d391bb09b6a9c62a10",
"/": "5571d5bc497132d391bb09b6a9c62a10"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
