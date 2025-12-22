#!/bin/bash

# Скрипт для запуска MindGarden backend на порту 3000
# Использование: ./start_server_3000.sh

set -e  # Остановка при ошибке

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Запуск MindGarden backend на порту 3000${NC}"

# Определяем путь к backend
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKEND_DIR="$SCRIPT_DIR/backend"

# Проверяем существование директории backend
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${RED}❌ Ошибка: директория backend не найдена в $BACKEND_DIR${NC}"
    exit 1
fi

cd "$BACKEND_DIR"

# Проверяем наличие .env файла
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  Файл .env не найден. Создайте его перед запуском.${NC}"
    echo -e "${YELLOW}   Используйте ENV_TEMPLATE.txt как образец.${NC}"
fi

# Активируем виртуальное окружение если оно существует
if [ -d "venv" ]; then
    echo -e "${GREEN}📦 Активация виртуального окружения...${NC}"
    source venv/bin/activate
elif [ -d "../venv" ]; then
    echo -e "${GREEN}📦 Активация виртуального окружения (из родительской директории)...${NC}"
    source ../venv/bin/activate
else
    echo -e "${YELLOW}⚠️  Виртуальное окружение не найдено. Используется системный Python.${NC}"
fi

# Проверяем, запущен ли процесс на порту 3000
echo -e "${GREEN}🔍 Проверка порта 3000...${NC}"
PID=$(lsof -ti:3000 2>/dev/null || true)

if [ ! -z "$PID" ]; then
    echo -e "${YELLOW}⚠️  На порту 3000 уже запущен процесс (PID: $PID)${NC}"
    echo -e "${YELLOW}   Останавливаем только процесс на порту 3000...${NC}"
    
    # Останавливаем только процесс на порту 3000
    kill -9 $PID 2>/dev/null || true
    sleep 2
    
    # Проверяем, что порт освободился
    if lsof -ti:3000 >/dev/null 2>&1; then
        echo -e "${RED}❌ Не удалось освободить порт 3000${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Порт 3000 освобожден${NC}"
    fi
else
    echo -e "${GREEN}✅ Порт 3000 свободен${NC}"
fi

# Останавливаем старые процессы uvicorn на порту 3000 (на всякий случай)
echo -e "${GREEN}🧹 Очистка старых процессов uvicorn на порту 3000...${NC}"
pkill -f "uvicorn.*3000" 2>/dev/null || true
sleep 1

# Проверяем наличие requirements.txt и зависимостей
if [ -f "requirements.txt" ]; then
    echo -e "${GREEN}📦 Проверка зависимостей...${NC}"
    python3 -c "import uvicorn" 2>/dev/null || {
        echo -e "${YELLOW}⚠️  uvicorn не найден. Устанавливаем зависимости...${NC}"
        pip install -r requirements.txt
    }
fi

# Запускаем сервер
echo -e "${GREEN}🚀 Запуск сервера на порту 3000...${NC}"
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 3000 > server.log 2>&1 &

# Ждем запуска
sleep 3

# Проверяем статус
if lsof -ti:3000 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Сервер успешно запущен на порту 3000!${NC}"
    echo -e "${GREEN}📋 PID процесса: $(lsof -ti:3000)${NC}"
    echo -e "${GREEN}📝 Логи: tail -f $BACKEND_DIR/server.log${NC}"
    echo -e "${GREEN}🌐 Проверка: curl http://localhost:3000/health${NC}"
    
    # Проверяем health endpoint
    sleep 2
    if curl -s http://localhost:3000/health >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Health check пройден!${NC}"
        curl -s http://localhost:3000/health | python3 -m json.tool 2>/dev/null || curl -s http://localhost:3000/health
    else
        echo -e "${YELLOW}⚠️  Health check не прошел. Проверьте логи: tail -f $BACKEND_DIR/server.log${NC}"
    fi
else
    echo -e "${RED}❌ Ошибка: сервер не запустился${NC}"
    echo -e "${RED}📝 Проверьте логи: tail -f $BACKEND_DIR/server.log${NC}"
    exit 1
fi

echo -e "${GREEN}✨ Готово!${NC}"


