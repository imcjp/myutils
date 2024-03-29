#!/bin/bash

# 验证是否提供了两个参数
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 NAME CN"
    exit 1
fi

NAME=$1
CN=$2

# 显示用户输入的NAME和CN
echo "使用的 NAME: $NAME"
echo "使用的 CN: $CN"

# 检查是否安装了zip命令
if ! command -v zip &> /dev/null; then
    echo "未发现 'zip' 命令，请先安装zip。"
    exit 1
fi

# 生成第一对密钥和自签名证书，CN使用提供的参数，不显示输出
openssl req -new -x509 -days 36500 -nodes -out "${NAME}_server_key.pem" -keyout "${NAME}_server_key.pem" -subj "/CN=${CN}" >/dev/null 2>&1

# 生成第二对密钥和自签名证书，CN同样使用提供的参数，不显示输出
openssl req -new -x509 -days 36500 -nodes -out "${NAME}_server_ca.pem" -keyout "${NAME}_server_ca.pem" -subj "/CN=${CN}" >/dev/null 2>&1

# 复制文件以创建副本
cp "${NAME}_server_key.pem" "${NAME}_client_ca.pem"
cp "${NAME}_server_ca.pem" "${NAME}_client_key.pem"

# 从${NAME}_server_ca.pem和${NAME}_client_ca.pem文件中删除PRIVATE KEY部分
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/d' "${NAME}_server_ca.pem"
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/d' "${NAME}_client_ca.pem"

# 打包为zip
zip "${NAME}_client.zip" "${NAME}_client_ca.pem" "${NAME}_client_key.pem" >/dev/null

# 删除临时文件
rm -f "${NAME}_client_ca.pem" "${NAME}_client_key.pem"

echo "操作完成。生成的客户端ZIP包为: ${NAME}_client.zip"
