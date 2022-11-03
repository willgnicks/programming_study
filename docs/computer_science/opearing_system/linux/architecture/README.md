# Shell

linux常用命令见linux命令

[常用指令](https://www.notion.so/483ad220ef504a54b9eb31c000aeb47d)

[Demo](https://www.notion.so/Demo-3e6e5982a86d47f289bfc5e590a9abc4)

[【shell脚本100集】目前B站最完整的shell脚本，包含所有干货内容，无废话！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1d34y1j763?p=8&share_source=copy_web)

Shell脚本教程

```bash
用户态命令 > 进入shell解释器 > 进入系统内核 > 计算机硬件
```

![截屏2022-05-30 22.20.34.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9002f2bd-94c0-472b-8b5f-ada5ccfb49e3/截屏2022-05-30_22.20.34.png)

shell脚本定义：使用linux命令及流程控制语句来达到非交互式的程序目的

shebang，指定解释器，如#!/bin/bash来控制脚本的shell解释器为bash。如果不指定shebang，则会使用默认shell解释器，可以通过echo $SHELL，也可以用shebang指定python解释器。此外需要注意脚本的可执行权限

## Bash

### 基础

### 几个重要变量

history 

-c 清空

-r 恢复

!加历史命令的ID可执行历史命令

!!执行上一次命令

1. $HISTSIZE 历史命令存放数量设置，可以配合export HISTSIZE=5000来设置最多的存储数量 
2. $HISTFILE

在linux中反引号定义的linux命令将会变成执行该命令的存储结果，如name=`ls`将记录文件目录

### shell进程

- 关于父子shell
    
    > 通过bash或者sh等命令执行脚本时，会开启子shell进程，父shell中不会产生对应的变量值
    而通过source或者 .  命令执行脚本时，不会开启子shell进程，变量值是在当前shell中
    > 

### 变量

- 本地变量 针对当前shell进程的生效，父shell中的变量无法被子shell进程中读取
- 环境变量（全局变量）所有shell进程均可访问
- 局部变量 使用在shell脚本函数中的变量
- 特殊变量 $?，用于记录上一条指令的状态码，为特殊写法

> 单引号变量，不识别特殊字符
双引号变量，识别特殊字符
>