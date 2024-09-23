
## 快速创建stunnel的密钥对

其中，${NAME}指的是秘钥对的名称。该脚本将生成服务器和客户端的key文件及其ca文件，同时将客户端的key和服务端的ca文件打包以供客户端使用

```bash
curl -s https://raw.githubusercontent.com/imcjp/myutils/main/mkCerts/stunnel.sh | bash -s -- ${NAME}
```

## 快速创建frp的服务端和客户端的证书
首先从本站获取openssl.cnf，可以通过如下方式得到示例：
```bash
wget https://raw.githubusercontent.com/imcjp/myutils/main/mkCerts/openssl.cnf
```
其内容如下，注意把your.server.hostname替换为frp的服务器域名：
```txt
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
prompt             = no

[ req_distinguished_name ]
C  = CN
ST = State
L  = City
O  = Organization
OU = Organizational Unit
CN = your.server.hostname  # 替换为服务器的主机名

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = your.server.hostname  # 替换为服务器的主机名
DNS.2 = another.hostname      # 如果需要，添加其他主机名
```


其中，第一个参数是SSL配置文件SSL_CNF（即上述openssl.cnf）；${NAME}是生成完要打包的zip包名称，默认为certs。

```bash
curl -s https://raw.githubusercontent.com/imcjp/myutils/main/mkCerts/frp.sh | bash -s -- openssl.cnf ${NAME}
```
