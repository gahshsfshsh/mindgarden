#!/bin/bash
# Скрипт для выполнения прямо на сервере root@leha-tema
# Скопируйте содержимое и выполните на сервере

GITHUB_TOKEN="YOUR_GITHUB_TOKEN_HERE"
REPO_DIR="$HOME/mindgarden"
BACKEND_DIR="$REPO_DIR/backend"
PORT=3000

echo "🚀 Запуск деплоя на порт $PORT..."

# Остановка только процесса на порту 3000
echo "🔍 Проверка порта $PORT..."
PID=$(lsof -ti:$PORT 2>/dev/null)
if [ ! -z "$PID" ]; then
    echo "⚠️  Останавливаем процесс на порту $PORT (PID: $PID)..."
    kill -9 $PID 2>/dev/null && sleep 2
fi
pkill -f "uvicorn.*$PORT" 2>/dev/null || true
sleep 1

# Обновление/клонирование репозитория
echo "📦 Работа с репозиторием..."
if [ -d "$REPO_DIR" ]; then
    echo "📂 Обновляем репозиторий..."
    cd "$REPO_DIR"
    git pull https://${GITHUB_TOKEN}@github.com/gahshsfshsh/mindgarden.git 2>/dev/null || git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "⚠️  Не удалось обновить"
else
    echo "📥 Клонируем репозиторий..."
    cd "$HOME"
    git clone https://${GITHUB_TOKEN}@github.com/gahshsfshsh/mindgarden.git
fi

# Переход в backend
cd "$BACKEND_DIR" || {
    echo "❌ Ошибка: директория backend не найдена"
    exit 1
}

# Настройка venv
echo "🐍 Настройка Python окружения..."
if [ ! -d "venv" ]; then
    echo "📦 Создание виртуального окружения..."
    python3 -m venv venv
fi
source venv/bin/activate

# Установка зависимостей
echo "📥 Установка зависимостей..."
pip install --upgrade pip -q
pip install -r requirements.txt -q

# Создание .env если нужно
if [ ! -f ".env" ]; then
    echo "📝 Создание .env файла..."
    cat > .env << 'EOF'
DATABASE_URL=sqlite:///./mindgarden.db
JWT_SECRET=mindgarden-dev-secret-key-2024
OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE
EOF
    echo "⚠️  Не забудьте заполнить OPENAI_API_KEY в .env!"
else
    echo "✅ Файл .env уже существует"
fi

# Инициализация БД
if [ -f "seed_content.py" ]; then
    echo "🗄️  Инициализация базы данных..."
    python3 seed_content.py 2>/dev/null || echo "⚠️  База данных уже заполнена или ошибка"
fi

# Запуск сервера
echo "🚀 Запуск сервера на порту $PORT..."
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port $PORT > server.log 2>&1 &
sleep 4

# Проверка
if lsof -ti:$PORT >/dev/null 2>&1; then
    echo "✅ Сервер успешно запущен на порту $PORT!"
    echo "📋 PID: $(lsof -ti:$PORT)"
    echo "📝 Логи: tail -f $BACKEND_DIR/server.log"
    echo "🌐 URL: http://188.68.223.230:$PORT"
    echo ""
    echo "🏥 Проверка health endpoint..."
    curl -s http://localhost:$PORT/health && echo "" || echo "⚠️  Проверьте логи: tail -f $BACKEND_DIR/server.log"
else
    echo "❌ Ошибка: сервер не запустился"
    echo "📝 Проверьте логи: tail -f $BACKEND_DIR/server.log"
    exit 1
fi

echo ""
echo "✨ Готово!"


