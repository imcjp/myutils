
## 快速创建stunnel的密钥对（${NAME}指的是秘钥对的名称，${CN}是秘钥的CN字段）：

```bash
curl -s https://raw.githubusercontent.com/imcjp/myutils/main/stunnelHelper/mkCert.sh | bash -s -- ${NAME} ${CN}
```
