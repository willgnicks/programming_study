#!/bin/bash

DOCKER_MODULE="Docker_Module"
URL_SYMBOL="docker.url"
PACKAGE_SYMBOL="docker.package"
MODULE_NAME="docker"

REGISTER_FILE="/etc/systemd/system/docker.service"
REGISTER_CONTENT="[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
[Service]
Type=notify
ExecStart=/usr/bin/dockerd -g /opt/docker
ExecReload=/bin/kill -s HUP \$MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
[Install]
WantedBy=multi-user.target"

REPOSITORY_FILE="/etc/daemon.json"
REPOSITORY_CONTENT="{
    \"registry-mirrors\": [
        \"http://hub-mirror.c.163.com\",
        \"https://docker.mirrors.ustc.edu.cn\",
        \"https://registry.docker-cn.com\"
    ]
}"

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
function check_docker() {
    local dir_path="${INSTALL_PATH}/${MODULE_NAME}"
    if [ -d "${dir_path}" ]; then
        logger "WARN" "${DOCKER_MODULE}" "${MODULE_NAME} under path ${INSTALL_PATH} exists, no need more further operate"
        return 0
    fi
    return 1
}

# download docker
function download_docker() {
    local package_path="${DOWNLOAD_PATH}/${PACKAGE}"
    if [ -f "${package_path}" ]; then
        logger "WARN" "${DOCKER_MODULE}" "${PACKAGE} has already been downloaded, no need download again"
        return 1
    fi
    logger "INFO" "${DOCKER_MODULE}" "invoke common module to process downloading ${PACKAGE}"
    download "${URL}" "$PACKAGE"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        return 0
    fi
    return 1
}

function extract_docker() {
    logger "INFO" "${DOCKER_MODULE}" "invoke common module to process extract $PACKAGE"
    extract "$PACKAGE" "${MODULE_NAME}"
    logger "INFO" "${DOCKER_MODULE}" "${PACKAGE} extract finished"
}

function config_docker() {
    logger "INFO" "${DOCKER_MODULE}" "invoke common module to link source to executor"

    local dirs=$(ls "${INSTALL_PATH}/${MODULE_NAME}")
    for exec in $dirs;
    do
        rm -f "/usr/bin/${exec}"
        links "${INSTALL_PATH}/${MODULE_NAME}/${exec}" "/usr/bin/${exec}"
    done

    logger "INFO" "${DOCKER_MODULE}" "add register and repository info into relevant file"
    printf "%s\n" "${REGISTER_CONTENT}" >>"$REGISTER_FILE"
    printf "%s\n" "${REPOSITORY_CONTENT}" >>"${REPOSITORY_FILE}"

    logger "INFO" "${DOCKER_MODULE}" "set docker self start and restart it"
    chmod a+x "${REGISTER_FILE}"
    systemctl daemon-reload
    systemctl enable docker.service
    systemctl restart docker
}

function main() {
    source_common

    if check_docker; then
        return 0
    fi

    download_docker

    extract_docker

    config_docker
}

main
