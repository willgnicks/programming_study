#!/bin/bash

JAVA_MODULE="Java_Module"
URL_SYMBOL="java.url"
PACKAGE_SYMBOL="java.package"
MODULE_NAME="java"

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
function check_java() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${JAVA_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# download java
function download_java() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${JAVA_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${JAVA_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_java() {
    logger "INFO" "${JAVA_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "${MODULE_NAME}"
    logger "INFO" "${JAVA_MODULE}" "${PACKAGE} extract finished"
}

function main() {
    source_common

    if check_java; then
        return 0
    fi

    download_java

    extract_java


}

main

