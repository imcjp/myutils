#!/bin/bash

# 验证是否提供了一个参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 NAME"
    exit 1
fi

NAME=$1

# 显示用户输入的NAME
echo "使用的 NAME: $NAME"

# 检查是否安装了zip命令
if ! command -v zip &> /dev/null; then
    echo "未发现 'zip' 命令，请先安装zip。"
    exit 1
fi

# 使用NAME生成第一对密钥和自签名证书，不显示输出
openssl req -new -x509 -days 36500 -nodes -out "${NAME}_server_key.pem" -keyout "${NAME}_server_key.pem" -subj "/CN=${NAME}" >/dev/null 2>&1

# 生成第二对密钥和自签名证书，这里文件名直接使用client_key的命名，不显示输出
openssl req -new -x509 -days 36500 -nodes -out "${NAME}_client_key.pem" -keyout "${NAME}_client_key.pem" -subj "/CN=${NAME}" >/dev/null 2>&1

# 复制文件以创建副本
cp "${NAME}_server_key.pem" "${NAME}_server_ca.pem"
cp "${NAME}_client_key.pem" "${NAME}_client_ca.pem"


# 从${NAME}_server_ca.pem和${NAME}_client_ca.pem文件中删除PRIVATE KEY部分
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/d' "${NAME}_server_ca.pem"
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/d' "${NAME}_client_ca.pem"

# 打包为zip，这里只包含server_ca和client_key
zip "${NAME}_client.zip" "${NAME}_server_ca.pem" "${NAME}_client_key.pem" >/dev/null

# 删除临时文件
rm -f "${NAME}_server_ca.pem" "${NAME}_client_key.pem"

echo "操作完成。生成的客户端ZIP包为: ${NAME}_client.zip"
