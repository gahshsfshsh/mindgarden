#!/bin/bash

# 🚀 Итоговый скрипт деплоя MindGarden на сервер 188.68.223.230:3000
# Использование: bash deploy_server_3000.sh
# Или скопировать на сервер и запустить там

set -e

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Деплой MindGarden на порт 3000${NC}"
echo -e "${BLUE}================================${NC}"

# Конфигурация
GITHUB_TOKEN="YOUR_GITHUB_TOKEN_HERE"
GITHUB_REPO="gahshsfshsh/mindgarden"
REPO_DIR="$HOME/mindgarden"
BACKEND_DIR="$REPO_DIR/backend"
PORT=3000

# Функция безопасной остановки процесса на порту 3000
stop_port_3000() {
    echo -e "${YELLOW}🔍 Проверка порта $PORT...${NC}"
    
    # Находим PID процесса на порту 3000
    PID=$(lsof -ti:$PORT 2>/dev/null || true)
    
    if [ ! -z "$PID" ]; then
        echo -e "${YELLOW}⚠️  На порту $PORT найден процесс (PID: $PID)${NC}"
        
        # Проверяем, что это именно наш процесс uvicorn
        PROCESS_INFO=$(ps -p $PID -o comm= 2>/dev/null || echo "")
        if [[ "$PROCESS_INFO" == *"python"* ]] || [[ "$PROCESS_INFO" == *"uvicorn"* ]]; then
            echo -e "${YELLOW}   Останавливаем процесс на порту $PORT...${NC}"
            kill -9 $PID 2>/dev/null || true
            sleep 2
            
            # Проверяем, что порт освободился
            if lsof -ti:$PORT >/dev/null 2>&1; then
                echo -e "${RED}❌ Не удалось освободить порт $PORT${NC}"
                exit 1
            else
                echo -e "${GREEN}✅ Порт $PORT освобожден${NC}"
            fi
        else
            echo -e "${RED}❌ На порту $PORT запущен другой процесс: $PROCESS_INFO${NC}"
            echo -e "${RED}   Пропускаем остановку для безопасности${NC}"
        fi
    else
        echo -e "${GREEN}✅ Порт $PORT свободен${NC}"
    fi
    
    # Дополнительная очистка старых процессов uvicorn на порту 3000
    echo -e "${YELLOW}🧹 Очистка старых процессов uvicorn на порту $PORT...${NC}"
    pkill -f "uvicorn.*$PORT" 2>/dev/null || true
    sleep 1
}

# Клонирование/обновление репозитория
setup_repo() {
    echo -e "${BLUE}📦 Настройка репозитория...${NC}"
    
    if [ -d "$REPO_DIR" ]; then
        echo -e "${YELLOW}📂 Репозиторий существует, обновляем...${NC}"
        cd "$REPO_DIR"
        
        # Используем токен для git pull
        git pull https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git 2>/dev/null || \
        git pull origin main 2>/dev/null || \
        git pull origin master 2>/dev/null || \
        echo -e "${YELLOW}⚠️  Не удалось обновить через git pull${NC}"
    else
        echo -e "${GREEN}📥 Клонируем репозиторий...${NC}"
        cd "$HOME"
        
        # Клонируем с токеном
        git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git mindgarden || {
            echo -e "${RED}❌ Ошибка клонирования репозитория${NC}"
            exit 1
        }
    fi
    
    cd "$BACKEND_DIR" || {
        echo -e "${RED}❌ Директория backend не найдена${NC}"
        exit 1
    }
}

# Настройка виртуального окружения
setup_venv() {
    echo -e "${BLUE}🐍 Настройка Python окружения...${NC}"
    
    if [ ! -d "venv" ]; then
        echo -e "${GREEN}📦 Создание виртуального окружения...${NC}"
        python3 -m venv venv
    fi
    
    echo -e "${GREEN}🔌 Активация виртуального окружения...${NC}"
    source venv/bin/activate
    
    echo -e "${GREEN}📥 Установка зависимостей...${NC}"
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
}

# Настройка .env файла
setup_env() {
    echo -e "${BLUE}⚙️  Настройка переменных окружения...${NC}"
    
    if [ ! -f ".env" ]; then
        echo -e "${YELLOW}📝 Создание .env файла...${NC}"
        cat > .env << 'EOF'
DATABASE_URL=sqlite:///./mindgarden.db
JWT_SECRET=mindgarden-dev-secret-key-2024
OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE
EOF
        echo -e "${YELLOW}⚠️  Не забудьте заполнить OPENAI_API_KEY в .env файле!${NC}"
    else
        echo -e "${GREEN}✅ Файл .env уже существует${NC}"
    fi
}

# Инициализация базы данных
init_db() {
    echo -e "${BLUE}🗄️  Инициализация базы данных...${NC}"
    
    if [ -f "seed_content.py" ]; then
        python3 seed_content.py || echo -e "${YELLOW}⚠️  Ошибка при заполнении БД (возможно уже заполнена)${NC}"
    fi
}

# Запуск сервера
start_server() {
    echo -e "${BLUE}🚀 Запуск сервера на порту $PORT...${NC}"
    
    # Активируем venv если еще не активирован
    [ -d "venv" ] && source venv/bin/activate
    
    # Запускаем в фоне
    nohup python3 -m uvicorn main:app --host 0.0.0.0 --port $PORT > server.log 2>&1 &
    
    # Ждем запуска
    sleep 4
    
    # Проверяем статус
    if lsof -ti:$PORT >/dev/null 2>&1; then
        PID=$(lsof -ti:$PORT)
        echo -e "${GREEN}✅ Сервер успешно запущен!${NC}"
        echo -e "${GREEN}📋 PID: $PID${NC}"
        echo -e "${GREEN}📝 Логи: tail -f $BACKEND_DIR/server.log${NC}"
        echo -e "${GREEN}🌐 URL: http://188.68.223.230:$PORT${NC}"
        
        # Проверяем health endpoint
        sleep 2
        echo -e "${BLUE}🏥 Проверка health endpoint...${NC}"
        if curl -s http://localhost:$PORT/health >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Health check пройден!${NC}"
            curl -s http://localhost:$PORT/health | python3 -m json.tool 2>/dev/null || curl -s http://localhost:$PORT/health
            echo ""
        else
            echo -e "${YELLOW}⚠️  Health check не прошел. Проверьте логи:${NC}"
            echo -e "${YELLOW}   tail -f $BACKEND_DIR/server.log${NC}"
        fi
    else
        echo -e "${RED}❌ Ошибка: сервер не запустился${NC}"
        echo -e "${RED}📝 Проверьте логи: tail -f $BACKEND_DIR/server.log${NC}"
        exit 1
    fi
}

# Основной процесс
main() {
    stop_port_3000
    setup_repo
    setup_venv
    setup_env
    init_db
    start_server
    
    echo -e "${GREEN}✨ Деплой завершен успешно!${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${GREEN}📊 Полезные команды:${NC}"
    echo -e "   Логи:     tail -f $BACKEND_DIR/server.log"
    echo -e "   Остановка: pkill -f 'uvicorn.*$PORT'"
    echo -e "   Проверка:  curl http://localhost:$PORT/health"
}

# Запуск
main


