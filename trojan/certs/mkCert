#!/bin/bash

# 验证是否提供了一个或两个参数
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [NAME]"
    exit 1
fi
NAME=$1
# 将 SSL_CNF 转换为绝对路径
SSL_CNF="openssl.cnf"

# 显示用户输入的变量
echo "使用的 NAME: $NAME"

# 生成密钥
openssl genrsa -out "${NAME}.key" 2048

# 生成 CSR
openssl req -new -key "${NAME}.key" -out "${NAME}.crt" -config "$SSL_CNF"

echo "操作完成。生成的证书：${NAME}.key 和 ${NAME}.crt"
