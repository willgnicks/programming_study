#!/bin/bash

# python environment building

PACKAGE="Python-3.9.2.tar.xz"
IP="http://npm.taobao.org/mirrors/python/3.9.2/"

download $IP $PACKAGE
if [[ $? -ne 0 ]];then
    echo "download error!"
fi

function removeOldVersion3()
{
    # 卸载python3
    rpm -qa|grep python3|xargs rpm -ev --allmatches --nodeps

    # 删除所有残余文件 成功卸载！   
    whereis python3 |xargs rm -frv  
}


