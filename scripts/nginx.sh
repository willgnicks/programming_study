#!/bin/bash

NGINX_MODULE="Nginx_Module"
URL_SYMBOL="nginx.url"
PACKAGE_SYMBOL="nginx.package"
MODULE_NAME="nginx"

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
function check_nginx() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${NGINX_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# download nginx
function download_nginx() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${NGINX_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${NGINX_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_nginx() {
    logger "INFO" "${NGINX_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "${MODULE_NAME}"
    logger "INFO" "${NGINX_MODULE}" "${PACKAGE} extract finished"
}

function main() {
    source_common

    if check_nginx; then
        return 0
    fi

    download_nginx

    extract_nginx
}

main
