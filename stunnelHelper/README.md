
## 快速创建stunnel的密钥对

其中，${NAME}指的是秘钥对的名称。该脚本将生成服务器和客户端的key文件及其ca文件，同时将客户端的key和服务端的ca文件打包以供客户端使用

```bash
curl -s https://raw.githubusercontent.com/imcjp/myutils/main/stunnelHelper/mkCert.sh | bash -s -- ${NAME}
```
