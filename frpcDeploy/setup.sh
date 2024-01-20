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
sed -i "s/<dir>/${current_dir}/g" "${current_dir}/${dirName}"
sudo ln -s "${current_dir}/${dirName}/systemd/frpc@.service" /etc/systemd/system

# 步骤4: 赋予frpc文件可执行权限
chmod 555 "${current_dir}/${dirName}/frpc"

echo "脚本执行完成。"
