# 📱 MindGarden - Сборка для TestFlight

## Инструкции для второго разработчика (iOS)

---

## 🔧 Требования

- macOS с установленным Xcode 15+
- Flutter SDK 3.16+
- Apple Developer аккаунт
- Доступ к App Store Connect

---

## 📋 Шаг 1: Клонирование проекта

```bash
git clone https://github.com/gahshsfshsh/mindgarden.git
cd mindgarden/mobile
```

---

## 📋 Шаг 2: Установка зависимостей Flutter

```bash
# Проверка Flutter
flutter doctor

# Установка пакетов
flutter pub get
```

---

## 📋 Шаг 3: Настройка iOS проекта

```bash
cd ios

# Установка CocoaPods зависимостей
pod install

# Если ошибка, попробуй:
pod repo update
pod install --repo-update

cd ..
```

---

## 📋 Шаг 4: Настройка API URL (опционально)

Для переключения между серверами отредактируй файл:
`lib/core/config/app_config.dart`

```dart
// Для DEV сервера:
static const String apiUrl = devApiUrl;  // 188.68.223.230:3000

// Для STAGING:
static const String apiUrl = stagingApiUrl;  // 158.255.6.22:7000
```

---

## 📋 Шаг 5: Открытие в Xcode

```bash
open ios/Runner.xcworkspace
```

**ВАЖНО:** Открывай именно `.xcworkspace`, не `.xcodeproj`!

---

## 📋 Шаг 6: Настройка подписи в Xcode

1. В Xcode выбери **Runner** в навигаторе проекта
2. Перейди на вкладку **Signing & Capabilities**
3. Выбери свою **Team** (Apple Developer аккаунт)
4. Убедись что **Bundle Identifier** = `com.mindgarden.app`
5. Xcode автоматически создаст provisioning profile

---

## 📋 Шаг 7: Сборка Release версии

### Через командную строку (рекомендуется):

```bash
cd /path/to/mindgarden/mobile

# Очистка
flutter clean
flutter pub get

# Сборка iOS Release
flutter build ios --release
```

### Через Xcode:

1. Выбери **Product** → **Scheme** → **Runner**
2. Выбери **Any iOS Device (arm64)** в качестве destination
3. **Product** → **Archive**

---

## 📋 Шаг 8: Загрузка в TestFlight

### Автоматически (Xcode Organizer):

1. После Archive откроется **Organizer**
2. Выбери архив и нажми **Distribute App**
3. Выбери **App Store Connect**
4. Выбери **Upload**
5. Оставь настройки по умолчанию
6. Нажми **Upload**

### Через командную строку:

```bash
# Сборка IPA
flutter build ipa --release

# Загрузка через altool
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/mindgarden.ipa \
  --username "your@apple.id" \
  --password "@keychain:AC_PASSWORD"
```

---

## 📋 Шаг 9: Настройка в App Store Connect

1. Открой [App Store Connect](https://appstoreconnect.apple.com)
2. Перейди в **My Apps** → **MindGarden** (или создай новое)
3. Вкладка **TestFlight**
4. Дождись обработки билда (5-15 минут)
5. Нажми на билд → **Manage Compliance** → Выбери "None of the above"
6. Добавь **Test Information** (что тестировать)
7. Добавь тестеров в **Internal Testing** или **External Testing**

---

## ⚠️ Частые проблемы

### Pod install failed
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install --repo-update
```

### Code signing issues
- Убедись что выбрана правильная Team в Xcode
- Проверь что Bundle ID уникален

### Flutter build failed
```bash
flutter clean
rm -rf build
flutter pub get
flutter build ios --release
```

### Archive не появляется
- Убедись что выбран **Any iOS Device**, не симулятор
- Проверь что схема Release, не Debug

---

## 🔗 Полезные ссылки

- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer](https://developer.apple.com)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

---

## 📊 Текущие API серверы

| Окружение | URL | Использование |
|-----------|-----|---------------|
| DEV | http://188.68.223.230:3000 | Тестирование |
| STAGING | http://158.255.6.22:7000 | Предпродакшн |

---

## 📝 Чек-лист перед загрузкой

- [ ] Bundle ID = com.mindgarden.app
- [ ] Version увеличен (2.1.0)
- [ ] Build number увеличен (2)
- [ ] API URL указывает на правильный сервер
- [ ] Нет debug баннера (убери showDebugBanner в конфиге)
- [ ] Иконка приложения добавлена
- [ ] Launch screen настроен

