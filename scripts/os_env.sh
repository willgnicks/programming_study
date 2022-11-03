#!/bin/bash

function installDependency()
{
    # 安装wget
    yum install -y wget

    # 进入yum源文件夹，备份yum源源文件
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bk

    # 下载163网易的yum源：
    wget -P /etc/yum.repos.d http://mirrors.163.com/.help/CentOS6-Base-163.repo

    # 更新玩yum源后，执行下边命令更新yum配置，使操作立即生效
    yum makecache

    # 安装依赖
    yum -y install gcc wget curl zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel 

    # 升级依赖
    yum upgrade
}

function makeAllDirs()
{
    cat ./dirs.conf
}