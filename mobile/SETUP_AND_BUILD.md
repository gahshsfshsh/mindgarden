# MindGarden - Инструкция по развёртыванию

## 📋 Требования

- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0
- Android Studio (для Android)
- Xcode (для iOS/TestFlight)
- CocoaPods (для iOS)

## 🔧 Первоначальная настройка

### 1. Получить зависимости

```bash
cd D:\YOGA\mobile
flutter clean
flutter pub get
```

### 2. Проверить окружение

```bash
flutter doctor
```

Убедитесь, что нет критических ошибок.

---

## 📱 Android (Android Studio)

### Сборка Debug APK

```bash
flutter build apk --debug
```

### Сборка Release APK

```bash
flutter build apk --release
```

APK будет в: `build/app/outputs/flutter-apk/app-release.apk`

### Сборка App Bundle (для Google Play)

```bash
flutter build appbundle --release
```

Bundle будет в: `build/app/outputs/bundle/release/app-release.aab`

### Открыть в Android Studio

1. Откройте Android Studio
2. File → Open → Выберите `D:\YOGA\mobile\android`
3. Дождитесь синхронизации Gradle
4. Run → Run 'app'

---

## 🍎 iOS (TestFlight)

### 1. Установить CocoaPods (если не установлен)

```bash
sudo gem install cocoapods
```

### 2. Установить iOS зависимости

```bash
cd D:\YOGA\mobile\ios
pod install --repo-update
cd ..
```

### 3. Сборка IPA

```bash
flutter build ipa --release
```

IPA будет в: `build/ios/ipa/`

### 4. Загрузка в TestFlight

**Вариант A: Через Transporter**
1. Откройте Transporter (App Store)
2. Добавьте IPA файл
3. Загрузите

**Вариант B: Через Xcode**
1. Откройте `ios/Runner.xcworkspace` в Xcode
2. Product → Archive
3. Distribute App → App Store Connect

---

## 🔑 Конфигурация

### API URL

Файл: `lib/core/config/app_config.dart`

```dart
// Для разработки:
static const String apiUrl = devApiUrl;  // http://188.68.223.230:3000

// Для продакшена:
static const String apiUrl = productionApiUrl;  // https://api.mindgarden.app
```

---

## ❓ Решение проблем

### Ошибки зависимостей

```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Android Gradle ошибки

```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

### iOS CocoaPods ошибки

```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

### Если файлы красные в IDE

1. Закройте IDE
2. Выполните `flutter pub get`
3. Откройте проект заново

---

## 📦 Структура проекта

```
mobile/
├── lib/
│   ├── main.dart              # Точка входа
│   ├── core/                  # Общие компоненты
│   │   ├── config/            # Конфигурация
│   │   ├── models/            # Модели данных
│   │   ├── router/            # Навигация (go_router)
│   │   ├── services/          # API сервисы
│   │   ├── theme/             # Тема и цвета
│   │   └── widgets/           # Общие виджеты
│   └── features/              # Функционал по модулям
│       ├── ai_chat/           # AI чат
│       ├── auth/              # Авторизация
│       ├── breathing/         # Дыхательные практики
│       ├── cbt/               # CBT упражнения
│       ├── home/              # Главный экран
│       ├── meditation/        # Медитации
│       ├── mood/              # Трекер настроения
│       ├── onboarding/        # Онбординг
│       ├── player/            # Аудио плеер
│       ├── profile/           # Профиль
│       ├── progress/          # Прогресс
│       ├── sleep/             # Сон
│       ├── subscription/      # Подписка
│       └── yoga/              # Йога
├── android/                   # Android конфигурация
├── ios/                       # iOS конфигурация
├── assets/                    # Ресурсы (изображения, аудио)
└── pubspec.yaml              # Зависимости
```

---

## 🚀 Быстрый старт

```bash
# Одной командой
cd D:\YOGA\mobile && flutter clean && flutter pub get && flutter run
```

