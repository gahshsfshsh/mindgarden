# 🚀 Деплой ZenFlow на Vercel

## Предварительные требования

1. Аккаунт на [Vercel](https://vercel.com)
2. Установленный [Vercel CLI](https://vercel.com/cli): `npm i -g vercel`
3. Аккаунт на [Stripe](https://stripe.com) для платежей

---

## 1️⃣ Настройка Vercel Postgres

1. Откройте [Vercel Dashboard](https://vercel.com/dashboard)
2. Выберите "Storage" → "Create Database" → "Postgres"
3. Скопируйте `POSTGRES_URL` из настроек базы

---

## 2️⃣ Деплой Backend (Python API)

```bash
cd backend

# Войти в Vercel
vercel login

# Деплой
vercel --prod
```

### Переменные окружения для Backend:

В Vercel Dashboard → Settings → Environment Variables добавьте:

```
POSTGRES_URL=postgresql://...
JWT_SECRET=ваш-секретный-ключ-32-символа
STRIPE_SECRET_KEY=sk_live_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx
STRIPE_PRICE_PREMIUM=price_xxx
STRIPE_PRICE_LIFETIME=price_yyy
FRONTEND_URL=https://zenflow.vercel.app
```

### Заполнение базы контентом:

```bash
cd backend
python seed_content.py
```

---

## 3️⃣ Деплой Landing (Next.js)

```bash
cd landing

# Установить зависимости
npm install

# Деплой
vercel --prod
```

Или подключите репозиторий напрямую:
1. Vercel Dashboard → New Project
2. Import Git Repository
3. Root Directory: `landing`
4. Framework: Next.js

---

## 4️⃣ Настройка Stripe

### Создание продуктов:

1. Stripe Dashboard → Products → Add Product
2. Создайте "Premium Monthly" (490₽/месяц) - получите `price_xxx`
3. Создайте "Lifetime" (4990₽ один раз) - получите `price_yyy`

### Настройка Webhook:

1. Stripe Dashboard → Developers → Webhooks
2. Add endpoint: `https://your-api.vercel.app/api/webhook/stripe`
3. Выберите события: `checkout.session.completed`, `customer.subscription.*`
4. Скопируйте Signing secret в `STRIPE_WEBHOOK_SECRET`

---

## 5️⃣ Сборка Flutter приложения

### Android:

```bash
cd mobile
flutter build apk --release
```

APK файл: `mobile/build/app/outputs/flutter-apk/app-release.apk`

### iOS (только на macOS):

```bash
flutter build ios --release
```

Откройте `ios/Runner.xcworkspace` в Xcode для публикации в App Store.

---

## 📋 Чек-лист деплоя

- [ ] Создана Vercel Postgres база
- [ ] Backend задеплоен на Vercel
- [ ] Переменные окружения настроены
- [ ] База заполнена контентом
- [ ] Landing задеплоен на Vercel
- [ ] Stripe продукты созданы
- [ ] Stripe webhook настроен
- [ ] Flutter APK собран
- [ ] Домен привязан (опционально)

---

## 🔗 Финальные URL

После деплоя у вас будут:

- **Landing**: `https://zenflow.vercel.app`
- **API**: `https://zenflow-api.vercel.app`
- **API Docs**: `https://zenflow-api.vercel.app/docs`

---

## 🆘 Поддержка

При проблемах проверьте:
1. Логи в Vercel Dashboard → Deployments → Functions
2. Stripe Dashboard → Developers → Logs
3. Переменные окружения корректны


