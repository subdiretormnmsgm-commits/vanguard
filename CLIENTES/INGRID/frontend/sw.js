// Service Worker — Sedes-DF 2026 Ingrid
const CACHE = "sedes-df-v12";
const STATIC = ["/", "/index.html", "/app.js", "/style.css", "/manifest.json"];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(STATIC)));
  self.skipWaiting();
});

self.addEventListener("activate", (e) => {
  e.waitUntil(caches.keys().then((keys) =>
    Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
  ));
  self.clients.claim();
});

self.addEventListener("fetch", (e) => {
  // Requisicoes para a API Supabase: sempre busca na rede
  if (e.request.url.includes("supabase.co")) return;
  e.respondWith(
    caches.match(e.request).then((cached) => cached ?? fetch(e.request))
  );
});
