'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "94cd27eb67fe0375fe6eb87647795d08",
"assets/NOTICES": "1f40b111341e3c322dc4b75f3cf730d5",
"assets/FontManifest.json": "1d61ef933c075efc9d5b2eceb3317b47",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/tiles/terrain.tsx": "dd3ef955ab34262535165ca9ecfa8a84",
"assets/assets/images/signs/filled_sign.png": "f2b9076fbca6ad320cdc08f7293f50af",
"assets/assets/images/signs/unconnected_sign.png": "1032b43ade41f6b4559110d197338d3f",
"assets/assets/images/signs/idle_sign.png": "98afbf937c101118a2c6275ab4364da2",
"assets/assets/images/drones/basic_drone.png": "66fad146a8fecfa7ddfa0d8358834549",
"assets/assets/images/drones/advance_drone.png": "0c810c983652b2a5e613920f612f2363",
"assets/assets/images/drones/intermediate_drone.png": "18f2c7517797e123453b623df5d95e49",
"assets/assets/images/node_selected.png": "d8918b173847c5a8c433329c09f822dd",
"assets/assets/images/tiles_terrain.png": "214a365babec99e4c41ac07e5febcffb",
"assets/assets/images/buildings/factories/drone_factory.png": "88ada65b5bb2a94ec8b93d2d272bfd64",
"assets/assets/images/buildings/power_plants/wind_turbine.png": "c1ac988190c9e11bcf6dd71e50a845b2",
"assets/assets/images/buildings/power_plants/solar_panel.png": "2a4a7f09e4e4bcd0e14d455676f9d309",
"assets/assets/images/buildings/extractors/copper_mine.png": "683a9c9396e37babe1781fc07b6d3bd6",
"assets/assets/images/buildings/extractors/coal_mine.png": "6fbd20cea297c086907070d1760e2718",
"assets/assets/images/buildings/extractors/stone_mine.png": "2c76d78213a2d5ef19332a8b94bed299",
"assets/assets/images/buildings/extractors/iron_mine.png": "7547ad38b0c2f298e39249b156f6d21d",
"assets/assets/images/buildings/processors/iron_smelter.png": "f415c687fe052adfdd25d654f90a4295",
"assets/assets/images/buildings/processors/copper_smelter.png": "02cf51c3b2b8dbc33c07302f303f86b3",
"assets/assets/images/buildings/headquarters/headquarters.png": "a06c84f7daa157e06d4123e87c25b1e6",
"assets/assets/images/resources/concrete.png": "ba578f0b91996db41653c14ca83f2586",
"assets/assets/images/resources/energy.png": "7d723528b588e91d279549f6d927cbcb",
"assets/assets/images/resources/copper_ore.png": "f541086db626bdb7dadad57193839dce",
"assets/assets/images/resources/iron_ore.png": "dd1fa5f4ef9c59eefd94faf2a8b2d1fe",
"assets/assets/images/resources/coal_ore.png": "091e72e2fb5605e8c938fb582dfc28c7",
"assets/assets/images/resources/copper_block.png": "fdda529e4c51df43efcad09b9e9521a0",
"assets/assets/images/resources/stone_ore.png": "309bc9e55f0557d75b5a404a72f8a62a",
"assets/assets/images/resources/iron_block.png": "4340b5ce4d10583dcac10602cef2e399",
"assets/assets/images/resources/steel.png": "a81344c871edab55b555e4b9c7fed520",
"assets/assets/images/patches/coal_patch.png": "69d3f0ca6445e01ca42304e3d717d569",
"assets/assets/images/patches/iron_patch.png": "4dbdc5cd1c63bc71c128b6f407b5c755",
"assets/assets/images/patches/stone_patch.png": "6263b0577d5acf8966e60ef4efc194d4",
"assets/assets/images/patches/copper_patch.png": "6df3268534067601a5b9240328276dc7",
"assets/assets/fonts/Pixel.ttf": "80520f263d966b867eaf5f8ac5feac0a",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "c769caf5c998a30b5ab63a044a79e049",
"manifest.json": "93b9088082de1f6e98edca51984431cc",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"firebase-messaging-sw.js": "6a00fdbf820ef5ab93a3f7b5f767256f",
"favicon.ico": "7d5e71d98847316dae878429e3334569",
"version.json": "e7d55f12544d51b8385a2b131fbe472a",
"index.html": "f6e7c240f4fd23d81ad37392df2a0017",
"/": "f6e7c240f4fd23d81ad37392df2a0017"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
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
