#!/bin/bash

PYTHON_MODULE="Python_Module"
URL_SYMBOL="python.url"
PACKAGE_SYMBOL="python.package"
MODULE_NAME="python"

PIP_CONFIG="[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
use-mirrors = true
mirrors = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = https://pypi.tuna.tsinghua.edu.cn/simple"

WRAPPER_CONFIG="# virtualenvwrapper
export WORKON_HOME="~/.virtualenvs"
export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python"
# set shell script
source /usr/local/bin/virtualenvwrapper.sh"


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

function remove_version_2() {
    rpm -qa | grep python | xargs rpm -ev --allmatches --nodeps
    local result=$(whereis python3 | xargs rm -frv)
    if [ -z "${result}" ]; then
        return 0
    fi
}

function configure_python() {
    cd "${INSTALL_PATH}/${MODULE_NAME}"
    ./configure --enable-optimizations --prefix="${INSTALL_PATH}/${MODULE_NAME}" --with-ssl
    make && make install
}

function link_python() {
    logger "INFO" "${PYTHON_MODULE}" "remove old soft link and build new one towards install path"
    rm /usr/bin/python
    rm /usr/bin/pip
    links "${INSTALL_PATH}/${MODULE_NAME}/bin/python3" "/usr/bin/python"
    links "${INSTALL_PATH}/${MODULE_NAME}/bin/pip3" "/usr/bin/pip"
}

function configure_pip() {
    logger "INFO" "${PYTHON_MODULE}" "start to configure pip and write config info to pip.conf"
    mkdir -p ~/.pip
    printf "%s\n" "${PIP_CONFIG}" >~/.pip/pip.conf
}

function configure_virtualEnvWrapper() {
    pip install virtualenvwrapper
    add_path "${WRAPPER_CONFIG}" "~/.bashrc"
}

function main() {
    source_common
    logger "INFO" "${PYTHON_MODULE}" "process python environment build script"

    if remove_version_2; then
        logger "INFO" "${PYTHON_MODULE}" "uninstall python2 finished and clearly"
    fi

    if check_python; then
        return 0
    fi

    logger "INFO" "${PYTHON_MODULE}" "finish checking python install status and it is able to reinstall python"

    download_python

    extract_python

    if configure_python -eq 0; then

        link_python

        configure_pip

        configure_virtualEnvWrapper

        return 0
    fi

    logger "WARN" "${PYTHON_MODULE}" "configure python failed as maybe gcc version limit"
}

main
