#!/bin/bash

# 步骤1: 获得当前文件夹的路径
current_dir=$(pwd)
echo "当前文件夹路径: $current_dir"

# 步骤2: 建立fateProj工程
mkdir -p fateProj/projStk
mkdir -p "${current_dir}/fateProj/projStk/{0source,1env,2logs,3dev}"
echo "fateProj下创建了日志层，用户可以使用 'ftc cleanLogs' 将 3dev 层运行过程中产生的日志移到 2logs 层中，以便节省其空间"

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
echo "echo 'source ${current_dir}/fateBin/import' >> ~/.bashrc"
echo "然后运行 'source ~/.bashrc' 来立即应用更改。"
echo "将如下代码放到你的启动脚本中可以实现开机启动FATE框架。"
echo "source ${current_dir}/fateBin/import"
echo "ftc mount dev"
echo "ftc start"

echo "所有设置完成。"
