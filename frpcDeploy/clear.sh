#!/bin/bash

# 确保以 root 用户身份运行
if [ "$(id -u)" -ne 0 ]; then
  echo "请以 root 用户身份运行此脚本！"
  exit 1
fi

# 停止并禁用 FRP 服务
echo "停止并禁用 FRP 服务..."
systemctl stop frpc
systemctl disable frpc

# 删除 systemd 服务文件
echo "删除 systemd 服务文件..."
rm -f /etc/systemd/system/frpc.service

# 重新加载 systemd 守护进程
echo "重新加载 systemd 守护进程..."
systemctl daemon-reload

# 删除 FRP 安装目录
echo "删除 FRP 安装目录..."
rm -rf /usr/local/frp

# 删除配置文件
echo "删除配置文件..."
rm -f /etc/frp/frpc.ini

# 删除下载的压缩包（如果存在）
echo "删除下载的压缩包..."
rm -f /tmp/frp*.tar.gz

# 删除依赖项（如果不再需要）
echo "删除依赖项..."
apt-get remove --purge -y curl tar

# 清理无用的包
echo "清理无用的包..."
apt-get autoremove -y
apt-get clean

echo "FRP 卸载完成！"
