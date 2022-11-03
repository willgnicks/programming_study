#!/bin/bash

PUBLIC=$(pwd)"/public.sh"
PACKAGE="nginx-1.22.0.tar.gz"
IP="http://nginx.org/download/"

function sourcePublic()
{
    if [[ ! -f "$PUBLIC" ]];then
        echo "[ERROR] Shell script, $PUBLIC, do not exist. This script exit! [ERROR] "
        exit
    fi
    source "$PUBLIC"
}

function downloadPackage()
{
    splitline "*"
    echoLog "nginx_env.sh/DownloadPackage" "Invoke public download function starting, input parameters { url : $IP, package : $PACKAGE}!" "INFO"
    download $IP $PACKAGE
    if [[ $? -eq 0 ]];then
        splitline "*"
    fi
    echoLog "nginx_env.sh/DownloadPackage" "Download function successfully ends!" "INFO"
}

function untar()
{
    untarPackage "$PACKAGE"
    echoLog "nginx_env.sh/Untar" "Invoke public untarPackage starting, input parameters { package : $PACKAGE}!" "INFO"
    if [[ $? -eq 0 ]];then
        splitline "*"
    fi
    echoLog "nginx_env.sh/Untar" "UntarPackage function successfully ends!" "INFO"
}

function main()
{
    sourcePublic
    downloadPackage
    untar
}

main