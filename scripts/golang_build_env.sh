#!/bin/bash

PUBLIC=$(pwd)"/public.sh"
STRUCTURE=("src" "pkg" "bin")
PACKAGE="go1.18.3.linux-amd64.tar.gz"
IP="https://golang.google.cn/dl/$PACKAGE"


INSTALL_TARGET="/usr/local/go"
PATH_NAME="/projects/go_projects"

NOTE="# set golang path"
GOROOT="export GOROOT=/usr/local/go"
GOPATH="export GOPATH=$HOME$PATH_NAME"
NEWPATH='export PATH=$PATH:$GOROOT/bin:$GOPATH/bin'

function sourcePublic()
{
    if [[ ! -f "$PUBLIC" ]];then
        echo "[ERROR] Shell script, $PUBLIC, do not exist. This script exit! [ERROR] "
        exit
    fi
    source "$PUBLIC"
}
# untar package
function untar()
{
    if test ! -e "$INSTALL_TARGET";then
        mkdir -p $INSTALL_TARGET
    fi
    tar -xf "$HOME/$PACKAGE" -C $INSTALL_TARGET --strip-components 1
    verify $? "untaring"
    echo "untar package finish!"
}

# download resource package
function downloadPackage()
{   
    if test ! -e "$HOME/$PACKAGE";then
        wget -P $HOME "https://golang.google.cn/dl/$PACKAGE"
        verify $? "downloading"
        echo "download finish!"
        return
    fi
    echo "package exists!"
}

# add env variable to path
function addPath()
{   
    if test ! -d "$HOME$PATH_NAME";then
        for dir in ${STRUCTURE[*]};do
            mkdir -p "$HOME$PATH_NAME/$dir"
        done
    fi
    printf "$NOTE\n$GOROOT\n$GOPATH\n$NEWPATH" >> $BASHFILE
    source $BASHFILE
    printf "\n$NOTE\n$GOROOT\n$GOPATH\n$NEWPATH\n\n" >> $ZSHFILE
    source $ZSHFILE
    echo "set path finish!"
    splitline "="
}

function main()
{   
    splitline "="
    download
    splitline "="
    untarPackage
    splitline "="
    addPath
}

main