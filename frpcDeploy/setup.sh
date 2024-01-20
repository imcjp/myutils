#!/bin/bash

# 步骤1: 获得home目录的路径
current_dir=$(pwd)
echo "当前文件夹路径: $current_dir"

# 步骤2: 使用wget下载scripts.zip并解压到一个随机命名的目录，确保在原始目录下进行
cd "${current_dir}" # 确保在原始目录下
dirName="frpc"
zip_file="frpc.zip"

wget "https://raw.githubusercontent.com/imcjp/myutils/main/frpcDeploy/${zip_file}"
unzip -o "${zip_file}" -d "${current_dir}" && rm "${zip_file}" # 解压并删除zip文件
echo "下载并解压了${zip_file}到 ${current_dir}/${dirName} 并删除了zip文件"

# 步骤3: 替换随机目录下的main文件中的<user>为当前用户的名字
sed -i "s/<user>/$USER/g" "${current_dir}/${dirName}/systemd/frpc@.service"
sed -i "s#<dir>#${current_dir}/${dirName}#g" "${current_dir}/${dirName}/systemd/frpc@.service"

# 检查frpc@.service是否存在，如果存在，则删除
if [ -L /etc/systemd/system/frpc@.service ]; then
    sudo rm /etc/systemd/system/frpc@.service
fi

# 创建新的frpc@.service
sudo cp "${current_dir}/${dirName}/systemd/frpc@.service" /etc/systemd/system

# 重新加载systemd配置文件，确保新服务被正确加载
sudo systemctl daemon-reload

# 步骤4: 赋予frpc文件可执行权限
chmod 555 "${current_dir}/${dirName}/frpc"

# 提示用户关于配置文件的信息
echo "在 ${current_dir}/${dirName} 下有配置示例文件 frpc.ini.example。" > "${current_dir}/${dirName}/readme.txt"
echo "您可以参考此示例文件编写您的配置文件，例如 XXX.ini。" >> "${current_dir}/${dirName}/readme.txt"
echo "然后，通过服务 frpc@XXX.service 运行 frpc，其中 XXX 指代您的配置文件名称。" >> "${current_dir}/${dirName}/readme.txt"
echo "请确保您的配置文件后缀为 *.ini。" >> "${current_dir}/${dirName}/readme.txt"

# 提示用户如何使用 frpc@.service
echo "使用方法：" >> "${current_dir}/${dirName}/readme.txt"
echo "1. 编写配置文件并放置在 ${current_dir}/${dirName} 目录下，例如 ${current_dir}/${dirName}/XXX.ini。" >> "${current_dir}/${dirName}/readme.txt"
echo "2. 启动服务：sudo systemctl start frpc@XXX" >> "${current_dir}/${dirName}/readme.txt"
echo "3. 开机自启服务：sudo systemctl enable frpc@XXX" >> "${current_dir}/${dirName}/readme.txt"
echo "4. 查看服务状态：sudo systemctl status frpc@XXX" >> "${current_dir}/${dirName}/readme.txt"
echo "5. 停止服务：sudo systemctl stop frpc@XXX" >> "${current_dir}/${dirName}/readme.txt"
echo "6. 重启服务：sudo systemctl restart frpc@XXX" >> "${current_dir}/${dirName}/readme.txt"
echo "请替换 XXX 为您的配置文件名称，不包含.ini后缀。" >> "${current_dir}/${dirName}/readme.txt"
cat "${current_dir}/${dirName}/readme.txt"

echo "脚本执行完成。"
