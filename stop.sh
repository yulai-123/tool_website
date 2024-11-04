#!/bin/bash

# 停止前端服务 (默认端口5173)
stop_frontend() {
    echo "正在停止前端服务..."
    frontend_pid=$(lsof -t -i:5173)
    if [ ! -z "$frontend_pid" ]; then
        kill -9 $frontend_pid
        echo "前端服务已停止"
    else
        echo "未发现运行中的前端服务"
    fi
}

# 停止后端服务 (默认端口8000)
stop_backend() {
    echo "正在停止后端服务..."
    backend_pid=$(lsof -t -i:8000)
    if [ ! -z "$backend_pid" ]; then
        kill -9 $backend_pid
        echo "后端服务已停止"
    else
        echo "未发现运行中的后端服务"
    fi
}

# 主函数
main() {
    stop_frontend
    stop_backend
    echo "所有服务已停止"
}

main