'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "117df5251f7b485141b3e673e1769ca2",
"assets/AssetManifest.bin.json": "461b3b66bc1120308ebd0374a4e2e457",
"assets/AssetManifest.json": "bfe525270eafddd1168d44b102556e15",
"assets/assets/classes/as.png": "3d4f165c8530be954e7bf199b078a405",
"assets/assets/classes/ass.png": "a2fde71e7fb1661eaec041b841cb91b3",
"assets/assets/classes/ata.jpg": "0a2a63fdf58558e804a2f3b7ab32e0b7",
"assets/assets/classes/default.bmp": "d07b15a11990b474e0339ac62fece5d6",
"assets/assets/classes/fs.png": "fb1ae55dd257280035edfbe0412a4e46",
"assets/assets/classes/ks.png": "73be1ba89d6829250bec82196a9761ac",
"assets/assets/classes/mage.jpg": "f738673120da5c5fff6b22f621831404",
"assets/assets/classes/ms.png": "70879881dc5b74d891ada984e593a6bd",
"assets/assets/classes/prs.png": "7151d3210354c38fd66da51af3bd604b",
"assets/assets/classes/ps.png": "d71192c03d852852ccb05f082980dcd4",
"assets/assets/classes/ss.png": "8777902f80ca8bde4e73e32cf3fc379b",
"assets/assets/souls/AceroSoul.png": "d9e69fdf4f06707bb344427e5dc65a4e",
"assets/assets/souls/ArhdyraSoul.png": "5c08c0439ff0156a6f8d9db9043025e1",
"assets/assets/souls/ArmaSoul.png": "6528810ffd7a14b852ed07182266b6e0",
"assets/assets/souls/ArmoredBeetleSoul.png": "a648f2181d3bd80820687753791083b2",
"assets/assets/souls/AveliskExplorerSoul.png": "d86bb2950c70ac2d86a91c81455019c7",
"assets/assets/souls/AveliskSSoul.png": "69f54527cdec86afb6683ce4e0cc970f",
"assets/assets/souls/BabelSoul.png": "5fc9506860f9d2ee6c441535933d948a",
"assets/assets/souls/BargonSoul.png": "59dab14f96c6558dd400f5e799d4f5cf",
"assets/assets/souls/BeeDogSoul.png": "7ad1909922a4996467d30db8443784d9",
"assets/assets/souls/BlizzardGiantSoul.png": "397e75127cea2571c63c3a0784c3e406",
"assets/assets/souls/BloodyBumaSoul.png": "870355e002bacd5a5404642f37d66689",
"assets/assets/souls/BloodyKnightSoul.png": "8ec872bb5af86d2b850842f451994091",
"assets/assets/souls/BloodyPrinceSoul.png": "5a9895f2570a1cf73ac0927154e13e1b",
"assets/assets/souls/BumaSoul.png": "8340a4339f464e890b46d0254526b176",
"assets/assets/souls/ChalybsSoul.png": "dca3c74f39421f1c94f4d86b4975b49c",
"assets/assets/souls/ChaosCaraSoul.png": "df37b6f357d00950a475312c602d1d99",
"assets/assets/souls/ColdEyeSoul.png": "1cad2963ffeefd493b2d13f263451a29",
"assets/assets/souls/CryptSoul.png": "8869048aa78adcf50c97e1cae04039d7",
"assets/assets/souls/CyclopsKnightSoul.png": "b52045d7288ec85d2c4957a615f86c2b",
"assets/assets/souls/DarkMageSoul.png": "f15045a30b7026a5020909db6f6a1d13",
"assets/assets/souls/DawlinSoul.png": "5db4c7f5f457104e56a92a6ccef42701",
"assets/assets/souls/DecoySoul.png": "a01a772bbcbe751b2839b12da9b37900",
"assets/assets/souls/DesertGolemSoul.png": "c235d0055fdf63eb87765bd2167eb71f",
"assets/assets/souls/DevilBirdSoul.png": "120962bd9ce673b7f2e2eda1242e8627",
"assets/assets/souls/DevilShySoul.png": "a19f88d1ebfbb6c85d910195f911519d",
"assets/assets/souls/DoomGuardSoul.png": "b9938ed00a731ab454dd1a8dae027e40",
"assets/assets/souls/DoralSoul.png": "efcf412562c16d654cd279a48e6fcf2f",
"assets/assets/souls/DraxosSoul.png": "cc5d26a6ac021784ff6b8e0b788d34dd",
"assets/assets/souls/EganSoul.png": "75f6dcd91f2725324d47906645a39845",
"assets/assets/souls/EliteEngineerSoul.png": "706b786a7e4362cc9dd93bf1f6c21131",
"assets/assets/souls/FigonSoul.png": "b057a489e69babb21703150ac672b2f5",
"assets/assets/souls/FrostSoul.png": "2a5d4dc761f1a9db8c5325fe7d77f04f",
"assets/assets/souls/GhostSoul.png": "c61fbb4c398cfb62022ae6b148657c79",
"assets/assets/souls/GorgoniacSoul.png": "1a31cdb813661fb08f32ac31b8fa8126",
"assets/assets/souls/GorgonSoul.png": "e267018ecc00c9fd1dc3c0761b38e182",
"assets/assets/souls/GreedySoul.png": "36e8997e950bee194fa0ae94b9aa11d3",
"assets/assets/souls/GrotesqueSoul.png": "1b6d2fbadcf5fcd4da36cdecf0790f2c",
"assets/assets/souls/HauntedTreantSoul.png": "4a02b53d8a62bf8045ba5ace2629c10c",
"assets/assets/souls/HauntingPlantSoul.png": "80e1f3dbe9ef07ee82a43fe471d5b9f0",
"assets/assets/souls/HeadcutterSoul.png": "69e94d8d9fba4931fcf00c12403fc839",
"assets/assets/souls/HobgoblinSoul.png": "a24eed63c6770613d22445b13db5992a",
"assets/assets/souls/HongkySoul.png": "470612e21a96547b76ef594050387d8e",
"assets/assets/souls/HopySoul.png": "ffb32546276395572c18b44611be00c6",
"assets/assets/souls/HyperMachineSoul.png": "89bffe400a88a52a1df9a441059b017d",
"assets/assets/souls/IllusionKnightSoul.png": "085b5105980d016c86b6bb8ba62197ba",
"assets/assets/souls/InvaderAssassinSoul.png": "75e5dfca15fb1a7192689df02dc092cb",
"assets/assets/souls/IronFistSoul.png": "19e20b7e72bfc3aecf7d70f594dadceb",
"assets/assets/souls/KingHopySoul.png": "31ddfe3b3c53611006b209665c7027ab",
"assets/assets/souls/LeechSoul.png": "743e142d18e9eee55a9629ba733d0e99",
"assets/assets/souls/LizardChemistSoul.png": "3fb977fc38010a682a440c9f8755b2fc",
"assets/assets/souls/LizardElderSoul.png": "8845234acffedcac44674c9ac4c796bd",
"assets/assets/souls/LizardScoutSoul.png": "bd0239ba523480a36a7f6f29172df573",
"assets/assets/souls/MephitSoul.png": "d2833e7bde0a669adbb3baff40bc3992",
"assets/assets/souls/MightyGoblinSoul.png": "bce8563952fbdc04a095f01c4a21d303",
"assets/assets/souls/MinigueSoul.png": "95e268f4e35ad516ade52c6a8f823d10",
"assets/assets/souls/MokovaSoul.png": "51b6759ffab87ae3aa37a48ff6236406",
"assets/assets/souls/MountainSoul.png": "2d67d6b6c9b27e915add9bc0b17281c6",
"assets/assets/souls/MummySoul.png": "fd2c1fe8ac94fda0df0abf40d21c9f1b",
"assets/assets/souls/MutantPlantSoul.png": "19fee59d95da048541baacd1a034bebf",
"assets/assets/souls/MutantRabieSoul.png": "0d54e2394e8b132d620b706cca362855",
"assets/assets/souls/MutantTreeSoul.png": "7f345c12cd8e35eb03fad23526f4b85a",
"assets/assets/souls/OmicronSoul.png": "249e4ad6f4206ab7c8e6153a05ec3dc6",
"assets/assets/souls/PrimalGolemSoul.png": "256126c97fab9d0bf06b0cddab42ed20",
"assets/assets/souls/RabieSoul.png": "f4beb0ba6f19cc9bbe79812b11713d26",
"assets/assets/souls/RampageSoul.png": "409b91b75b1c4ff95c411abe19a731bc",
"assets/assets/souls/RatooSoul.png": "132d03c54b9708d6b912ccc42f1884b2",
"assets/assets/souls/RedScorpionSoul.png": "1ea1dc6717f601afb862b6af4ed63eef",
"assets/assets/souls/ReptileWarlordSoul.png": "a0c1f6c2c2815a5f7609f2f4e84ba1b6",
"assets/assets/souls/RucaSoul.png": "24d11fe2cec012fabfe44de8b09448ae",
"assets/assets/souls/SathlaSoul.png": "8f980ffe6835926378ad9fe639a42c34",
"assets/assets/souls/ScorpionSoul.png": "eb2aece90de1cdccb6dae46e90ba1ca2",
"assets/assets/souls/SenSoul.png": "0318566c85aa7fa05b81650cf9e88dc3",
"assets/assets/souls/SetoSoul.png": "d1ad1429c8410907c6aa818c835d7ec0",
"assets/assets/souls/ShadowSoul.png": "ea18480bf3e2b459ec227fd62b72ad4c",
"assets/assets/souls/SkillmasterEadricSoul.png": "16022a37dd803e2c2df59f287188307e",
"assets/assets/souls/SlaughterSoul.png": "77048ae75c8696143e3682c82226338d",
"assets/assets/souls/StoneGolemSoul.png": "2559384f497c4a09cb5bea75ada08693",
"assets/assets/souls/StygianSoul.png": "c4943391cadad7cee45c169944e875ba",
"assets/assets/souls/TobieSoul.png": "e7d96985c3d9fff1452adaf22bcc8c38",
"assets/assets/souls/TullaSoul.png": "701312e4e32469d7694af5ec98621251",
"assets/assets/souls/UndeadGrevenSoul.png": "5f2e276f7fa6e6c6bb6b3c2a745b75cd",
"assets/assets/souls/UndeadKingHopySoul.png": "95dfe5a27aa9d63c5b38a14b65223ea1",
"assets/assets/souls/UndeadMapleSoul.png": "c554ea751512c14e0a14526e2033af3a",
"assets/assets/souls/ValentoSoul.png": "1b5cdb28e3be0995a44a1c7c28562cb0",
"assets/assets/souls/VaultGhostSoul.png": "136551715541edaca2e69d0f2ec45f6c",
"assets/assets/souls/VaultGhoulSoul.png": "5a5768e9c1c8333454e345fe9fb528ef",
"assets/assets/souls/VaultGuardSoul.png": "50f92cb950efe178f45f1d75fa762d17",
"assets/assets/souls/VaultKnightSoul.png": "baf2d309172b49899ec457f1760e55e0",
"assets/assets/souls/VaultMageSoul.png": "14c171b54516c2fc897e2a0e9dc857fa",
"assets/assets/souls/VaultMummySoul.png": "b811e2e5806227198fd4a5d9521d4dbe",
"assets/assets/souls/VaultNightmareSoul.png": "a979e2c2b2c86a15fa43a4ae75021add",
"assets/assets/souls/VaultRangerSoul.png": "9b5a46837be1df23cf3838b31eb7fcd4",
"assets/assets/souls/VaultSkeletonSoul.png": "1816c888be58534787d3ac65896331f0",
"assets/assets/souls/VaultStygianSoul.png": "4b655708b191cf38ad89a1aed3d5970f",
"assets/assets/souls/VaultWarriorSoul.png": "a0fd896b999b4f8942cccdb52fe1534f",
"assets/assets/souls/VengefulSaintSoul.png": "94e9974364b0f3cf9f7282fdfaa92c64",
"assets/assets/souls/WildGoblinSoul.png": "1d59986809b2be2a796c0f1327db586f",
"assets/assets/souls/WitchSoul.png": "3c55c7436dcc5c2f5a3d8eb09bdb7d79",
"assets/assets/souls/XetanSoul.png": "97a422ab5fb2321ca2e075f05aa85a35",
"assets/assets/souls/YagdithaSoul.png": "fdaf6b6183ef1a10729f3fce2ea115ae",
"assets/assets/souls/ZombieSoul.png": "6afaaeaf0d64f93cb3ebc9357f669ab0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e08f97d64da7494bdcb26388c21d17c0",
"assets/NOTICES": "54e7fcaf70cebf1a617931dd72674e2f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "84d23fceda7a009039013bc6a3bb034e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "e41f243ccd75898b15b12e1d13933a39",
"/": "e41f243ccd75898b15b12e1d13933a39",
"main.dart.js": "84ded34d926f6b213d2a6b992562747d",
"manifest.json": "971a628d0a5fabd72cbf31a27249da22",
"version.json": "a0a687d28ec8d40069b4789733595a65"};
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
