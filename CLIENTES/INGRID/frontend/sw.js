// Service Worker — Sedes-DF 2026 Ingrid
const CACHE = "sedes-df-v14";
const BASE   = "/vanguard/";
const STATIC = [BASE, BASE + "index.html", BASE + "app.js?v=13", BASE + "style.css?v=13", BASE + "manifest.json"];

self.addEventListener("install", (e) => {
  // Tenta pré-cachear, mas não bloqueia o install se algum asset falhar
  e.waitUntil(
    caches.open(CACHE).then((c) => c.addAll(STATIC).catch(() => {}))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (e) => {
  e.waitUntil(caches.keys().then((keys) =>
    Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
  ));
  self.clients.claim();
});

self.addEventListener("fetch", (e) => {
  if (e.request.url.includes("supabase.co")) return;

  // Navegações HTML: sempre rede primeiro — garante que novos deploys chegam imediatamente
  if (e.request.mode === "navigate") {
    e.respondWith(
      fetch(e.request).catch(() => caches.match(BASE + "index.html"))
    );
    return;
  }

  // Assets estáticos (JS, CSS): cache-first com fallback de rede
  e.respondWith(
    caches.match(e.request).then((cached) => cached ?? fetch(e.request))
  );
});
