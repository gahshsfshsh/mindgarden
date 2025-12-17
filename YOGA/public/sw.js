// 🔔 Service Worker для Push-уведомлений и офлайн-режима

const CACHE_NAME = 'zenflow-v1';
const urlsToCache = [
  '/',
  '/offline.html',
  '/icon-192.png',
  '/icon-512.png',
];

// Установка Service Worker
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});

// Активация
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

// Обработка fetch запросов (офлайн-режим)
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Возвращаем из кэша или делаем сетевой запрос
        return response || fetch(event.request);
      })
      .catch(() => {
        // Если офлайн и нет в кэше, показываем offline.html
        return caches.match('/offline.html');
      })
  );
});

// Обработка Push-уведомлений
self.addEventListener('push', (event) => {
  const data = event.data ? event.data.json() : {};
  
  const title = data.title || 'ZenFlow';
  const options = {
    body: data.body || 'Новое уведомление',
    icon: data.icon || '/icon-192.png',
    badge: '/badge-72.png',
    vibrate: [200, 100, 200],
    data: data.url || '/',
    actions: data.actions || [
      { action: 'open', title: 'Открыть' },
      { action: 'close', title: 'Закрыть' },
    ],
  };

  event.waitUntil(
    self.registration.showNotification(title, options)
  );
});

// Обработка кликов по уведомлениям
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  if (event.action === 'close') {
    return;
  }

  const urlToOpen = event.notification.data || '/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true })
      .then((clientList) => {
        // Если приложение уже открыто, фокусируемся на нём
        for (const client of clientList) {
          if (client.url === urlToOpen && 'focus' in client) {
            return client.focus();
          }
        }
        // Иначе открываем новое окно
        if (clients.openWindow) {
          return clients.openWindow(urlToOpen);
        }
      })
  );
});

// Фоновая синхронизация (для отложенных действий)
self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-progress') {
    event.waitUntil(syncProgress());
  }
});

async function syncProgress() {
  // Синхронизируем прогресс с сервером
  try {
    const response = await fetch('/api/progress/sync', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    });
    return response.ok;
  } catch (error) {
    console.error('Ошибка синхронизации:', error);
    return false;
  }
}





