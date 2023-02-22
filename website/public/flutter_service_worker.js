'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "dc2dae7b434acc2323764fd2567b9b7b",
"assets/NOTICES": "6b065cf3802ead36b1dc96e058b26fff",
"assets/FontManifest.json": "1d61ef933c075efc9d5b2eceb3317b47",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/tiles/terrain.tsx": "42df2576a940e8daf903da270356b615",
"assets/assets/images/paths/path4a.png": "c523a4af10b202f4f9567391e293e92f",
"assets/assets/images/paths/path1b.png": "3bd8ce2dd5f59301d35da9b7139b7929",
"assets/assets/images/paths/path4c.png": "17658521f55ad4008940fb25f5ce23c9",
"assets/assets/images/paths/path1a.png": "9f5bf6d82dda94748e3fda39b16a432f",
"assets/assets/images/paths/path5a.png": "0951a7a5029919eb56ae6c777adcef21",
"assets/assets/images/paths/path3c.png": "c09065e966dcc147ae4a2f0ce3e16444",
"assets/assets/images/paths/path2a.png": "ea158850007fbe56b2812be5f2b860c8",
"assets/assets/images/paths/path4d.png": "9bb36e7a152904b38d2b94a6ef63f8eb",
"assets/assets/images/paths/path3a.png": "58f250190d607d448dd81a1cc8bcb17e",
"assets/assets/images/paths/path3b.png": "3a9ff7f0e043d0d6d476eb3d59547ce8",
"assets/assets/images/paths/path1c.png": "8a502fd7863a20b6274b56ac75af5db0",
"assets/assets/images/paths/path3d.png": "f2e11e3751af7c6e0b323e199f735ffb",
"assets/assets/images/paths/path4b.png": "534a23834605d2e2c951958e13d316ef",
"assets/assets/images/paths/path2b.png": "b64200355db3d2cb536d5d1e7d823c56",
"assets/assets/images/paths/path1d.png": "71b31abacf7f5679bff50ec978c1327c",
"assets/assets/images/node_selected.png": "76e0de4f870568b582b40286a2ed1dde",
"assets/assets/images/tiles_terrain.png": "86743b0cc374c959bc87b653ccee81e9",
"assets/assets/images/buildings/bakery.png": "9988e6f5c5727184a3192b94d6dbec1b",
"assets/assets/images/buildings/fisher.png": "afd32d12d2364417b1ab2322b0dcf072",
"assets/assets/images/buildings/headquarters.png": "01bddac2817e9e7ecc425da1fb22ea0d",
"assets/assets/images/buildings/flag.png": "1df8dc35101e5d6b0a03513e53678458",
"assets/assets/images/buildings/sawery.png": "44fb48eba48445b5773f37869401521b",
"assets/assets/images/buildings/well.png": "71cdfdafcb64c59afcde63ce609f98bb",
"assets/assets/images/buildings/quarry.png": "038b149fb8f7f564005885034c5a8e9e",
"assets/assets/images/buildings/crop_farm.png": "3dfea20154613f10c171d16a77011381",
"assets/assets/images/buildings/hunter.png": "8b4de0ef34ecd7fc37f89c656230fd43",
"assets/assets/images/buildings/woodcutter.png": "788da72d7534b978489dd7d8906cb890",
"assets/assets/images/buildings/mill.png": "5fbfc72dc2987540e6ffe44c420480c6",
"assets/assets/images/warning_sign.png": "469c644dcad4957116e5366afd57ba67",
"assets/assets/images/resources/meat.png": "6e3e9bdd4b72ea0e80cbd4dbebb3e687",
"assets/assets/images/resources/bread.png": "09e18fad1a586b63e3d0679597500154",
"assets/assets/images/resources/grain.png": "d415dc36841d34031bdc4e770ff164bd",
"assets/assets/images/resources/timber.png": "cc0a42f742b7e75065420a7e7fe5ebff",
"assets/assets/images/resources/fish.png": "7a8bb7fbc5568d3455bc6549b697f9a3",
"assets/assets/images/resources/stone.png": "ffa60fe01c48a5d8907c52672d17c72d",
"assets/assets/images/resources/flour.png": "7121f3493658bbf1bc3385743269a909",
"assets/assets/images/resources/wood.png": "410365e2cdcf1362e3194dc9b2c3242c",
"assets/assets/images/resources/water.png": "4a3b9153c4e47104811ed73a2bc3cceb",
"assets/assets/images/idle_sign.png": "2ad99fa7e4978d12b41f68bde3663c15",
"assets/assets/fonts/Pixel.ttf": "80520f263d966b867eaf5f8ac5feac0a",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "03f7bb92ec16fadb81f9936473096f08",
"manifest.json": "cd2c09751a45324569b398ed5c1dd8fd",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"firebase-messaging-sw.js": "2a1aeb63ba5b6ed411f7c1187d6b1847",
"favicon.ico": "7d5e71d98847316dae878429e3334569",
"version.json": "370b23de5d2f42f0b15a307c0ec50830",
"index.html": "61af34a53244f827f253a547ea82dcb2",
"/": "61af34a53244f827f253a547ea82dcb2"
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
