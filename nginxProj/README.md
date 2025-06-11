# myutils

## nginxProj的部署命令：

您可以使用以下命令快速部署 `nginxProj`：

```bash
curl -s https://raw.githubusercontent.com/imcjp/myutils/refs/heads/main/nginxProj/setup.sh | bash
```

---

# Nginx 管理脚本

此项目包含一组用于管理 Nginx 服务的脚本。通过这些脚本，您可以方便地执行 Nginx 的常见操作，例如启动、停止、重启、配置检查、站点管理等。所有脚本均可通过 `ng <cmd> <args>` 命令格式进行调用。

## 脚本目录

### 1. **help**: 显示可用命令

该脚本用于展示所有可用的 Nginx 管理命令，并提供如何使用这些命令的说明。

#### 用法

```bash
ng help
```

#### 功能

* 列出所有可用的命令。
* 提供如何使用 `ng` 命令的指导。
* 解释如何将 `import` 命令添加到 `.bashrc` 文件中使命令生效。

#### 示例

```bash
$ ng help
以下是可用的命令。您可以使用 'ng <cmd> <args>' 来管理Nginix框架
其中，import用于写在.bashrc文件中使命令生效。如：source /home/ubuntu/nginxProj/scripts/import
```

---

### 2. **import**: 定义命令执行函数

该脚本定义了一个 `ng()` 函数，用于包装对其他脚本的调用。

#### 用法

```bash
source /path/to/scripts/import
```

#### 功能

* 定义 `ng()` 函数用于执行其他脚本。
* 检查脚本是否存在并执行，若不存在则输出错误信息。
* 允许用户通过 `ng <cmd> <args>` 调用其他脚本。

#### 示例

```bash
# 在 .bashrc 中添加以下命令，以便每次启动终端时自动加载命令
source /home/ubuntu/nginxProj/scripts/import

# 然后使用以下命令执行其他脚本
$ ng start
```

---

### 3. **start**: 启动 Nginx 服务

该脚本用于启动 Nginx 服务，并提供成功或失败的反馈信息。

#### 用法

```bash
ng start
```

#### 功能

* 启动 Nginx 服务。
* 如果启动成功，输出 `"启动nginx成功"`。
* 如果启动失败，输出 `"启动nginx失败"`。

#### 示例

```bash
$ ng start
启动nginx成功
```

---

### 4. **stop**: 停止 Nginx 服务

该脚本用于停止 Nginx 服务，并提供成功或失败的反馈信息。

#### 用法

```bash
ng stop
```

#### 功能

* 停止 Nginx 服务。
* 如果停止成功，输出 `"停止nginx成功"`。
* 如果停止失败，输出 `"停止nginx失败"`。

#### 示例

```bash
$ ng stop
停止nginx成功
```

---

### 5. **restart**: 重启 Nginx 服务

该脚本用于重启 Nginx 服务，并提供成功或失败的反馈信息。

#### 用法

```bash
ng restart
```

#### 功能

* 重启 Nginx 服务。
* 如果重启成功，输出 `"重启nginx成功"`。
* 如果重启失败，输出 `"重启nginx失败"`。

#### 示例

```bash
$ ng restart
重启nginx成功
```

---

### 6. **status**: 查看 Nginx 服务状态

该脚本用于查看 Nginx 服务的当前状态。

#### 用法

```bash
ng status
```

#### 功能

* 输出 Nginx 服务的状态信息，显示其是否正在运行。

#### 示例

```bash
$ ng status
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2025-06-11 10:00:00 UTC; 1h 12min ago
   ...
```

---

### 7. **reload**: 重载 Nginx 配置

该脚本用于重载 Nginx 配置，而不需要停止服务。

#### 用法

```bash
ng reload
```

#### 功能

* 重载 Nginx 配置。
* 如果重载成功，输出 `"重载nginx成功"`。
* 如果重载失败，输出 `"重载nginx失败"`。

#### 示例

```bash
$ ng reload
重载nginx成功
```

---

### 8. **check**: 检查 Nginx 配置文件

该脚本用于检查 Nginx 配置文件是否存在语法错误。

#### 用法

```bash
ng check
```

#### 功能

* 使用 `nginx -t` 命令检查配置文件的语法错误。
* 输出配置检查的结果。

#### 示例

```bash
$ ng check
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

---

### 9. **site**: 启用/禁用 Nginx 网站

该脚本用于启用或禁用 Nginx 配置中的站点。

#### 用法

```bash
ng site en <site-name>   # 启用站点
ng site dis <site-name>  # 禁用站点
```

#### 功能

* 启用站点：创建 `/etc/nginx/sites-enabled` 中的符号链接。
* 禁用站点：删除 `/etc/nginx/sites-enabled` 中的符号链接。

#### 示例

```bash
# 启用站点
$ ng site en example.com
Site example.com enabled.

# 禁用站点
$ ng site dis example.com
Site example.com disabled.
```

---

### 10. **build**: 构建 Nginx

该脚本用于下载并构建指定版本的 Nginx。

#### 用法

```bash
ng build <version>
```

#### 功能

* 下载并构建指定版本的 Nginx。
* 使用 `make` 编译并安装。
* 安装完成后，输出 Nginx 的版本信息。

#### 示例

```bash
$ ng build 1.21.3
...
nginx version: nginx/1.21.3
```

---

### 11. **download**: 下载 Nginx 源码

该脚本用于下载指定版本的 Nginx 源码。

#### 用法

```bash
ng download <version>
```

#### 功能

* 检查是否存在指定版本的 Nginx 源码目录。
* 如果不存在，则从 Nginx 官方下载并解压源码包。

#### 示例

```bash
$ ng download 1.21.3
目录 nginx-1.21.3 不存在，正在下载 Nginx 1.21.3...
Nginx 1.21.3 下载并解压完成。
```

---

### 12. **switch**: 切换 Apache 和 Nginx 服务

该脚本用于在 Apache 和 Nginx 之间切换，确保只启动一个服务。

#### 用法

```bash
ng switch
```

#### 功能

* 检查 Apache2 和 Nginx 的状态：

  * 如果两者都在运行，则停止 Apache2，并启动 Nginx。
  * 如果仅有 Apache2 在运行，则停止 Apache2 并启动 Nginx。
  * 如果 Nginx 在运行，保持其状态。

#### 示例

```bash
$ ng switch
两者都已启动，正在关闭 Apache2...
Apache2 已关闭。
Nginx 已启动。
```

---

## 安装和使用

### 安装脚本

1. **下载并解压**：将本仓库下载并解压到服务器上。
2. **添加 `import` 到 `.bashrc`**：为了方便执行脚本，您可以将 `import` 命令添加到 `.bashrc` 文件中，使命令在终端中生效。

```bash
source /path/to/scripts/import
```

### 使用脚本

* 使用命令 `ng <cmd> <args>` 来执行各个脚本。
* 例如，要启动 Nginx 服务，可以使用以下命令：

```bash
ng start
```

* 查看 Nginx 服务的状态：

```bash
ng status
```

---

## 贡献

欢迎提交 Issue 或 Pull Request，帮助我们改进 Nginx 管理脚本。

---

## 许可证

该项目采用 MIT 许可证，详情请见 [LICENSE](./LICENSE) 文件。

---

以上是项目的完整使用文档。所有脚本已经进行了详细的功能描述，并提供了如何使用每个脚本的示例。如果您有任何问题或需要进一步的帮助，请随时联系我！
