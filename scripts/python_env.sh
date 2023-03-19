#!/bin/bash

# python environment building

PYTHON_MODULE="Python_Module"
URL_SYMBOL="python.url"
PACKAGE_SYMBOL="python.package"
MODULE_NAME="python"

function source_common() {
    # shellcheck disable=SC2086
    cd $(dirname $0)
    local path=$(pwd)"/common.sh"
    if [[ ! -f "${path}" ]]; then
        echo "[ERROR] Script ${path} does not exist, unable to process further."
        exit
    fi
    source "${path}"
    PACKAGE=$(getConfig "${PACKAGE_SYMBOL}")
    URL=$(getConfig "${URL_SYMBOL}")
}

# check whether it is already install on server
function check_python() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${PYTHON_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# download python
function download_python() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${PYTHON_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${PYTHON_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_python() {
    logger "INFO" "${PYTHON_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "$MODULE_NAME"
    logger "INFO" "${PYTHON_MODULE}" "${PACKAGE} extract finished"
}

function removeOldVersion3() {
    # 卸载python3
    rpm -qa | grep python3 | xargs rpm -ev --allmatches --nodeps

    # 删除所有残余文件 成功卸载！
    whereis python3 | xargs rm -frv
}

function configure_python() {
    cd "${INSTALL_PATH}/${MODULE_NAME}"
    ./configure --enable-optimizations --prefix="${INSTALL_PATH}/${MODULE_NAME}" --with-ssl
    make && make install
}

function link_python() {
    links "${INSTALL_PATH}/${MODULE_NAME}/bin/python3" "/usr/bin/python3"
    links "${INSTALL_PATH}/${MODULE_NAME}/bin/pip3" "/usr/bin/pip3"
}

function config_pip() {
    mkdir ~/.pip
    echo "[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
use-mirrors = true
mirrors = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = https://pypi.tuna.tsinghua.edu.cn/simple" >~/.pip/pip.conf
}

function main() {
    source_common

#    if check_python; then
#        return 0
#    fi

    download_python

    extract_python

    if configure_python -ne 0; then
        return 1
    fi

#    link_python

#    config_pip

}

main
