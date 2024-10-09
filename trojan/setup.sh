#!/bin/bash

dirName="trojan"
version="0.10.6"
tar_file="trojan.tar.gz"

# 步骤1: 获得home目录的路径
current_dir=$(pwd)
echo "当前文件夹路径: $current_dir"

# 使用wget下载scripts.zip并解压到一个随机命名的目录，确保在原始目录下进行
cd "${current_dir}" # 确保在原始目录下
dirName="trojan"
tar_file="trojan.tar.gz"

wget "https://raw.githubusercontent.com/imcjp/myutils/main/trojan/${tar_file}"
tar -zxvf "${tar_file}" -C "${current_dir}" && rm "${tar_file}" # 解压并删除tar.gz文件
echo "下载并解压了${tar_file}到 ${current_dir}/${dirName} 并删除了tar.gz文件"

cd "${dirName}"
current_dir=$(pwd)

# 步骤2: 使用wget下载trojan安装包

install_file="trojan-go-linux-amd64.zip"
wget "https://github.com/p4gefau1t/trojan-go/releases/download/v${version}/${install_file}"
sudo apt install unzip
unzip "${install_file}"


# 步骤3: 替换随机目录下的main文件中的<user>为当前用户的名字
sed -i "s/<user>/$USER/g" "systemd/trojan-go@.service"
sed -i "s#<dir>#${current_dir}#g" "systemd/trojan-go@.service"

# 检查trojan-go@.service是否存在，如果存在，则删除
if [ -L /etc/systemd/system/trojan-go@.service ]; then
    sudo rm /etc/systemd/system/trojan-go@.service
fi

# 创建新的trojan-go@.service
sudo cp "systemd/trojan-go@.service" /etc/systemd/system

# 重新加载systemd配置文件，确保新服务被正确加载
sudo systemctl daemon-reload

# 步骤4: 赋予frpc文件可执行权限
chmod 555 "trojan-go"

# 提示用户关于配置文件的信息
echo "在 ${current_dir} 下有配置示例文件 server.json.example。" > "readme.txt"
echo "您可以参考此示例文件编写您的配置文件，例如 XXX.json。" >> "readme.txt"
echo "然后，通过服务 trojan-go@XXX.service 运行 trojan，其中 XXX 指代您的配置文件名称。" >> "readme.txt"
echo "请确保您的配置文件后缀为 *.json。" >> "readme.txt"

# 提示用户如何使用 trojan-go@.service
echo "使用方法：" >> "${current_dir}/readme.txt"
echo "1. 编写配置文件并放置在 ${current_dir} 目录下，例如 ${current_dir}/XXX.json。" >> "readme.txt"
echo "2. 启动服务：sudo systemctl start trojan-go@XXX" >> "readme.txt"
echo "3. 开机自启服务：sudo systemctl enable trojan-go@XXX" >> "readme.txt"
echo "4. 查看服务状态：sudo systemctl status trojan-go@XXX" >> "readme.txt"
echo "5. 停止服务：sudo systemctl stop trojan-go@XXX" >> "readme.txt"
echo "6. 重启服务：sudo systemctl restart trojan-go@XXX" >> "readme.txt"
echo "请替换 XXX 为您的配置文件名称，不包含.json后缀。" >> "readme.txt"
echo "----- 证书生成指南 -----------------" >> "readme.txt"
echo "请进入 '${current_dir}/certs' 目录，然后运行如下指令生成证书：" >> "readme.txt"
echo "bash mkCert [NAME]" >> "readme.txt"
echo "其中 [NAME] 为证书的名字，运行后将得到 [NAME].crt 和 [NAME].key。" >> "readme.txt"
echo "注意编辑 openssl.cnf 中的CN和DNS.1字段，使其生成的证书域名匹配 trojan 的域名（即 sni 属性）。" >> "readme.txt"
cat readme.txt

echo "脚本执行完成。"

