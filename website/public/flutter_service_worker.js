'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "f1055ab250f6e947c0440c6585a51964",
"assets/NOTICES": "79675db6e3fb8eb1e003343a2f22cef8",
"assets/FontManifest.json": "1d61ef933c075efc9d5b2eceb3317b47",
"assets/assets/audio/sfx/ammo1.mp3": "f8d02b968e3f3eaa373d7cc44a4c0102",
"assets/assets/audio/sfx/ammo2.mp3": "3d4e89deff81a7679c9718845d034953",
"assets/assets/tiles/terrain.tsx": "dd3ef955ab34262535165ca9ecfa8a84",
"assets/assets/images/signs/filled_sign.png": "f2b9076fbca6ad320cdc08f7293f50af",
"assets/assets/images/signs/unconnected_sign.png": "1032b43ade41f6b4559110d197338d3f",
"assets/assets/images/signs/idle_sign.png": "98afbf937c101118a2c6275ab4364da2",
"assets/assets/images/signs/stopped_sign.png": "2620c0a6a620a0dabc6d436dc57b1fc0",
"assets/assets/images/node_selected.png": "d8918b173847c5a8c433329c09f822dd",
"assets/assets/images/tiles_terrain.png": "214a365babec99e4c41ac07e5febcffb",
"assets/assets/images/buildings/factories/drone_factory.png": "3978b83e596e588ad848333b3402deef",
"assets/assets/images/buildings/power_plants/coal_power_plant.png": "171165f7c0ebd6562cf16209851e2586",
"assets/assets/images/buildings/power_plants/wind_turbine.png": "523ab527b3489111536cd50cfe6df5cc",
"assets/assets/images/buildings/power_plants/solar_panel.png": "71598ee8f965f8cf194d28c3146c7565",
"assets/assets/images/buildings/assemblers/carbon_fiber_assembly.png": "3b193df665dbb53f4c59251d93f51b42",
"assets/assets/images/buildings/assemblers/wire_assembly.png": "b92e459ac68d4b31b8cfa7bd4e65fd4b",
"assets/assets/images/buildings/assemblers/battery_assembly.png": "d04bdc65377210e70afc54cf6218a1aa",
"assets/assets/images/buildings/assemblers/gear_assembly.png": "8a3651f15af75a7a9f11c2be3889f62b",
"assets/assets/images/buildings/assemblers/motor_assembly.png": "8b030a893498237bedc4549b26fd2235",
"assets/assets/images/buildings/assemblers/circuit_assembly.png": "85e1befc7db55061c1794cca0e98c4fa",
"assets/assets/images/buildings/extractors/copper_mine.png": "6ee5362785da5b0cdeb02f959e448596",
"assets/assets/images/buildings/extractors/coal_mine.png": "c42589ba789c6ad0569cadf838d5fcf7",
"assets/assets/images/buildings/extractors/oil_rig.png": "4c39f0557e6780fd242265bdb71dfd15",
"assets/assets/images/buildings/extractors/stone_mine.png": "3180e1d51e50f87a42b0777343b20905",
"assets/assets/images/buildings/extractors/iron_mine.png": "95d62fe3d70898638da1f7aec8f2f4f0",
"assets/assets/images/buildings/processors/chemical_plant.png": "f9cb7a0af116c46f97a70b160034bccd",
"assets/assets/images/buildings/processors/iron_smelter.png": "6f805b20fc762a516c8d4ea92519e66e",
"assets/assets/images/buildings/processors/steel_smelter.png": "eaa1a382648062b85dde5934a657b3fa",
"assets/assets/images/buildings/processors/copper_smelter.png": "7442b90d20a8aec093fb83ed8028eabb",
"assets/assets/images/buildings/other/headquarters.png": "b9c3ed25848067e18349932278f0016a",
"assets/assets/images/buildings/other/warehouse.png": "9fe4e19974b87af910b036b56896e404",
"assets/assets/images/buildings/other/void_background.png": "d6be39f3ac937f4b0ddec2d479c80132",
"assets/assets/images/resources/concrete.png": "ba578f0b91996db41653c14ca83f2586",
"assets/assets/images/resources/energy.png": "7d723528b588e91d279549f6d927cbcb",
"assets/assets/images/resources/crystal.png": "29166d6050935bb144be11d13c719880",
"assets/assets/images/resources/copper_ore.png": "f541086db626bdb7dadad57193839dce",
"assets/assets/images/resources/explorer.png": "738db4eb5fd94080b60b397406ff688d",
"assets/assets/images/resources/plastic.png": "666dc3aca95d5a25419d4180eb273710",
"assets/assets/images/resources/circuit.png": "742c673e51c5b59b2b1b421f82eb84ac",
"assets/assets/images/resources/hydrogen.png": "0aa1eb02bce5024911f1150816f7cda8",
"assets/assets/images/resources/iron_ore.png": "dd1fa5f4ef9c59eefd94faf2a8b2d1fe",
"assets/assets/images/resources/time.png": "f537522ae51d7bc9907cec7efd230106",
"assets/assets/images/resources/wire.png": "90d695ad8847ea8e7adedc47580aaaa2",
"assets/assets/images/resources/coal_ore.png": "091e72e2fb5605e8c938fb582dfc28c7",
"assets/assets/images/resources/rocket.png": "80cd68edcf3331cde8abd5ebb6c5c327",
"assets/assets/images/resources/motor.png": "479adbf14fe38906e02ef2f8612d78c9",
"assets/assets/images/resources/copper_block.png": "fdda529e4c51df43efcad09b9e9521a0",
"assets/assets/images/resources/carbon_fiber.png": "ff998dd39dbe310a0e38c85b9b24a660",
"assets/assets/images/resources/stone_ore.png": "309bc9e55f0557d75b5a404a72f8a62a",
"assets/assets/images/resources/drone.png": "66fad146a8fecfa7ddfa0d8358834549",
"assets/assets/images/resources/iron_block.png": "4340b5ce4d10583dcac10602cef2e399",
"assets/assets/images/resources/steel.png": "a81344c871edab55b555e4b9c7fed520",
"assets/assets/images/resources/gear.png": "383eef471ae6a87038b8914d3e14472a",
"assets/assets/images/resources/oil.png": "9d203b3e218079267e61477e1c0e6928",
"assets/assets/images/resources/battery.png": "0e7b1ee2a9f96b3121aa4ac4255e7b49",
"assets/assets/images/patches/coal_patch.png": "69d3f0ca6445e01ca42304e3d717d569",
"assets/assets/images/patches/iron_patch.png": "4dbdc5cd1c63bc71c128b6f407b5c755",
"assets/assets/images/patches/stone_patch.png": "6263b0577d5acf8966e60ef4efc194d4",
"assets/assets/images/patches/oil_patch.png": "ae572ac66fd47c0f54e8595661dfde81",
"assets/assets/images/patches/copper_patch.png": "6df3268534067601a5b9240328276dc7",
"assets/assets/fonts/Pixel.ttf": "80520f263d966b867eaf5f8ac5feac0a",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "0ab9bc87641f6b7a80179e1a2d55eea0",
"manifest.json": "93b9088082de1f6e98edca51984431cc",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"firebase-messaging-sw.js": "6a00fdbf820ef5ab93a3f7b5f767256f",
"favicon.ico": "7d5e71d98847316dae878429e3334569",
"version.json": "e7d55f12544d51b8385a2b131fbe472a",
"index.html": "ec6708e0882af82ae4f014c3f65daf67",
"/": "ec6708e0882af82ae4f014c3f65daf67"
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
