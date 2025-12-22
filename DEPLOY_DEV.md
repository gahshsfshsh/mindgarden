# 🚀 MindGarden - Деплой на DEV сервер

## Сервер: 188.68.223.230 | Порт: 3000

---

## 📋 БЫСТРЫЙ ДЕПЛОЙ (одна команда)

```bash
ssh user@188.68.223.230 "cd ~ && rm -rf mindgarden && git clone https://github.com/gahshsfshsh/mindgarden.git && cd mindgarden/backend && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && cat > .env << 'EOF'
DATABASE_URL=sqlite:///./mindgarden.db
JWT_SECRET=mindgarden-dev-secret-key-2024
OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE
EOF
python3 seed_content.py && pkill -f 'uvicorn.*3000' 2>/dev/null; nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 3000 > server.log 2>&1 & sleep 3 && curl http://localhost:3000/health"
```

---

## 📝 ПОШАГОВЫЙ ДЕПЛОЙ

### Шаг 1: Подключение к серверу

```bash
ssh user@188.68.223.230
```

### Шаг 2: Клонирование репозитория

```bash
cd ~
rm -rf mindgarden
git clone https://github.com/gahshsfshsh/mindgarden.git
cd mindgarden/backend
```

### Шаг 3: Настройка Python окружения

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Шаг 4: Создание .env файла

```bash
cat > .env << 'EOF'
DATABASE_URL=sqlite:///./mindgarden.db
JWT_SECRET=mindgarden-dev-secret-key-2024
OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE
EOF
```

### Шаг 5: Наполнение базы данных

```bash
python3 seed_content.py
```

### Шаг 6: Запуск сервера на порту 3000

```bash
# Остановить если уже запущен
pkill -f "uvicorn.*3000" 2>/dev/null

# Запустить в фоне
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 3000 > server.log 2>&1 &
```

### Шаг 7: Проверка

```bash
# Локально
curl http://localhost:3000/health

# Извне
curl http://188.68.223.230:3000/health
curl http://188.68.223.230:3000/api/payments/plans
```

---

## ✅ Ожидаемый результат

```json
{"status":"healthy","timestamp":"2025-12-19T..."}
```

---

## 🔧 Управление сервером

### Посмотреть логи
```bash
tail -f ~/mindgarden/backend/server.log
```

### Остановить сервер
```bash
pkill -f "uvicorn.*3000"
```

### Перезапустить
```bash
cd ~/mindgarden/backend
source venv/bin/activate
pkill -f "uvicorn.*3000" 2>/dev/null
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 3000 > server.log 2>&1 &
```

### Обновить код
```bash
cd ~/mindgarden
git pull
cd backend
source venv/bin/activate
pip install -r requirements.txt
pkill -f "uvicorn.*3000" 2>/dev/null
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 3000 > server.log 2>&1 &
```

---

## 🌐 API Endpoints

| Endpoint | Метод | Описание |
|----------|-------|----------|
| `/health` | GET | Проверка статуса |
| `/docs` | GET | Swagger UI |
| `/api/auth/register` | POST | Регистрация |
| `/api/auth/login` | POST | Авторизация |
| `/api/chat` | POST | AI чат |
| `/api/content` | GET | Контент |
| `/api/payments/plans` | GET | Тарифы |
| `/api/payments/create` | POST | Создание платежа |

---

## 📊 Серверы проекта

| Окружение | Сервер | Порт | Назначение |
|-----------|--------|------|------------|
| **DEV** | 188.68.223.230 | 3000 | Разработка и тестирование |
| **STAGING** | 158.255.6.22 | 7000 | Предпродакшн |
| **STAGING (old)** | 158.255.6.22 | 8000 | Старый бэкенд |

