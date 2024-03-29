#!/bin/bash

# 检查是否提供了名字参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 NAME"
    exit 1
fi

NAME=$1

# 生成密钥对
openssl req -new -x509 -days 36500 -nodes -out "${NAME}_server_key.pem" -keyout "${NAME}_server_key.pem"
openssl req -new -x509 -days 36500 -nodes -out "${NAME}_server_ca.pem" -keyout "${NAME}_server_ca.pem"

# 复制文件以创建副本
cp "${NAME}_server_key.pem" "${NAME}_client_ca.pem"
cp "${NAME}_server_ca.pem" "${NAME}_client_key.pem"

# 从${NAME}_server_ca.pem和${NAME}_client_ca.pem文件中删除PRIVATE KEY部分
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/d' "${NAME}_server_ca.pem"
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/d' "${NAME}_client_ca.pem"

# 打包为zip
zip "${NAME}_client.zip" "${NAME}_client_ca.pem" "${NAME}_client_key.pem"

# 删除临时文件
rm -f "${NAME}_client_ca.pem" "${NAME}_client_key.pem"

echo "操作完成。生成的客户端ZIP包为: ${NAME}_client.zip"
