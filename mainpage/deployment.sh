#!/bin/bash

PROJ_NAME="mainpage"
PROJ_PORT="7999"

if [ -z "$1" ]; then
  echo "用法: ./deployment.sh <tag>"
  echo "示例: ./deployment.sh v2026.04.12-x86"
  exit 1
fi

PROJ_TAG="$1"
ALIYUN_REPO="crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/${PROJ_NAME}"

if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo ".env 文件不存在，请创建并设置 ALIYUN_PASSWORD"
  exit 1
fi

docker login --username="${ALIYUN_USERNAME}" --password="${ALIYUN_PASSWORD}" "${ALIYUN_REPO%/*}"

docker pull "${ALIYUN_REPO}:${PROJ_TAG}"

docker rm -f "${PROJ_NAME}"

docker run -p "${PROJ_PORT}:80" --name "${PROJ_NAME}" -d "${ALIYUN_REPO}:${PROJ_TAG}"

echo "部署完成: ${ALIYUN_REPO}:${PROJ_TAG}"
