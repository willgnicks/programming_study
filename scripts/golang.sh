#!/bin/bash

GO_MODULE="Golang_Module"
URL_SYMBOL="golang.url"
PACKAGE_SYMBOL="golang.package"
HOME_SYMBOL="golang.home"
MODULE_NAME="golang"
STRUCTURE=("src" "pkg" "bin")
PATH_NAME="/projects/go_projects"

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
    HOME=$(getConfig "${HOME_SYMBOL}")
}

# check whether it is already install on server
function check_go() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${GO_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# add env variable to path
function source_path() {
    logger "INFO" "${GO_MODULE}" "invoke common module to process make dirs for golang ${STRUCTURE[*]}"
    make_dirs "${HOME}" "${STRUCTURE[*]}"
    local note="# Set Golang Path"
    local go_root="export GOROOT=${INSTALL_PATH}/${MODULE_NAME}"
    local go_path="export GOPATH=${HOME}"
    local path="export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin"
    logger "INFO" "${GO_MODULE}" "add golang environment variable to source file, go root and path are ${go_root}, ${go_path}"
    printf "%s\n%s\n%s\n%s\n" "$note" "$go_root" "$go_path" "$path" >>"$BASHFILE"
    source "$BASHFILE"
    printf "%s\n%s\n%s\n%s\n" "$note" "$go_root" "$go_path" "$path" >>"$ZSHFILE"
    source "$ZSHFILE"
}

# download golang
function download_go() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${GO_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${GO_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_go() {
    logger "INFO" "${GO_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "${MODULE_NAME}"
    logger "INFO" "${GO_MODULE}" "${PACKAGE} extract finished"
}

function main() {
    source_common

    if check_go; then
        return 0
    fi

    download_go

    extract_go

    source_path
}

main
