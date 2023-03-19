---

# 1. 源码安装

## 1.1 浏览官网的最新发布版本

[Docker Engine release notes](https://docs.docker.com/engine/release-notes/)

## 1.2 下载源码

[tar 压缩解压](https://www.notion.so/tar-c7502c647ead4ac8a4564383fdb1f70f)

```bash
# 创建目录
mkdir -p /opt/tools/docker

# 下载源码压缩包至目录
wget -P /opt/tools https://download.docker.com/linux/static/stable/x86_64/docker-19.03.15.tgz

# 解压源码至工具路径下
tar -xvf /opt/tools/docker-19.03.15.tgz -C /opt/tools/docker --strip-components 1

# 复制启动项
cp /opt/tools/docker/* /usr/bin/
```

## 1.3 注册docker服务

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
    

## 1.4 授权启动

> chmod a+x /etc/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker.service                     # 开机自启动
systemctl restart docker
> 

## 1.5  设置国内镜像仓库

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
    

# 2. yum源安装

## 2.1 卸载旧版本docker

```bash
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine 
```

## 2.2 安装依赖包

```bash
yum install -y yum-utils
```

## 2.3 设置国内yum源

```bash
yum-config-manager --add-repo [https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo](https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo)
```

## 2.4 更新yum软件包索引

```bash
yum makecache fast
```

## 2.5 安装社区版docker [docker-ce]，ee是企业版

```bash
yum install docker-ce docker-ce-cli [containerd.io](http://containerd.io/)
```

# 3. 常用命令

## 3.****1 帮助命令****

```bash
# 显示docker的版本信息。

docker version    
# 显示docker的系统信息，包括镜像和容器的数量

docker info       
# 帮助命令

docker 命令 --help
```

## 3.2 镜像命令

```bash
# 查看所有本地主机上的镜像 可以使用docker image ls代替
docker images

# 搜索镜像
docker search

# 下载镜像 docker image pull
docker pull

# 删除镜像 docker image rm
docker rmi

# 查看所有本地的主机上的镜像
docker images

# docker images
[root@iz2zeak7sgj6i7hrb2g862z ~]
REPOSITORY            TAG                 IMAGE ID            CREATED           SIZE
hello-world           latest              bf756fb1ae65        4 months ago     13.3kB
mysql                 5.7                 b84d68d0a7db        6 days ago       448MB

# 说明
# 镜像的仓库源
  REPOSITORY
# 镜像的标签(版本) ---lastest 表示最新版本
  TAG
# ID 镜像的id
  IMAGE
# 镜像的创建时间
  CREATED
# 镜像的大小
  SIZE

# 可选项
Options:
  # 列出所有镜像
  -a, --all         Show all images (default hides intermediate images)
  # 只显示镜像的id
  -q, --quiet       Only show numeric IDs
```

## 3.3 搜索镜像

```bash
# 列出所有镜像详细信息
[root@iz2zeak7sgj6i7hrb2g862z ~]# docker images -a  
# 列出所有镜像的id
[root@iz2zeak7sgj6i7hrb2g862z ~]# docker images -aq 

[root@iz2zeak7sgj6i7hrb2g862z ~]# docker search mysql

# docker search 搜索镜像

# --filter=STARS=3000 #过滤，搜索出来的镜像收藏STARS数量大于3000的
Options:
  -f, --filter filter   Filter output based on conditions provided
      --format string   Pretty-print search using a Go template
      --limit int       Max number of search results (default 25)
      --no-trunc        Don't truncate output
      
[root@iz2zeak7sgj6i7hrb2g862z ~]# docker search mysql --filter=STARS=3000

docker安装sql server

docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=Seclover1234!@#$' -p 1401:1433 --name sqlserver -d microsoft/mssql-server-linux 

docker rm $(docker ps -aq)

docker start $(docker ps -aq)

docker stop $(docker ps -aq)
```

# 4. 所有命令学习

[docker命令详解](https://www.notion.so/docker-425d514479444bd7988af752dcc63c4d)