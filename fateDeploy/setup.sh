#!/bin/bash

# 步骤1: 获得当前文件夹的路径
current_dir=$(pwd)
echo "当前文件夹路径: $current_dir"

# 步骤2: 使用curl命令下载并执行setup.sh脚本来建立工程
curl -s https://raw.githubusercontent.com/imcjp/myproj/main/bin/setup.sh | bash -s -- fateProj

# 步骤3: 在当前文件夹下创建空文件夹fate、fateHub、fateOutput
mkdir -p "${current_dir}/fate" "${current_dir}/fateHub" "${current_dir}/fateOutput"
echo "创建了文件夹 fate, fateHub, fateOutput"

# 步骤4: 在fateHub文件夹下创建软链接
ln -s "${current_dir}/fate/env/python/venv/lib/python3.8/site-packages/fate_client-1.11.3-py3.8.egg/" "${current_dir}/fateHub/clientLib"
ln -s "${current_dir}/fate/fate/python/" "${current_dir}/fateHub/core"
ln -s "${current_dir}/fate/fateflow/python/" "${current_dir}/fateHub/fateflow"
echo "在 fateHub 文件夹下创建了软链接 clientLib, core, fateflow"

# 步骤5: 在fateHub文件夹下创建子文件夹“fateExp”，然后创建软链接
mkdir -p "${current_dir}/fateHub/fateExp"
cd "${current_dir}/fateHub/fateExp"
ln -s "${current_dir}/fateOutput/datasets/" "datasets"
ln -s "${current_dir}/fate/examples/" "examples"
ln -s "${current_dir}/fate/mine" "mine"
echo "在 fateHub/fateExp 文件夹下创建了软链接 datasets, examples, mine"

# 新增步骤: 使用wget下载fateBin.zip并解压，确保在原始目录下进行
cd "${current_dir}" # 确保在原始目录下
wget https://raw.githubusercontent.com/imcjp/myutils/main/fateDeploy/fateBin.zip
unzip -o fateBin.zip -d "${current_dir}" && rm fateBin.zip # 解压并删除zip文件
echo "下载并解压了fateBin.zip到 ${current_dir} 并删除了zip文件"

# 新增步骤: 提示用户将初始化脚本添加到.bashrc中
echo "请将下面的命令添加到你的 .bashrc 文件中，以便在控制台启动时能够使用 ftc 命令："
echo "echo 'source ${current_dir}/fateBin/init_env.sh' >> ~/.bashrc"
echo "然后运行 'source ~/.bashrc' 来立即应用更改。"

# 新增步骤: 提示用户设置开机自启动
echo "如果你想要设置该项目的开机自启动，请将下面的命令开机自启动文件中："
echo "bash ${current_dir}/fateBin/startup.sh"

echo "所有设置完成。"
