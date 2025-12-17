# ZenFlow Backend

Python FastAPI backend с Vercel Postgres.

## Быстрый старт

```bash
# Создать виртуальное окружение
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Установить зависимости
pip install -r requirements.txt

# Настроить переменные окружения
cp .env.example .env
# Отредактировать .env с вашими ключами

# Запустить сервер
uvicorn main:app --reload
```

## API Документация

После запуска откройте:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Endpoints

### Auth
- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Авторизация
- `GET /api/auth/me` - Текущий пользователь

### Content
- `GET /api/content` - Список контента
- `GET /api/content/{id}` - Контент по ID
- `GET /api/content/categories/{type}` - Категории

### Progress
- `GET /api/progress` - Прогресс пользователя
- `POST /api/progress/session` - Записать сессию
- `GET /api/progress/achievements` - Достижения

### Subscription
- `POST /api/subscription/checkout` - Создать оплату

## Deploy на Vercel

1. Подключить Vercel Postgres в Dashboard
2. Скопировать POSTGRES_URL в переменные окружения
3. Деплой:

```bash
vercel --prod
```


