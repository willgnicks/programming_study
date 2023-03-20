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

COMMON_MODULE="Common-Module"
CONFIG_FILE="config.properties"

function getConfig() {
    cd $(dirname $0)
    echo "$(grep -v '#' <${CONFIG_FILE} | grep "$1" | awk -F '=' '{print $2}')"
}

DOWNLOAD_PATH=$(getConfig "download.path")
INSTALL_PATH=$(getConfig "install.path")

# split lines
# accept one param of split char
function splitline() {
    s=$(printf "%-136s" "$1")
    echo "${s// /$1}"
}

# verify given path satisfied to path regex
# parameter will be the path to be verified
function verifyPath() {
    local regex='^(/{1,2}[0-9|a-z|\.|_|\-]+)+/?$'
    if [[ "$1" =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}

# echo log message
# 1. log level
# 2. module name
# 3. message
function logger() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [$1] [$2] $3"
}

# verify if function proceed successfully
# given two parameters are
# 1. for the function return status code
# 2. is the message to print out
function verify() {
    if test $1 -ne 0; then
        logger "ERROR" "${COMMON_MODULE}" "errors occur during $2"
        splitline "#"
        exit 1
    fi
}

# download resource package
# given two parameters are
# 1. the url of download resource website
# 2. the package name for download
function download() {
    logger "INFO" "${COMMON_MODULE}" "start to download $2 with url $1"
    local url=$1
    local package=$2
    if [[ -z $package ]] || [[ -z $url ]]; then
        logger "ERROR" "${COMMON_MODULE}" "downloading process error, package name or download url is empty"
        return 1
    fi

    if [[ ! -e "${DOWNLOAD_PATH}/$package" ]]; then
        wget -q -P "${DOWNLOAD_PATH}" "$url/$package"
        verify $? "downloading package $package!"
        logger "INFO" "${COMMON_MODULE}" "download $package success"
        return 0
    fi
    logger "WARN" "${COMMON_MODULE}" "required package - $package is already existed under path $DOWNLOAD_PATH, no need to download again"
    return 2

}

# extracts resource from compressed package
# @param $1  compressed package name to be extracted
# @param $2  install dirname that extract to
function extract() {
    logger "INFO" "${COMMON_MODULE}" "extract resource from compressed package $1"
    if [[ -z $1 ]]; then
        logger "ERROR" "${COMMON_MODULE}" "Required package name is absent"
        return 1
    fi

    local location="${DOWNLOAD_PATH}/$1"
    if [[ ! -f "${location}" ]]; then
        logger "ERROR" "${COMMON_MODULE}" "required package $1 is not existed under path ${location}"
        return 2
    fi
    local install_path="${INSTALL_PATH}/$2"
    if [ ! -d "${install_path}" ]; then
        mkdir -p "${install_path}"
    fi

    tar -xf "${location}" -C "${install_path}" --strip-components 1
    verify $? "extract package ${location}"
    logger "INFO" "${COMMON_MODULE}" "extract $1 finished from ${DOWNLOAD_PATH}/$1 to ${INSTALL_PATH}/$2"
    return 0
}

# add env variable to path
# given two parameters are
# 1. content need to be added to file
# 2. path of file to be added and sourced
function addPath() {
    printf "$1" >>"$2"
    source "$2"
}

# make dirs under given path
# @param $1  parent path for mkdir "dirname"
# @param $2  dirname that can be an array
function make_dirs() {
    local dirs=$2
    for dir in ${dirs[*]}; do
        {
            local dir_path="$1/${dir}"
            if verifyPath "${dir_path}"; then
                logger "ERROR" "${COMMON_MODULE}" "full path $dir_path not valid, make dir failed"
                continue
            fi
            # if dir not exist
            if [[ ! -d "${dir_path}" ]]; then
                mkdir -p "${dir_path}"
                logger "INFO" "${COMMON_MODULE}" "make directory $dir_path successfully"
            else
                logger "WARN" "${COMMON_MODULE}" "directory $dir_path exists, no need to create again"
            fi
        } &
    done
    wait
}

# add soft link from a to b
# given two parameters are
# 1. from position
# 2. target position
function links() {
    ln -s "$1" "$2"
    verify $? "create soft link from $1 to $2"
}
