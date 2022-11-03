# Command

- [Command](#command)
  - [1. 常用命令](#1-常用命令)
    - [1.1 帮助命令](#11-帮助命令)
    - [1.2 镜像命令](#12-镜像命令)
    - [1.3 搜索镜像](#13-搜索镜像)


## 1. 常用命令

### 1.1 帮助命令

```bash
# 显示docker的版本信息。

docker version    
# 显示docker的系统信息，包括镜像和容器的数量

docker info       
# 帮助命令

docker 命令 --help
```

### 1.2 镜像命令

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

### 1.3 搜索镜像

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