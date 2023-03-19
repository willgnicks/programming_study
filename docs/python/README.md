- [1. 安装python](#1-安装python)
  - [1.1 源码安装](#11-源码安装)
- [2. 配置pip，使用pip](#2-配置pip使用pip)
  - [2.1. 配置pip](#21-配置pip)
  - [2.2 使用pip](#22-使用pip)
- [3. 虚拟环境](#3-虚拟环境)
- [1. 源码安装](#1-源码安装)
- [1. 安装python](#1-安装python-1)
- [1. 源码安装](#1-源码安装-1)
- [1. 安装python](#1-安装python-2)
- [1. 源码安装](#1-源码安装-2)
## Python
> 主要包含python基础，web框架(Django, flask)，常用库(pandas, numpy)
# 1. 安装python

## 1.1 源码安装

[Install Shell](https://www.notion.so/Install-Shell-7d4e2d04171649d59c3ec89fb833e0a9)

- 创建目录

```bash
mkdir -p /opt/tools/python-3.9.2
```

- 下载源码包

```bash
wget -P /opt/tools/ http://npm.taobao.org/mirrors/python/3.9.2/Python-3.9.2.tar.xz
```

- 解压源码包

```bash
tar -xvf /opt/tools/Python-3.9.2.tar.xz -C /opt/tools/python-3.9.2 --strip-components 1
```

- 配置并编译

```bash
cd /opt/tools/python-3.9.2; ./configure --enable-optimizations --prefix=/opt/tools/python3 --with-ssl; make && make install
```

- 关联软连接

```bash
ln -s /opt/tools/python3/bin/python3  /usr/bin/python3; ln -s /opt/tools/python3/bin/pip3 /usr/bin/pip3
```

# 2. 配置pip，使用pip

## 2.1. 配置pip

- 创建目录

```bash
mkdir ~/.pip
```

- 创建并修改pip配置文件

```bash
vi pip.conf
```

- 解压源码包

```bash
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
use-mirrors = true
mirrors = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = https://pypi.tuna.tsinghua.edu.cn/simple
```

## 2.2 使用pip

- 一键安装依赖环境包

```bash
pip3 install -r requirements.txt
```

- 导出当前环境依赖包

```bash
pip3 freeze > requirements.txt
```

# 3. 虚拟环境

# 1. 源码安装

1.1 创建目录

```bash
mkdir -p /opt/tools; mkdir -p /opt/tools/python-3.9.2
```

1.2 下载源码包

```bash
wget -P /opt/tools/ http://npm.taobao.org/mirrors/python/3.9.2/Python-3.9.2.tar.xz
```

1.3 解压源码包

```bash
tar -xvf /opt/tools/Python-3.9.2.tar.xz -C /opt/tools/python-3.9.2 --strip-components 1
```

1.4 配置并编译

```bash
cd /opt/tools/python-3.9.2; ./configure --enable-optimizations --prefix=/opt/tools/python3 --with-ssl; make && make install
```

1.5 关联软连接

```bash
ln -s /opt/tools/python3/bin/python3  /usr/bin/python3
ln -s /opt/tools/python3/bin/pip3 /usr/bin/pip3
```

# 1. 安装python

# 1. 源码安装

1.1 创建目录

```bash
mkdir -p /opt/tools; mkdir -p /opt/tools/python-3.9.2
```

1.2 下载源码包

```bash
wget -P /opt/tools/ http://npm.taobao.org/mirrors/python/3.9.2/Python-3.9.2.tar.xz
```

1.3 解压源码包

```bash
tar -xvf /opt/tools/Python-3.9.2.tar.xz -C /opt/tools/python-3.9.2 --strip-components 1
```

1.4 配置并编译

```bash
cd /opt/tools/python-3.9.2; ./configure --enable-optimizations --prefix=/opt/tools/python3 --with-ssl; make && make install
```

1.5 关联软连接

```bash
ln -s /opt/tools/python3/bin/python3  /usr/bin/python3
ln -s /opt/tools/python3/bin/pip3 /usr/bin/pip3
```

# 1. 安装python

# 1. 源码安装

1.1 创建目录

```bash
mkdir -p /opt/tools; mkdir -p /opt/tools/python-3.9.2
```

1.2 下载源码包

```bash
wget -P /opt/tools/ http://npm.taobao.org/mirrors/python/3.9.2/Python-3.9.2.tar.xz
```

1.3 解压源码包

```bash
tar -xvf /opt/tools/Python-3.9.2.tar.xz -C /opt/tools/python-3.9.2 --strip-components 1
```

1.4 配置并编译

```bash
cd /opt/tools/python-3.9.2; ./configure --enable-optimizations --prefix=/opt/tools/python3 --with-ssl; make && make install
```

1.5 关联软连接

```bash
ln -s /opt/tools/python3/bin/python3  /usr/bin/python3
ln -s /opt/tools/python3/bin/pip3 /usr/bin/pip3
```

- python docker 打包
    
    [docker容器引擎](https://www.notion.so/docker-de9c4725af7c4b43ac6f59b04a73ee16)