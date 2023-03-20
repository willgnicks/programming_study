#!/bin/bash

ENTRANCE_MODULE="Entrance-Module"

# source common shell script for use
function source_common() {
    # shellcheck disable=SC2086
    cd $(dirname $0)
    local path=$(pwd)"/common.sh"
    if [ ! -f "${path}" ]; then
        echo "[ERROR] Script ${path} does not exist, unable to process further."
        exit
    fi
    source "${path}"
    # get software names and other setting paths
    NAMES=$(grep -v '#' <"${CONFIG_FILE}" | grep 'package' | awk -F '.' '{print $1}')
    PATHS=$(grep -v '#' <"${CONFIG_FILE}" | grep 'path' | awk -F '=' '{print $2}')
}

# init software script
function inits() {
    # shellcheck disable=SC2086
    cd $(dirname $0)
    for name in ${NAMES[*]}; do
        local script=$(ls | grep "${name}")
        if [ -n "$script" ]; then
            sh "$script"
        fi
    done &
    wait
}

function downloads() {
    for name in ${NAMES[*]};
    do
        local package=$(getConfig "${name}.package")
        local url=$(getConfig "${name}.url")
        logger "INFO" "${ENTRANCE_MODULE}" "invoke common-module to process downloading ${package}"
        download "${url}" "${package}"
        local status=$?
        if [ "$status" -eq 1 ]; then
            logger "ERROR" "${ENTRANCE_MODULE}" "error occurs when process ${package} downloading"
        fi
        if [ "$status" -eq 2 ]; then
            logger "WARN" "${ENTRANCE_MODULE}" "${package} is already downloaded, no need to download again"
        fi

        splitline
        splitline "#"
        splitline
    done
}

# main func
function main() {
    # check and source dependency
    source_common

    # mkdir for download and install
    make_dirs "$PATHS"

    # download compressed package
    downloads

    # init software scripts
#    inits
}

main
