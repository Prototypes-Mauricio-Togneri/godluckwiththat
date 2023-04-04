'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "cade7edad3188f6a676496aace3b3e3e",
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
"assets/assets/images/buildings/factories/drone_factory.png": "352adc1f19b8efd5973f7a03bfac1f46",
"assets/assets/images/buildings/power_plants/nuclear_power_plant.png": "42f20d31fd98cc223b75caee50943671",
"assets/assets/images/buildings/power_plants/oil_power_plant.png": "bbdf8abb28ed20e3094ad8d3ea10b0bd",
"assets/assets/images/buildings/power_plants/coal_power_plant.png": "6a0f46a8cbbc37fd959ff11f18ac547e",
"assets/assets/images/buildings/power_plants/wind_turbine.png": "523ab527b3489111536cd50cfe6df5cc",
"assets/assets/images/buildings/power_plants/solar_panel.png": "d4fb7867d8e32cfced9e9b02c9541b7e",
"assets/assets/images/buildings/assemblers/explosives_assembly.png": "b32776068b2f00b660577ce42fb7f131",
"assets/assets/images/buildings/assemblers/chip_assembly.png": "6a85b9e8f728fc046629bfe005a3d541",
"assets/assets/images/buildings/assemblers/wire_assembly.png": "4aee8ebacdb578e8bcaf4241cb35c1d7",
"assets/assets/images/buildings/assemblers/transistor_assembly.png": "2a60265d17337dce5ee986f0eaf0609b",
"assets/assets/images/buildings/assemblers/battery_assembly.png": "3a7891e606d7e70b1c9d7817907f5b0b",
"assets/assets/images/buildings/assemblers/gear_assembly.png": "06af2edef03d6f8c78ca5d2eef047c73",
"assets/assets/images/buildings/assemblers/motor_assembly.png": "2695d0d72c9edffb5ad1f04e0c5b051f",
"assets/assets/images/buildings/assemblers/circuit_assembly.png": "1b2946b09ae1b36e032778367ecc9070",
"assets/assets/images/buildings/extractors/copper_mine.png": "3ec81b2f9a201d55a62aed9c1eb5a5ae",
"assets/assets/images/buildings/extractors/coal_mine.png": "3ec81b2f9a201d55a62aed9c1eb5a5ae",
"assets/assets/images/buildings/extractors/oil_rig.png": "f0bf1b2448594baf00cc848bcf84bf3c",
"assets/assets/images/buildings/extractors/titanium_mine.png": "3ec81b2f9a201d55a62aed9c1eb5a5ae",
"assets/assets/images/buildings/extractors/stone_mine.png": "3ec81b2f9a201d55a62aed9c1eb5a5ae",
"assets/assets/images/buildings/extractors/iron_mine.png": "3ec81b2f9a201d55a62aed9c1eb5a5ae",
"assets/assets/images/buildings/extractors/water_pump.png": "e24185e4d1d06dada2ced2f821fb453e",
"assets/assets/images/buildings/extractors/uranium_mine.png": "3ec81b2f9a201d55a62aed9c1eb5a5ae",
"assets/assets/images/buildings/processors/oil_refinery.png": "bf0dc6d420361dc9cad09fab6b7fe9e1",
"assets/assets/images/buildings/processors/chemical_plant.png": "a232c1ee9ec5a45b808128ede950a891",
"assets/assets/images/buildings/processors/stone_smelter.png": "4a2a71b211dd66d3624b3279e55751a9",
"assets/assets/images/buildings/processors/iron_smelter.png": "4a2a71b211dd66d3624b3279e55751a9",
"assets/assets/images/buildings/processors/polymer_plant.png": "a13aceb46114990c631588ab61d576c2",
"assets/assets/images/buildings/processors/steel_smelter.png": "4a2a71b211dd66d3624b3279e55751a9",
"assets/assets/images/buildings/processors/titanium_smelter.png": "4a2a71b211dd66d3624b3279e55751a9",
"assets/assets/images/buildings/processors/copper_smelter.png": "4a2a71b211dd66d3624b3279e55751a9",
"assets/assets/images/buildings/other/radar.png": "4ce9247fd3174c550011fcde8db2b70a",
"assets/assets/images/buildings/other/headquarters.png": "b9c3ed25848067e18349932278f0016a",
"assets/assets/images/buildings/other/warehouse.png": "baabdae8d735ad0bc76ea6ac34d1c2b5",
"assets/assets/images/buildings/other/void_background.png": "d6be39f3ac937f4b0ddec2d479c80132",
"assets/assets/images/resources/components/transistor.png": "c88218cb64e77d03636c6a6dc5ebe713",
"assets/assets/images/resources/components/circuit.png": "742c673e51c5b59b2b1b421f82eb84ac",
"assets/assets/images/resources/components/wire.png": "90d695ad8847ea8e7adedc47580aaaa2",
"assets/assets/images/resources/components/chip.png": "2a4d9c2143277ab3d398ed416a423eca",
"assets/assets/images/resources/components/motor.png": "479adbf14fe38906e02ef2f8612d78c9",
"assets/assets/images/resources/components/explosives.png": "a7fca3fe36e3719d2bd8dd1fc4d33d20",
"assets/assets/images/resources/components/gear.png": "383eef471ae6a87038b8914d3e14472a",
"assets/assets/images/resources/components/battery.png": "0e7b1ee2a9f96b3121aa4ac4255e7b49",
"assets/assets/images/resources/materials/concrete.png": "ba578f0b91996db41653c14ca83f2586",
"assets/assets/images/resources/materials/titanium_plate.png": "4340b5ce4d10583dcac10602cef2e399",
"assets/assets/images/resources/materials/sulfur.png": "516e25bfecfb3936bc38542dfc4e27a0",
"assets/assets/images/resources/materials/plastic.png": "666dc3aca95d5a25419d4180eb273710",
"assets/assets/images/resources/materials/fuel.png": "317b0202c9293f2750b8504438236c7a",
"assets/assets/images/resources/materials/iron_plate.png": "a1bd294cb6ccdf079cd265b5ad33747f",
"assets/assets/images/resources/materials/steel.png": "a81344c871edab55b555e4b9c7fed520",
"assets/assets/images/resources/materials/copper_plate.png": "fdda529e4c51df43efcad09b9e9521a0",
"assets/assets/images/resources/energy/energy.png": "53811c183d9e983bf22b430803a04e44",
"assets/assets/images/resources/ammunition/piercing_shell.png": "8f6bc2c75e26e363d341c5c1f4aa933a",
"assets/assets/images/resources/ammunition/standard_shell.png": "2b82dc7695dd82f0ab4ef5543c4e61df",
"assets/assets/images/resources/ammunition/cannon_shell.png": "4a8c0c164490dfa8c1f04e8753040692",
"assets/assets/images/resources/machines/laser_mech.png": "67962a0209ef6698c224a01de223ed1d",
"assets/assets/images/resources/machines/light_mech.png": "7e2a61f0bcf34cc3ae3e0cb63f526ff0",
"assets/assets/images/resources/machines/heavy_mech.png": "89d3d9df8a3f860380f6ecafb0b20a2d",
"assets/assets/images/resources/machines/drone.png": "66fad146a8fecfa7ddfa0d8358834549",
"assets/assets/images/resources/machines/armored_mech.png": "71b6cd5839c468ae4718ec90c0545ad1",
"assets/assets/images/resources/machines/cannon_mech.png": "00b03b931e8ddfa0b86898a1388e75a1",
"assets/assets/images/resources/resources/copper_ore.png": "f541086db626bdb7dadad57193839dce",
"assets/assets/images/resources/resources/iron_ore.png": "dd1fa5f4ef9c59eefd94faf2a8b2d1fe",
"assets/assets/images/resources/resources/uranium_ore.png": "eda87d096fd680714f7779ed4b1cb855",
"assets/assets/images/resources/resources/coal_ore.png": "091e72e2fb5605e8c938fb582dfc28c7",
"assets/assets/images/resources/resources/titanium_ore.png": "b539eb8a7db0ac3acedf823d6bc4fe2c",
"assets/assets/images/resources/resources/stone_ore.png": "e661638124d2af813a4588e41889b372",
"assets/assets/images/resources/resources/oil.png": "9d203b3e218079267e61477e1c0e6928",
"assets/assets/images/resources/resources/water.png": "aab22366ef2fa53dfc5499869f97754d",
"assets/assets/images/resources/time/time.png": "f537522ae51d7bc9907cec7efd230106",
"assets/assets/images/patches/titanium_patch.png": "6804562f1ea9bc939f536286a2f21740",
"assets/assets/images/patches/coal_patch.png": "69d3f0ca6445e01ca42304e3d717d569",
"assets/assets/images/patches/iron_patch.png": "4dbdc5cd1c63bc71c128b6f407b5c755",
"assets/assets/images/patches/stone_patch.png": "8172857d5cf029bfb02c57fe7a5878ef",
"assets/assets/images/patches/water_patch.png": "2241a267316be064102d99f0e516fc49",
"assets/assets/images/patches/uranium_patch.png": "52c5fdda5b011f12c385353e2dcb6c24",
"assets/assets/images/patches/oil_patch.png": "ae572ac66fd47c0f54e8595661dfde81",
"assets/assets/images/patches/copper_patch.png": "6df3268534067601a5b9240328276dc7",
"assets/assets/fonts/Pixel.ttf": "80520f263d966b867eaf5f8ac5feac0a",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "20570703b54a4b57e2e3e9eeca65753f",
"manifest.json": "93b9088082de1f6e98edca51984431cc",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"firebase-messaging-sw.js": "6a00fdbf820ef5ab93a3f7b5f767256f",
"favicon.ico": "7d5e71d98847316dae878429e3334569",
"version.json": "e7d55f12544d51b8385a2b131fbe472a",
"index.html": "ccef0b9a4d7890fc9c2a399e3df3711c",
"/": "ccef0b9a4d7890fc9c2a399e3df3711c"
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
