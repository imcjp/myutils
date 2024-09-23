#!/bin/bash

# 验证是否提供了一个或两个参数
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 SSL_CNF [NAME]"
    exit 1
fi

# 将 SSL_CNF 转换为绝对路径
SSL_CNF=$(realpath "$1")

# 检查 SSL_CNF 是否存在
if [ ! -f "$SSL_CNF" ]; then
    echo "配置文件 '$SSL_CNF' 不存在。"
    echo "请通过以下命令下载模板文件："
    echo "wget https://raw.githubusercontent.com/imcjp/myutils/main/mkCerts/openssl.cnf"
    exit 1
fi

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

# 生成一个随机的 TMP 名称
TMP=$(mktemp -d "tmp.XXXXXX")

# 检查是否成功创建 TMP 目录
if [ ! -d "$TMP" ]; then
    echo "无法创建临时目录。"
    exit 1
fi

echo "使用的 TMP 目录: $TMP"

# 切换到 TMP 目录
cd "$TMP" || exit

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

# 打包为 zip，保留在当前目录
zip "${NAME}.zip" ca.key ca.crt server.key server.crt client.key client.crt -j

cd ..
mv "$TMP/${NAME}.zip" .

# 删除 TMP 目录
rm -rf "$TMP"

echo "操作完成。生成的 ZIP 包为: ${NAME}.zip"
