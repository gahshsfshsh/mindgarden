#!/bin/bash
# Простой скрипт запуска на порту 3000
# Использование: bash start_3000_simple.sh

cd ~/YOGA/backend || cd ~/mindgarden/backend || cd backend || exit 1

# Активируем venv если есть
[ -d venv ] && source venv/bin/activate

# Останавливаем только процесс на порту 3000
PID=$(lsof -ti:3000 2>/dev/null)
[ ! -z "$PID" ] && kill -9 $PID 2>/dev/null && sleep 2

# Очистка старых процессов uvicorn на порту 3000
pkill -f "uvicorn.*3000" 2>/dev/null || true
sleep 1

# Запуск
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port 3000 > server.log 2>&1 &

sleep 3
echo "✅ Сервер запущен на порту 3000"
echo "📋 PID: $(lsof -ti:3000)"
echo "📝 Логи: tail -f $(pwd)/server.log"
curl -s http://localhost:3000/health || echo "⚠️  Проверьте логи"


