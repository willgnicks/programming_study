
- [安装](#安装)
  - [1. 源码安装](#1-源码安装)
    - [1.1 浏览官网的最新发布版本](#11-浏览官网的最新发布版本)
    - [1.2 下载源码](#12-下载源码)
    - [1.3 注册docker服务](#13-注册docker服务)
    - [1.4 授权启动](#14-授权启动)
    - [1.5  设置国内镜像仓库](#15--设置国内镜像仓库)
  - [2. yum源安装](#2-yum源安装)
    - [2.1 卸载旧版本docker](#21-卸载旧版本docker)
    - [2.2 安装依赖包](#22-安装依赖包)
    - [2.3 设置国内yum源](#23-设置国内yum源)
    - [2.4 更新yum软件包索引](#24-更新yum软件包索引)
    - [2.5 安装社区版docker \[docker-ce\]，ee是企业版](#25-安装社区版docker-docker-ceee是企业版)
# 安装

## 1. 源码安装

### 1.1 浏览官网的最新发布版本

> 官网链接地址: [Docker Engine Release](https://docs.docker.com/engine/release-notes/)

### 1.2 下载源码

```bash
# 创建目录
mkdir -p /opt/tools/docker

# 下载源码压缩包至目录
wget -P /opt/tools https://download.docker.com/linux/static/stable/x86_64/docker-20.10.23.tgz

# 解压源码至工具路径下
tar -xvf /opt/tools/docker-19.03.15.tgz -C /opt/tools/docker --strip-components 1

# 复制启动项
cp /opt/tools/docker/* /usr/bin/
```

### 1.3 注册docker服务

- 创建 /etc/systemd/system/docker.service 注册文件写入下列内容
  
    ```prolog
    [Unit]
    Description=Docker Application Container Engine
    Documentation=https://docs.docker.com
    After=network-online.target firewalld.service
    Wants=network-online.target
    [Service]
    Type=notify
    ExecStart=/usr/bin/dockerd -g /opt/docker
    ExecReload=/bin/kill -s HUP $MAINPID
    LimitNOFILE=infinity
    LimitNPROC=infinity
    LimitCORE=infinity
    TimeoutStartSec=0
    Delegate=yes
    KillMode=process
    Restart=on-failure
    StartLimitBurst=3
    StartLimitInterval=60s
    [Install]
    WantedBy=multi-user.target 
    ```
    

### 1.4 授权启动

> chmod a+x /etc/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker.service                     # 开机自启动
systemctl restart docker
> 

### 1.5  设置国内镜像仓库

- 创建  /etc/daemon.json  文件，设置以下镜像仓库后重启docker服务
  
    ```bash
    {
        "registry-mirrors": [
            "http://hub-mirror.c.163.com",
            "https://docker.mirrors.ustc.edu.cn",
            "https://registry.docker-cn.com"
        ]
    }
    ```

## 2. yum源安装
### 2.1 卸载旧版本docker

```bash
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine 
```

### 2.2 安装依赖包

```bash
yum install -y yum-utils
```

### 2.3 设置国内yum源

```bash
yum-config-manager --add-repo [https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo](https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo)
```

### 2.4 更新yum软件包索引

```bash
yum makecache fast
```

### 2.5 安装社区版docker [docker-ce]，ee是企业版

```bash
yum install docker-ce docker-ce-cli [containerd.io](http://containerd.io/)
```
