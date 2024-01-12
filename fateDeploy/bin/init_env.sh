#!/bin/bash

# 定义一个函数，用于包装对 bin 目录下脚本的调用
ftc() {
    # 获取脚本名称（第一个参数）
    local script_name="$1"
    # 移除第一个参数，剩下的都是要传递给脚本的参数
    shift
    # 定义 bin 目录的路径
    local bin_path="$(dirname "${BASH_SOURCE[0]}")"
    # 完整脚本路径
    local script_path="${bin_path}/${script_name}"

    # 检查脚本是否存在并且可执行
    if [[ -x "${script_path}" ]]; then
        # 使用 bash 明确调用脚本并传递参数
        bash "${script_path}" "$@"
    else
        # 输出错误消息
        echo "错误：脚本 '${script_name}' 不存在或者不可执行。"
        return 1
    fi
}

# 当脚本被 source 时，以上函数将被定义在当前shell环境中
