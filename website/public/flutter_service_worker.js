'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "f0b1e5ff584ee62a57272460189fb966",
"assets/NOTICES": "72c52751f90805b3625eccad93c98d59",
"assets/FontManifest.json": "04f66f91cbe8ba1f8ec59e0b9d2e74ef",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/images/buildings/copper_mine.png": "099fa8f9bfc32f308db8608a12382d47",
"assets/assets/images/buildings/fortress.png": "adedd2f4f04b1a72e2dd93962f9331c0",
"assets/assets/images/buildings/headquarters.png": "8af00b536529cd3b3210dd4bc5a3d4cf",
"assets/assets/images/buildings/house.png": "3f3bd3182db02f4d12c67d89910e891f",
"assets/assets/images/buildings/cavalry.png": "96da75bcbbdc97c33c713c7a8ed55a83",
"assets/assets/images/buildings/quarry.png": "57abfb39334c71d5756a709c97a7e3e7",
"assets/assets/images/buildings/warehouse.png": "82796b18a14e3dcaaa72df19c7761175",
"assets/assets/images/buildings/archery.png": "0482dc9035977933887cea921a5f9c04",
"assets/assets/images/buildings/woodcutter.png": "9328552cb98639aed5d68da1d3b89354",
"assets/assets/images/buildings/iron_mine.png": "22166021ab07cd0bb40ba0565bf15b19",
"assets/assets/images/buildings/gold_mine.png": "61bc2f4e277127bbc9c5b76251eb2314",
"assets/assets/images/buildings/workshop.png": "0d63c65196275f2807a4d6ab55bf5369",
"assets/assets/images/buildings/barracks.png": "dd77c28248d0da3fe75e17b33d77f697",
"assets/assets/images/buildings/farm.png": "ea049591db556321b2b93d77998a89da",
"assets/assets/images/resources/food.png": "e86a9d516046bfe170c5312bf24dfa90",
"assets/assets/images/resources/gold.png": "8fac643cd3dd710e09a2376487748d55",
"assets/assets/images/resources/villager.png": "577d3d1c604c17e01d1a752de896edef",
"assets/assets/images/resources/idle.png": "8137c462f6c620c4cb4f5c154e497779",
"assets/assets/images/resources/iron.png": "b81664bf08078966227249c01e045bdf",
"assets/assets/images/resources/stone.png": "d59bec869f6c046006e51b6d924175fd",
"assets/assets/images/resources/wood.png": "5edf3842773ab6191b0c065a4a497d01",
"assets/assets/images/resources/copper.png": "2242a53ac435f4fc0292d6e524eed379",
"assets/assets/images/patches/stone_deposit.png": "c6f33a05e7f4a4b6d3ab52869343dedb",
"assets/assets/images/patches/forest.png": "793d3fb5c8435629cd869b3f2942c1c7",
"assets/assets/images/patches/empty.png": "ea793100a7367e023eb31f00923f9317",
"assets/assets/images/patches/crop_field.png": "7c9b2df9d7a855986580fe3b3cb12069",
"assets/assets/images/backgrounds/zone.jpg": "0744fd9c6dfa09cf4e662bcf3906d343",
"assets/assets/images/maps/misc/border6.png": "9c69b13d0b422ad0e7017a7671673bc5",
"assets/assets/images/maps/misc/border4.png": "bd887362ac20c4f5667ad4168b50fea2",
"assets/assets/images/maps/misc/border2.png": "8139ec6c226d48df99b02b7785e9d82e",
"assets/assets/images/maps/misc/border5.png": "ffd22ca3531345a7781eebc05f1e24c5",
"assets/assets/images/maps/misc/border1.png": "743f5199d07203303cf230c8551d166f",
"assets/assets/images/maps/misc/border3.png": "7c9c9ba60f5a31613d76d11ee07f6a12",
"assets/assets/images/maps/misc/zone_hovered.png": "e23e2b195a6a4f68dfdd243aec69d678",
"assets/assets/images/maps/misc/zone_unexplored.png": "fe3e85cba365e6254c23d7107f389921",
"assets/assets/images/maps/chapter1/map.png": "cda120abda57847884fc36e75d3aebe8",
"assets/assets/fonts/Dulcinea-Serif-Bold.ttf": "daf2558e12f338b5c30cd14248bcb544",
"assets/fonts/MaterialIcons-Regular.otf": "bff67d5db5a3106a082a7498758fdcde",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "7f54e28f2851e72660a0a8b22e672652",
"assets/AssetManifest.json": "0dd4fe39131d255d5d285ecedfa679cf",
"manifest.json": "85ddde35c43b51395d923e0763d24c6b",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"firebase-messaging-sw.js": "224d5b6f87db909255e9c132e3909e0f",
"favicon.ico": "7d5e71d98847316dae878429e3334569",
"version.json": "fa398a9f29b0e0a4657beb1be0bbb558",
"index.html": "cd704d043beb47982304568fac7fe053",
"/": "cd704d043beb47982304568fac7fe053"};
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
