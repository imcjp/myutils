#!/bin/bash

# 验证是否提供了一个或两个参数
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [NAME]"
    exit 1
fi
NAME=$1

# 显示用户输入的变量
sudo openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout "${NAME}.key" -out "${NAME}.crt"

echo "操作完成。生成的证书：${NAME}.key 和 ${NAME}.crt"
