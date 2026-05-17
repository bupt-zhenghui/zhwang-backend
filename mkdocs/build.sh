#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "用法: ./build.sh <tag>"
  echo "示例: ./build.sh v2026.04.12-x86"
  exit 1
fi

TAG="$1"
REPO="zhwang1999/mkdocs"
ALIYUN_REPO="crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mkdocs"

if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo ".env 文件不存在，请创建并设置 ALIYUN_PASSWORD"
  exit 1
fi

docker build . --platform linux/amd64 -t "${REPO}:${TAG}"

IMAGE_ID=$(docker images --filter=reference="${REPO}:${TAG}" --format "{{.ID}}")

if [ -n "$IMAGE_ID" ]; then
  echo "镜像ID: $IMAGE_ID"
  docker login --username="${ALIYUN_USERNAME}" --password="${ALIYUN_PASSWORD}" "${ALIYUN_REPO%/*}"
  docker tag "${IMAGE_ID}" "${ALIYUN_REPO}:${TAG}"
  docker push "${ALIYUN_REPO}:${TAG}"
  echo "镜像推送阿里云仓库成功"
else
  echo "未找到镜像"
  exit 1
fi
