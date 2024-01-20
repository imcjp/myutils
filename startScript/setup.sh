#!/bin/bash

# 步骤1: 获得home目录的路径
cd
current_dir=$(pwd)
echo "当前文件夹路径: $current_dir"

# 步骤2: 使用wget下载scripts.zip并解压到一个随机命名的目录，确保在原始目录下进行
cd "${current_dir}" # 确保在原始目录下
zip_file="scripts.zip"
random_dir="scripts_$(date +%s%N | sha256sum | head -c 8)" # 生成随机目录名

wget -O "${zip_file}" https://raw.githubusercontent.com/imcjp/myutils/main/startScript/scripts.zip
unzip -o "${zip_file}" -d "${current_dir}/${random_dir}" && rm "${zip_file}" # 解压到随机目录并删除zip文件
echo "下载并解压了scripts.zip到 ${current_dir}/${random_dir} 并删除了zip文件"

# 步骤3: 替换随机目录下的main文件中的<user>为当前用户的名字
sed -i "s/<user>/$USER/g" "${current_dir}/${random_dir}/scripts/main"

# 步骤4: 将main文件复制到/etc/init.d
chmod 777 "${current_dir}/${random_dir}/scripts/main"
sudo cp "${current_dir}/${random_dir}/scripts/main" /etc/init.d/

# 步骤5: 赋予main、startScript和stopScript文件777权限
chmod 777 "${current_dir}/${random_dir}/scripts/startScript"
chmod 777 "${current_dir}/${random_dir}/scripts/stopScript"

# 步骤6: 将startScript和stopScript复制到home目录下
if [ ! -f "${current_dir}/startScript" ]; then
    cp "${current_dir}/${random_dir}/scripts/startScript" "${current_dir}/"
fi

if [ ! -f "${current_dir}/stopScript" ]; then
    cp "${current_dir}/${random_dir}/scripts/stopScript" "${current_dir}/"
fi

# 步骤7: 删除随机命名的scripts文件夹 
rm -rf "${current_dir}/${random_dir}"

# 步骤8: 使main脚本开机自启动
sudo update-rc.d main defaults

echo "脚本执行完成。"
