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

# 返回原始目录
cd "${current_dir}"
echo "所有设置完成。"
