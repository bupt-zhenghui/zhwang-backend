#!/bin/bash

MAINPAGE_TAG="v2-x86"
MAINPAGE_PORT="7999"
DOCKER_PWD="Wangzhenghui123"

docker login --username=bupt_wzh --password="${DOCKER_PWD}" crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com

docker pull "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mainpage:${MAINPAGE_TAG}"

docker run -p "${MKDOCS_PORT}:80" --name mainpage -d "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mainpage:${MAINPAGE_TAG}"
