#!/bin/bash

# 启动前端
start_frontend() {
    cd frontend
    npm run dev &
    cd ..
}

# 启动后端
start_backend() {
    cd backend
    source venv/bin/activate
    uvicorn app.main:app --reload --port 8000 &
    cd ..
}

# 主函数
main() {
    start_frontend
    start_backend
    echo "前端运行在 http://localhost:5173"
    echo "后端运行在 http://localhost:8000"
}

main