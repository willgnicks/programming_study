#!/bin/bash

# public shell script for other scripts invoke
# contain:
# 1. download zip package to tools directory
# 2. untar the package to destination
# 3. compile and install software by resource
# 4. add executive file to PATH
# 5. link executive file to PATH bin


BASHFILE="$HOME/.bashrc"
ZSHFILE="$HOME/.zshrc"
DEFAULT_SOFTWARE_PATH="/opt/tools"
DEFAULT_SOFTWARE_DIRS="compressed_packages resource_files"

# split lines
# accept one param of split char
function splitline()
{
    s=$(printf "%-200s" "$1")
    echo "${s// /$1}"
}

# verify given path satisfied to path regex
# parameter will be the path to be verified
function verifyPath()
{
    local regex='^(/{1,2}[0-9|a-z|\.|_|\-]+)+/?$'
    if [[ "$1" =~ $regex ]];then
        return 0
    else
        return 1
    fi
}

# echo log message
# 1. function name
# 2. msg
# 3. type
function echoLog()
{
    echo "[$3] $1 : $2 [$3]"
}

# verify if function proceed successfully
# given two parameters are
# 1. for the function return status code
# 2. is the message to print out
function verify()
{
    if test $1 -ne 0;then
        echoLog "public.sh/Verify" "errors occur during $2" "ERROR"
        splitline "*"
        exit 1
    fi
}

# download resource package
# given two parameters are
# 1. the url of download resource website
# 2. the package name for download
function download()
{
    echoLog "public.sh/Download" "Downloading with parameters { package : $2, url : $1 }" "INFO"
    local url=$1
    local package=$2
    local path="$DEFAULT_SOFTWARE_PATH/"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $1}')
    if [[ -z $package ]] || [[ -z $url ]];then
        echoLog "public.sh/Download" "Download parameters package or url is NULL!" "ERROR"
        return 1
    fi
    
    if [[ ! -e "$path/$package" ]];then
        wget -P $path "$url$package"
        verify $? "downloading package $package!"
        echoLog "public.sh/Download" "Download $package finish!" "INFO"
        return 0
    fi
    echoLog "public.sh/Download" "Package $package exists, no need to download again!" "INFO"
    return 0
}

# untar the package to specific path
# given two parameters are
# 1. package name to untar $1
# 2. target path to untar package $2
#    if it's null, resource path instead
function untarPackage()
{   
    echoLog "public.sh/UntarPackage" "Untaring package starts with parameters { package : $1, target_path : $2 }!" "INFO"
    if [[ -z $1 ]];then
        echoLog "public.sh/UntarPackage" "Required parameter - package name is absent!" "ERROR"
        return 1
    fi
    # init path with default path
    local target_path="$DEFAULT_SOFTWARE_PATH/"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $2}')
    # if there is given path, dont use default one
    if test -n "$2";then
        verifyPath "$2"
        if test $? -ne 0;then
            echoLog "public.sh/UntarPackage" "Given path is unavailable!" "ERROR"
            return 1
        fi
        target_path="$2"
    fi
    local package_path="$DEFAULT_SOFTWARE_PATH/"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $1}')"/$1"
    if [[ ! -f "$package_path" ]];then
        echoLog "public.sh/UntarPackage" "Given package $1 is not existed in default software path $DEFAULT_SOFTWARE_PATH/$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $1}')" "ERROR"
        return 1
    fi
    tar -xf "$package_path" -C $target_path
    verify $? "untaring package $package_path!"
    echoLog "public.sh/UntarPackage" "Untaring package $1 successfully with parameters { target_path : $target_path, package_path : $package_path }!" "INFO"
    return 0
}

# add env variable to path
# given two parameters are
# 1. content need to be added to file
# 2. path of file to be added and sourced
function addPath()
{   
    printf "$1" >> "$2"
    source "$2"
}

# mk dirs for given dirs if they are not exist
# given two parameters are
# 1. given path, e.g: /opt/tool
# 2. given dirs, e.g: src or pkg
function makeDirs()
{
    local path=$1
    local dirs=$2
    for var in ${dirs[*]}; do
        local fullpath="$path/$var"
        verifyPath "$fullpath"
        if [[ $? -ne 0 ]];then
            echoLog "public.sh/MakeDirs" "Given path and directories make up fullpath $fullpath error, please check!" "ERROR"
            continue
        fi
        if [[ ! -d "$fullpath" ]];then
            mkdir -p "$fullpath"
            echoLog "public.sh/MakeDirs" "Create directory $fullpath successfully!" "INFO"
        else
            echoLog "public.sh/MakeDirs" "Directory $fullpath exists, no need to create!" "INFO"
        fi
    done
}

# add soft link from a to b
# given two parameters are
# 1. from position
# 2. target position
function addLink()
{
    ln -s "$1" "$2"
    verify $? "soft link creation with param { \$1:$1, \$2:$2}!"
}
