'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "22ef29bb47ee6c7976374ad3aa28b340",
"img/background.jpg": "ce205ccf764e8925a45ae873cf56444f",
"main.dart.js": "f8218189d1a7ca9ea76cf1f8467377b2",
"assets/NOTICES": "c66d3ad8836ed84ed4c485fbb3930d8c",
"assets/FontManifest.json": "0e944ca6383252488b8e2026366251c3",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/images/units/worker.png": "3234d3c7f9a5d9ec2d9b4f0a1c17a4fe",
"assets/assets/images/buildings/misc/academy.png": "ae9f61afd3ecf15e5699177223846c18",
"assets/assets/images/buildings/misc/headquarters.png": "0ef818fef439f55df9ed1403c2957bc0",
"assets/assets/images/buildings/misc/house.png": "8a0013af1bcb90235ba6b47306a505a5",
"assets/assets/images/buildings/misc/market.png": "755573635473986e6ca645b6effdd266",
"assets/assets/images/buildings/misc/storehouse.png": "be7aa46f26eb3765ba61808cfd5cae88",
"assets/assets/images/buildings/religious/temple.png": "bababa8d65ac95a8358bec00e1d548fb",
"assets/assets/images/buildings/religious/altar.png": "413a94722bfdfd53188b919901e6ef53",
"assets/assets/images/buildings/religious/shrine.png": "5f9253129fa7932c11e51560fa9c0406",
"assets/assets/images/buildings/religious/monument.png": "6145fdf54f159eee43a088ee6e3ed02c",
"assets/assets/images/buildings/resources/copper_mine.png": "a4e7f3e0deb1b7f5d6fdf10477f25caf",
"assets/assets/images/buildings/resources/quarry.png": "6d6338c859c585dd67d41a95591a805c",
"assets/assets/images/buildings/resources/woodcutter.png": "b38dceb558d77974b6ecbc81c6c83f31",
"assets/assets/images/buildings/resources/iron_mine.png": "1748a1968d6644c406fbbf48866fc32f",
"assets/assets/images/buildings/resources/gold_mine.png": "0ed97932a56c2ff6800134b5cd1c0bf0",
"assets/assets/images/buildings/resources/farm.png": "8fdf17c4cdaffb46703151d86fe60b1e",
"assets/assets/images/resources/food.png": "e0057c259786c7e83bd570d32e14b073",
"assets/assets/images/resources/gold.png": "06db090629fd2883599aaa05f45d3dd7",
"assets/assets/images/resources/faith.png": "62784c539ca0b5ace0fb1898f6077f4c",
"assets/assets/images/resources/iron.png": "4707762a69f23f464072a5d32c5a9d7f",
"assets/assets/images/resources/stone.png": "fdb123b88072ecb6eddee5d8fc72c9c7",
"assets/assets/images/resources/wood.png": "a0da4fa496fd94690abae803922096fd",
"assets/assets/images/resources/copper.png": "d2fc121be2ee5a37f22c53dfe8936409",
"assets/assets/images/resources/knowledge.png": "110d0aff48a9900d6610a2da3fa9a97e",
"assets/assets/images/other/upgrade.png": "3320fa1d357dd741fe3ac1993ade9648",
"assets/assets/images/other/house.png": "117c12bfaeaae7d9f8b0d8de90cd0052",
"assets/assets/images/other/idle.png": "8137c462f6c620c4cb4f5c154e497779",
"assets/assets/images/backgrounds/background.jpg": "5ebed543d2f0ecce72572617a64c6572",
"assets/assets/fonts/Outfit.ttf": "905f109c79bd9683fc22eaffe4808ffe",
"assets/fonts/MaterialIcons-Regular.otf": "58953bebfc8c00af96eac0561e8a3ef1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "45c27e1ce7e71248ef305f6acdef0067",
"assets/AssetManifest.json": "caea4056f75b3c9996df114bf7e221ac",
"assets/AssetManifest.bin.json": "901f8c77505f612971b5a18e5c961eed",
"manifest.json": "e7db8eaa71139f5bdcf886c50c491dfe",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"firebase-messaging-sw.js": "e0686571a0a35317bff827da98a51b0e",
"favicon.ico": "64a97e63b08c74c530da44669689f227",
"version.json": "00baa0c933ecda7333399fe5f0ede794",
"index.html": "133f28229511a8a54b40e1ce6ba74c4e",
"/": "133f28229511a8a54b40e1ce6ba74c4e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
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
