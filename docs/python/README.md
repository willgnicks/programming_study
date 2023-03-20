- [安装](#源码安装)
- [pip](#pip)
- [virtualenv](#虚拟环境)
- [删除python2的旧版本](#删除python2)

# Python
> 主要包含python基础，web框架(Django, flask)，常用库(pandas, numpy)

## 源码安装

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
# 注意 低版本gcc不能使用 --enable-optimizations，至少使用gcc 8.1.0版本
cd /opt/tools/python-3.9.2; ./configure --prefix=/usr/local/python3 --with-ssl; make && make install
```

- 关联软连接

```bash
ln -s /opt/tools/python3/bin/python3  /usr/bin/python; ln -s /opt/tools/python3/bin/pip3 /usr/bin/pip
```

## pip

### 配置pip

#### windows

```bash
# 创建目录
mkdir ~/pip

# 创建并修改pip配置文件
vi pip.ini

# 将一下内容写入pip.ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
use-mirrors = true
mirrors = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = https://pypi.tuna.tsinghua.edu.cn/simple
```
 
#### linux / macos

```bash
# 创建目录
mkdir ~/.pip

# 创建并修改pip配置文件
vi pip.conf

# 将一下内容写入pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
use-mirrors = true
mirrors = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = https://pypi.tuna.tsinghua.edu.cn/simple
```


### 使用pip

- 一键安装依赖环境包

```bash
pip3 install -r requirements.txt
```

- 导出当前环境依赖包

```bash
pip3 freeze > requirements.txt
```

- 查看当前包的版本与最新版本对比

```bash
pip3 list --outdated
```

## 虚拟环境

### virtualenv

```shell
# 安装虚拟环境
pip install virtualenv
# 创建虚拟环境
virtualenv --no-site-packages venv
# 激活进入
source venv/bin/activate
# 退出
deactive
```

### virtualenv wrapper
```shell
# 使用封装虚拟环境工具
pip install virtualenvwrapper

# 添加环境变量
# 绝对路径
export WORKON_HOME=/home/my_virtualenv
# 根据自己python安装目录，
source /usr/local/python3.6/bin/virtualenvwrapper.sh


# 创建
mkvirtualenv venv
# 删除
rmvirtualenv venv
# 列出所有
lsvirtualenv -b
# 回home
cdvirtualenv
# 激活进入
workon venv
# 退出同上
deactive
```

## 删除python2

```shell
# 卸载python3
rpm -qa | grep python3 | xargs rpm -ev --allmatches --nodeps

# 卸载python2
rpm -qa | grep python | xargs rpm -ev --allmatches --nodeps

# 删除所有残余文件 成功卸载！
whereis python3 | xargs rm -frv

```