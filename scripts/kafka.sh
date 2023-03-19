#!/bin/bash

KAFKA_MODULE="Kafka_Module"
URL_SYMBOL="kafka.url"
PACKAGE_SYMBOL="kafka.package"
MODULE_NAME="kafka"
DEPENDENCIES=("zookeeper.install.path" "java.install.path" "gradle.install.path")

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


function checkDependencies() {
    for dependency in "${dependencies[@]}"; do

        checkDependency "$dependency"
        if $(checkDependency "$dependency"); then
            local name=$(echo $dependency | awk -F '.' '{print $1}')
            if ! -e ".sh"; then
                exit 1
            fi
            source $name
        fi
    done
}


function checkDependency() {
    if [ -d "$(getConfig "$1")" ]; then
        return 0
    else
        return 1
    fi
}

# check whether it is already install on server
function check_kafka() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${KAFKA_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# download kafka
function download_kafka() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${KAFKA_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${KAFKA_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_kafka() {
    logger "INFO" "${KAFKA_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "${MODULE_NAME}"
    logger "INFO" "${KAFKA_MODULE}" "${PACKAGE} extract finished"
}

function main() {

    source_common

    if check_kafka; then
        return 0
    fi

    download_kafka

    extract_kafka

}

main
