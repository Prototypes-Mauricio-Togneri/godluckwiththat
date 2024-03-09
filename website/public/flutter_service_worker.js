'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "2688b130a2e6249fa25223b1e114bb7a",
"assets/NOTICES": "be20ff12db0c40651056c0c4c9d38dd5",
"assets/FontManifest.json": "38d088b85cbd1af87912c7c23d2f652a",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/images/units/villager.png": "577d3d1c604c17e01d1a752de896edef",
"assets/assets/images/buildings/consumers/house.png": "8c06a8c31142b9c114dc67e8b78e437f",
"assets/assets/images/buildings/producers/well.png": "5b227c4885709bffb0dddc3054b42bf3",
"assets/assets/images/buildings/producers/quarry.png": "a47fa69133559357df0fb696e494ff99",
"assets/assets/images/buildings/producers/logging_camp.png": "b5b453817a5a2e342eeaf4d7327b5ad0",
"assets/assets/images/buildings/producers/farm.png": "d92b579b3d5c31ce94376d55c9eb87b6",
"assets/assets/images/resources/food.png": "828f7ee645b1a92a16dc9e31280eb511",
"assets/assets/images/resources/gold.png": "06db090629fd2883599aaa05f45d3dd7",
"assets/assets/images/resources/iron.png": "4707762a69f23f464072a5d32c5a9d7f",
"assets/assets/images/resources/stone.png": "fdb123b88072ecb6eddee5d8fc72c9c7",
"assets/assets/images/resources/wood.png": "a0da4fa496fd94690abae803922096fd",
"assets/assets/images/resources/copper.png": "d2fc121be2ee5a37f22c53dfe8936409",
"assets/assets/images/other/upgrade.png": "3320fa1d357dd741fe3ac1993ade9648",
"assets/assets/images/other/idle.png": "8137c462f6c620c4cb4f5c154e497779",
"assets/assets/fonts/HellasCour-Regular.ttf": "0292d8c2f850c8e3fa7967092bdc9ed1",
"assets/fonts/MaterialIcons-Regular.otf": "a390a4efc70b2713d456037862c9b63d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "604472a77ec3724f6d2dac23a91a6ef3",
"assets/AssetManifest.json": "eac4492c67107053bc6dde31a1bc5ca8",
"assets/AssetManifest.bin.json": "9c2c0aff4f1c3f143a2fdf80d71f00bc",
"manifest.json": "1c2ac60477aabe7c778332e57ecdd493",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"firebase-messaging-sw.js": "e0686571a0a35317bff827da98a51b0e",
"favicon.ico": "64a97e63b08c74c530da44669689f227",
"version.json": "00baa0c933ecda7333399fe5f0ede794",
"index.html": "cb16c6d4e2d179e9e5023c230fd9fe63",
"/": "cb16c6d4e2d179e9e5023c230fd9fe63"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
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
