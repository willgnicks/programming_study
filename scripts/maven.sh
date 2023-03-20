#!/bin/bash

MAVEN_MODULE="Nginx_Module"
URL_SYMBOL="maven.url"
PACKAGE_SYMBOL="maven.package"
MODULE_NAME="maven"

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
function check_maven() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${MAVEN_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# download maven
function download_maven() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${MAVEN_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${MAVEN_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_maven() {
    logger "INFO" "${MAVEN_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "${MODULE_NAME}"
    logger "INFO" "${MAVEN_MODULE}" "${PACKAGE} extract finished"
}

function main() {
    source_common

    if check_maven; then
        return 0
    fi

    download_maven

    extract_maven
}

main
