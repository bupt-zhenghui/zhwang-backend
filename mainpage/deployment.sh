#!/bin/bash

PROJ_NAME="mainpage"
PROJ_TAG="v2-x86"
PROJ_PORT="7999"
DOCKER_PWD="Wangzhenghui123"

docker login --username=bupt_wzh --password="${DOCKER_PWD}" crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com

docker pull "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/${PROJ_NAME}:${PROJ_TAG}"

docker rm -f "${PROJ_NAME}"

docker run -p "${PROJ_PORT}:80" --name "${PROJ_NAME}" -d "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/${PROJ_NAME}:${PROJ_TAG}"
