#!/bin/bash

# 步骤1: 获得home目录的路径
current_dir=$(pwd)
echo "当前文件夹路径: $current_dir"

# 步骤2: 使用wget下载scripts.zip并解压到一个随机命名的目录，确保在原始目录下进行
cd "${current_dir}" # 确保在原始目录下
dirName="nginxProj"
tar_file="nginxProj.tar.gz"

wget "https://raw.githubusercontent.com/imcjp/myutils/main/nginxProj/${tar_file}"
tar -zxvf "${tar_file}" -C "${current_dir}" && rm "${tar_file}" # 解压并删除tar.gz文件 
echo "下载并解压了${tar_file}到 ${current_dir}/${dirName} 并删除了tar.gz文件"

# 提示用户如何使用 nginxProj
echo "使用方法："
echo "请将 '${current_dir}/${dirName}/scripts/import' 加入 '.bashrc' 以使用ng命令进行管理。"
echo "请将 '${current_dir}/${dirName}/scripts/import' 加入 '.bashrc' 以使用ng命令进行管理。"
