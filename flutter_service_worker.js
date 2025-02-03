'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "b77f757a9bf886086d7a9dce93353c03",
".git/config": "4e74ec9d034eb8dc4a53ce58c8ebcf46",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "2d7a2142ea166794c1f062640de702cb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "9cec8e861269054ffeb8f219e4875a97",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "17e3694e479a9857da96d8ebf778b39a",
".git/logs/refs/heads/janu": "f03b288060ee92466c6937a1ea47ea79",
".git/logs/refs/heads/main": "e85502ed892c2626458b3a7a7a4b39fd",
".git/logs/refs/remotes/origin/janu": "fed1c8ec0fa673e37d60386fd74e43ed",
".git/logs/refs/remotes/origin/main": "73988b214b3d84efdc0d3db18a0e0b44",
".git/objects/05/a9058f513cce5faf1704e06e3c150688b0a01f": "e8d02f60cf87abd4c1de4b153dd696dc",
".git/objects/05/e5d2f616f716d3ddccb4aac3761f4cd247a49c": "e4f43e9fa6387a1e137b70afa1976cf5",
".git/objects/11/00a3a52a10e56cce2cada6564a6491bea9eb16": "0bacf78399e43cecc9ba7b1ca9a61c80",
".git/objects/1e/0555cc29e23ff392c054b26d4494f6a3cb6088": "d146c0ee08d196c9e63be3e3466235fd",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/23/59fb49aa1b95cf472da713665291e458e0077a": "dc168072ed27d012c74c35602f9cf45b",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/27/a297abdda86a3cbc2d04f0036af1e62ae008c7": "51d74211c02d96c368704b99da4022d5",
".git/objects/37/f15c6a8d3e3fc6efedeee1f1b227c508e09c38": "633038bcadce5a8406241ececf27a878",
".git/objects/45/981cabe7d6a0213ec9936b423c220a5fcdc1f2": "b2b6cf0b641baee65a2ea29b93d5692e",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4c/5f2818061cca0b128495bf98108e0e677d7eac": "598b72dea878babfec614634f4235844",
".git/objects/4d/76d9941f47309fcfcd6e0abf8f6b3165f7e393": "8bc8abb4d18c88951696d5f43c51b4d2",
".git/objects/4e/d1d727746dfa7d5c4ec9fa70044cb3d7416304": "f44ee6faf27bfab5f3a5c554862c7c02",
".git/objects/4f/c10de20101dce8c9b7d26b698a5f129efa0f6c": "9137d7c4f42b4530027064dc49a9da92",
".git/objects/52/4a3f3a5b21478a368b32567bb4f63097ff16b2": "8707ded0702adbf4d67cb8704044021b",
".git/objects/54/e3ff7ae08caf08f6f2690d211b748d0840df4e": "c3e8b63706b8891ce7e6fd34d5012c67",
".git/objects/5c/4302e500a1a3e38540341424a28dd69c3efe3b": "daa546496165cebb2a74d6c5b6b6e3b5",
".git/objects/5c/85eac1fc1a5baa0fbfcee273ff0e88b47d32ed": "b362bd06a62f4cdf615d5fc55d2be61a",
".git/objects/63/6931bcaa0ab4c3ff63c22d54be8c048340177b": "8cc9c6021cbd64a862e0e47758619fb7",
".git/objects/64/a9ffa331ea86bb08b3d58e590b9d23b0f37256": "ba8f47fbaf19df485e84f417a4e4278f",
".git/objects/69/6fd648321ead298284d61fe9dc1c4f3e3f1f76": "3878a42dbf96f13cdd1be4056d2c7e34",
".git/objects/6a/83e21c2504bee26b52580c9480374fdb20c449": "6831f61b63e3071ebf2be2fb8df631b3",
".git/objects/6d/5f0fdc7ccbdf7d01fc607eb818f81a0165627e": "2b2403c52cb620129b4bbc62f12abd57",
".git/objects/6f/33e6f08571f30ebe00ff45c167b7962f544def": "41680f2300567b164303df0cb01efd57",
".git/objects/6f/393029b037c22a64f38776eeb250f86cfb0efc": "f24e62d185a36f407c2fddc5450b8107",
".git/objects/73/7f149c855c9ccd61a5e24ce64783eaf921c709": "1d813736c393435d016c1bfc46a6a3a6",
".git/objects/77/0ec3ba2df5a56cff045552445c583cd8f472d0": "255ba6f368e2e60ac914b3c992f51f40",
".git/objects/82/2552183fa5b4891151e5030f019cad2850a837": "70ddd455ffb80e8f50f083090dc0dfa0",
".git/objects/82/674aa25a5d83dd2469a8324f1d866dc2f0fc3e": "9cd06fb6e9bc33048967a1ab01eb14d9",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/87/0ff47efba21a7e6e4540a85398f8bd2d292e34": "a0e8dbfe1a51973ca9dfa89f196f5277",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/7afadaab067a893fdfb635fa2dbb0c0bda7dfe": "c83362d625aeeefd948d1b1076e814b0",
".git/objects/8a/8b36a429699a47a94622b95a7a622cd9897650": "8d3e706a2f016dbef07f4c3a175888ef",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/59773bee8314a8ffb4431593d0fb49f52e34c6": "2eb993d30677573ffd0e58484cc6a514",
".git/objects/8c/c47905ee15d10d78419af41003480568b5a27c": "3b37decf12edef863fd5ebe646ed5c7c",
".git/objects/8c/d5598b492632e4de7f4f2652fa3859d630c93f": "75bb939c547c025631008100e64883df",
".git/objects/8c/d83e4eac67819d64dd4900e058f94833d7d79b": "69494721172a71fd8d18fa54282146f8",
".git/objects/97/8a4d89de1d1e20408919ec3f54f9bba275d66f": "dbaa9c6711faa6123b43ef2573bc1457",
".git/objects/99/186c77b33e49d01d73cc3d5d9547795769f1b8": "5c023ca9de62a19636635d8231befc42",
".git/objects/9d/5ac69bfeb7b9b1990fdd10b218c41c276c485e": "f6bcd9acfe79d204658e3bb69939567b",
".git/objects/9d/79c86fa4815cf97f92ca8538c245382adeba1f": "2e1f832750529dbf06f673c9f15fd54c",
".git/objects/9e/606207d32b0363b59bcba2afcfb7de7ac2154f": "c67b4556b734f2c4d9fc14af42ff19af",
".git/objects/9e/ab13904b7cd9fe05f4e2bc376d76976664d691": "88d3d2b8a69da03e619ba010f93b02ab",
".git/objects/9f/3ef956f489f8e52f2c216bc81fd5fbf0135dbe": "5871d2a48e1505fa2898e8e3e4b09e9f",
".git/objects/9f/7dad082da7e9811b58e6caae352f91fab86ecf": "f8bf69b506929cdbcbed8b274b7a6d61",
".git/objects/a8/3e00b2a6c9adcb8cde74650a874f8fb0635ae0": "0f8a7a2a2cd62a7a3f01d5f9974f24da",
".git/objects/ac/33745d191f233180ce9f5b85068c74edf64ef1": "863aaa34723050cb620d6447b2cef5e3",
".git/objects/af/31ef4d98c006d9ada76f407195ad20570cc8e1": "a9d4d1360c77d67b4bb052383a3bdfd9",
".git/objects/b0/135f5432ee8dd06eae9941a7839cb8788441fc": "51382dbbecf83267d380fb83008b83be",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/afd5429fbe3cc7a88b89f454006eb7b018849a": "e4c2e016668208ba57348269fcb46d7b",
".git/objects/b5/f856c502e10c94255886e2cc850156d8342f82": "a39d54bfb838cb1f35917e342e0653f6",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b8/48a8ac5ea5c48f59f2d4b1d3bb07e38ecd933a": "afd4f08f043e8dee747202b26425c983",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/c3/6e44af39ee138a89d9353041aced91b3788a14": "6f1f84981b64e726ca697f4d7257aa24",
".git/objects/c3/e81f822689e3b8c05262eec63e4769e0dea74c": "8c6432dca0ea3fdc0d215dcc05d00a66",
".git/objects/c5/d140ef394abed89f7d64103b166d1da162e0a9": "0cbf4a827af445f6e533135a28560384",
".git/objects/c6/06caa16378473a4bb9e8807b6f43e69acf30ad": "ed187e1b169337b5fbbce611844136c6",
".git/objects/d0/0657e7de6eca1f9b67613efa0ec3827c9a0685": "104c2dc1a86555348f10bc82123d6a72",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/2085ca96b166e4e191d840e5dc5ea035d6491e": "5d4455eb72f7a98a36a34ec2b7ec2dc5",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/df/c19eb5a5f2ea0472763f4516914767bbaf921e": "315e2a127382bee5491a8d730f6a2e20",
".git/objects/e6/2ab94f228df434768646177b19a9a1a78425e8": "bb7b9fd340253decd09a50bfcaf045f9",
".git/objects/e7/8220f0c69d5abeeaed7bab0d5256ae65777e2a": "0dad5773d89013079cd0927614a35460",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ec/361605e9e785c47c62dd46a67f9c352731226b": "d1eafaea77b21719d7c450bcf18236d6",
".git/objects/f0/0e828a49e5a25512ee3b5736b2dc88debed107": "67baac20e786bb73dbf84677bbe7945e",
".git/objects/f0/18ece7bc156178c5e2a91c367068620d1ab002": "e7eb7dbcbf0633734d1746c329d4532a",
".git/objects/f1/0576b65da36e53623b9cc048086a21a48300bd": "cc65443300c21d06afaadfd18e72bda9",
".git/objects/f1/e8c82063c30a80c28f2ac566646892253224f1": "783156d168784552760d20f3ead6297c",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/45fb59ca37352ae42a7e08e798a50d4dc16e03": "02f8b592ee41cea345723d205821bff8",
".git/objects/f4/7649b93e3076870521813a2be87a07ea3eff76": "46bf36af08869ea0f578e4e78c337d1e",
".git/objects/f7/247089c3f22ebc8fbf3d05b1df566ae1dbed78": "718cb6bbd68494cfa42041753fd3e273",
".git/objects/ff/574c135eb348cd69f542442de772c1fe31597d": "4cb406f3a5f538d4b22ede077d29b282",
".git/refs/heads/janu": "56bd2dd55043383289f29d1d013b2a58",
".git/refs/heads/main": "77af0de92edf59297605aee68c889387",
".git/refs/remotes/origin/janu": "56bd2dd55043383289f29d1d013b2a58",
".git/refs/remotes/origin/main": "77af0de92edf59297605aee68c889387",
"assets/AssetManifest.bin": "8b08c93288e43046788bff2052ef4bf6",
"assets/AssetManifest.bin.json": "f24fe0e490c0ddc88a5db2843fc0a9ee",
"assets/AssetManifest.json": "c8371ba8b1af07aca433e71586ac3e8d",
"assets/assets/img/google.png": "ad20ae1d7f4bb5179cba8e6961e2dbdb",
"assets/assets/img/logout_icon.png": "33e4ca10e7334ff0d2cdd7c58a8c130d",
"assets/assets/img/quickrun.jpeg": "6fcc53f0f2cdc8cdcfd641fdaec1b9df",
"assets/assets/img/quickrunez8.jpg": "50565144da98519c11ef3f357488575d",
"assets/assets/img/register_icon.png": "9459e0a86a11b236c638c5d39367daa7",
"assets/assets/img/signin_icon.png": "70e4e34805f3a64434cdb99d680c92d9",
"assets/assets/img/sound.mp3": "bbb079062f250d6cad998380281c3a4f",
"assets/assets/img/whatsapp.png": "552af89ecf257d6df46fa89968e43d1f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "04453a276c1b9aef959372a2652b2572",
"assets/NOTICES": "a732e825cea75bedd41fa1ab9b605082",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "eb51f90ca1ee0ede8c087d50cb2efba2",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "f1f3a368804162f257290ebf6e450f08",
"/": "f1f3a368804162f257290ebf6e450f08",
"main.dart.js": "e457613c310a88509f487e2216193689",
"manifest.json": "48ce1fe8cc5920bb918c274dc2add609",
"version.json": "d60fb2368e92ce166a85b00b9ba112eb"};
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
