# 🚀 Инструкции по деплою MindGarden

## 1. Деплой Backend на сервер (SSH)

### Подключение к серверу

```bash
ssh alexei@158.255.6.22
```

### Первоначальная установка (один раз)

```bash
# Обновляем систему
sudo apt update && sudo apt upgrade -y

# Устанавливаем необходимые пакеты
sudo apt install -y python3.11 python3.11-venv python3-pip git nginx certbot python3-certbot-nginx

# Клонируем репозиторий
cd /home/alexei
git clone https://github.com/gahshsfshsh/mindgarden.git
cd mindgarden/backend

# Создаём виртуальное окружение
python3.11 -m venv venv
source venv/bin/activate

# Устанавливаем зависимости
pip install -r requirements.txt

# Создаём .env файл
cp ENV_TEMPLATE.txt .env
nano .env  # Заполняем переменные

# Наполняем базу данных
python seed_content.py

# Создаём systemd сервис
sudo nano /etc/systemd/system/mindgarden.service
```

### Содержимое mindgarden.service:

```ini
[Unit]
Description=MindGarden API
After=network.target

[Service]
User=alexei
Group=alexei
WorkingDirectory=/home/alexei/mindgarden/backend
Environment="PATH=/home/alexei/mindgarden/backend/venv/bin"
ExecStart=/home/alexei/mindgarden/backend/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Запуск сервиса:

```bash
sudo systemctl daemon-reload
sudo systemctl enable mindgarden
sudo systemctl start mindgarden
sudo systemctl status mindgarden
```

### Настройка Nginx (reverse proxy):

```bash
sudo nano /etc/nginx/sites-available/mindgarden
```

Содержимое:
```nginx
server {
    listen 80;
    server_name api.mindgarden.app 158.255.6.22;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/mindgarden /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### SSL сертификат (если есть домен):

```bash
sudo certbot --nginx -d api.mindgarden.app
```

---

## 🔄 Обновление бэкенда (при новых изменениях)

```bash
ssh alexei@158.255.6.22
cd /home/alexei/mindgarden
git pull origin main
cd backend
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart mindgarden
```

### Одной командой:

```bash
ssh alexei@158.255.6.22 "cd /home/alexei/mindgarden && git pull && cd backend && source venv/bin/activate && pip install -r requirements.txt && sudo systemctl restart mindgarden"
```

---

## 2. Сборка iOS для TestFlight (для второго разработчика)

### Требования:
- macOS с установленным Xcode (14.0+)
- Apple Developer Account
- Flutter SDK 3.16+

### Шаги:

```bash
# 1. Клонируем репозиторий
git clone https://github.com/gahshsfshsh/mindgarden.git
cd mindgarden/mobile

# 2. Устанавливаем зависимости Flutter
flutter pub get

# 3. Обновляем API URL для продакшена
# Открыть lib/core/services/api_service.dart
# Изменить baseUrl на: 'http://158.255.6.22:8000' или ваш домен

# 4. Переходим в iOS папку
cd ios

# 5. Устанавливаем CocoaPods зависимости
pod install --repo-update

# 6. Открываем в Xcode
open Runner.xcworkspace
```

### В Xcode:

1. **Signing & Capabilities:**
   - Выберите Team (ваш Apple Developer Account)
   - Bundle Identifier: `com.mindgarden.app` (или свой)
   - Выберите Provisioning Profile

2. **Изменить версию:**
   - Target → Runner → General
   - Version: `3.0.0`
   - Build: увеличьте на 1

3. **Архивирование:**
   - Product → Scheme → Edit Scheme → Archive → Release
   - Product → Archive
   - Дождитесь завершения

4. **Загрузка в TestFlight:**
   - Window → Organizer
   - Выберите архив → Distribute App
   - App Store Connect → Upload
   - Следуйте инструкциям

### Альтернативно через командную строку:

```bash
# Сборка iOS release
cd /path/to/mindgarden/mobile
flutter build ios --release

# Архивирование
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  archive \
  -archivePath build/Runner.xcarchive

# Экспорт IPA
xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist ExportOptions.plist

# Загрузка в App Store Connect
xcrun altool --upload-app \
  -f build/ipa/Runner.ipa \
  -t ios \
  -u "your-apple-id@email.com" \
  -p "app-specific-password"
```

---

## 3. Сборка Android для внутреннего тестирования

```bash
cd /path/to/mindgarden/mobile

# Обновить API URL в lib/core/services/api_service.dart

# Сборка APK
flutter build apk --release

# APK будет в: build/app/outputs/flutter-apk/app-release.apk

# Или App Bundle для Google Play
flutter build appbundle --release
# AAB будет в: build/app/outputs/bundle/release/app-release.aab
```

---

## 4. Переменные окружения для бэкенда (.env)

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/mindgarden
# или для SQLite
# DATABASE_URL=sqlite:///./mindgarden.db

# Security
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters

# OpenAI (обязательно для AI чата)
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxx

# Payments (опционально)
YUKASSA_SHOP_ID=your-shop-id
YUKASSA_SECRET_KEY=your-secret-key
STRIPE_SECRET_KEY=sk_live_xxxxx
```

---

## 5. Проверка работы

После деплоя проверьте:

```bash
# Статус API
curl http://158.255.6.22:8000/

# Health check
curl http://158.255.6.22:8000/health

# Документация API
# Откройте в браузере: http://158.255.6.22:8000/docs
```

---

## 📱 Контакты

**GitHub:** https://github.com/gahshsfshsh/mindgarden
**API:** http://158.255.6.22:8000

---

Made with 💚 by MindGarden Team
