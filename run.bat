@echo off
chcp 65001 > nul
title ZenFlow Development Environment

echo.
echo  ██████╗ ███████╗███╗   ██╗███████╗██╗      ██████╗ ██╗    ██╗
echo ╔══════╝ ██╔════╝████╗  ██║██╔════╝██║     ██╔═══██╗██║    ██║
echo ╚══███╔╝ █████╗  ██╔██╗ ██║█████╗  ██║     ██║   ██║██║ █╗ ██║
echo ╔══╝    ██╔══╝  ██║╚██╗██║██╔══╝  ██║     ██║   ██║██║███╗██║
echo ╚██████╗███████╗██║ ╚████║██║     ███████╗╚██████╔╝╚███╔███╔╝
echo  ╚═════╝╚══════╝╚═╝  ╚═══╝╚═╝     ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
echo.
echo ===================================================================
echo          Meditation, Yoga, Sleep - Premium Wellness App
echo ===================================================================
echo.

:: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed. Please install Python 3.11+
    pause
    exit /b 1
)

:: Check if Node.js is installed
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed. Please install Node.js 18+
    pause
    exit /b 1
)

echo [INFO] Starting development environment...
echo.

:: Start Backend
echo [1/3] Starting Backend (FastAPI)...
if exist "backend\venv\Scripts\activate.bat" (
    start "ZenFlow Backend" cmd /k "cd backend && call venv\Scripts\activate && uvicorn main:app --reload --port 8000"
) else (
    echo [WARN] Virtual environment not found. Creating...
    cd backend
    python -m venv venv
    call venv\Scripts\activate
    pip install -r requirements.txt
    cd ..
    start "ZenFlow Backend" cmd /k "cd backend && call venv\Scripts\activate && uvicorn main:app --reload --port 8000"
)

:: Wait for backend to start
echo [INFO] Waiting for backend to start...
timeout /t 4 /nobreak > nul

:: Start Landing
echo [2/3] Starting Landing Page (Next.js)...
if not exist "landing\node_modules" (
    echo [WARN] Node modules not found. Installing...
    cd landing
    call npm install
    cd ..
)
start "ZenFlow Landing" cmd /k "cd landing && npm run dev"

:: Wait for landing to start
echo [INFO] Waiting for landing to start...
timeout /t 3 /nobreak > nul

:: Open in browser
echo [3/3] Opening in browser...
timeout /t 2 /nobreak > nul
start http://localhost:3000
start http://localhost:8000/docs

echo.
echo ===================================================================
echo.
echo  ✅ All services started successfully!
echo.
echo  📱 Landing Page:  http://localhost:3000
echo  🔧 Backend API:   http://localhost:8000
echo  📚 API Docs:      http://localhost:8000/docs
echo.
echo  💡 To run Flutter app, open Android Studio:
echo     File → Open → select 'mobile' folder
echo.
echo  Press any key to close this window...
echo  (Services will continue running in separate windows)
echo.
echo ===================================================================

pause > nul


