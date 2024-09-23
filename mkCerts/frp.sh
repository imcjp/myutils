#!/bin/bash

# 验证是否提供了一个或两个参数
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 SSL_CNF [NAME]"
    exit 1
fi

# 将 SSL_CNF 转换为绝对路径
SSL_CNF=$(realpath "$1")

# 如果只提供一个参数，设置 NAME 为 certs
if [ "$#" -eq 1 ]; then
    NAME="certs"
else
    NAME=$2
fi

# 显示用户输入的变量
echo "使用的 SSL_CNF: $SSL_CNF"
echo "使用的 NAME: $NAME"

# 检查是否安装了 zip 命令
if ! command -v zip &> /dev/null; then
    echo "未发现 'zip' 命令，请先安装 zip。"
    exit 1
fi

# 检查目录是否存在
if [ -d "$NAME" ]; then
    echo "目录 '$NAME' 已存在，停止执行。"
    exit 1
else
    mkdir "$NAME"
    cd "$NAME" || exit
fi

# 生成 CA 密钥
openssl genrsa -out ca.key 2048

# 生成 CA 证书
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -out ca.crt -subj "/C=CN/ST=State/L=City/O=Organization/OU=Unit/CN=CA"

# 生成服务器密钥
openssl genrsa -out server.key 2048

# 生成服务器 CSR
openssl req -new -key server.key -out server.csr -config "$SSL_CNF"

# 使用 CA 签发服务器证书
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 500 -sha256 -extfile "$SSL_CNF" -extensions req_ext

# 生成客户端密钥
openssl genrsa -out client.key 2048

# 生成客户端 CSR
openssl req -new -key client.key -out client.csr -config "$SSL_CNF"

# 使用 CA 签发客户端证书
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 500 -sha256 -extfile "$SSL_CNF" -extensions req_ext
