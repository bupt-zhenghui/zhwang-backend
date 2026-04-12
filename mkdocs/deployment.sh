#!/bin/bash

PROJ_NAME="mkdocs"
PROJ_PORT="9090"

# 从命令行参数获取 tag，如未指定则退出
if [ -z "$1" ]; then
  echo "用法: ./deployment.sh <tag>"
  echo "示例: ./deployment.sh v2026.04.12-x86"
  exit 1
fi

PROJ_TAG="$1"
ALIYUN_REPO="crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/${PROJ_NAME}"

# 从 .env 文件加载环境变量
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

docker run -p "${PROJ_PORT}:8000" --name "${PROJ_NAME}" -d "${ALIYUN_REPO}:${PROJ_TAG}"

echo "部署完成: ${ALIYUN_REPO}:${PROJ_TAG}"
