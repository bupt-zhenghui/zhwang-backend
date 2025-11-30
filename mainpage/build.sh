#!/bin/bash

set -e

# 本地构建 arm
# docker build . -t zhwang1999/mainpage:v2-arm

# 推送dockerHub远程
# docker push zhwang1999/mainpage:v2-arm

REPO="zhwang1999/mainpage"
TAG="v2-x86"
DOCKER_PWD="Wangzhenghui123"

# 本地构建 x86
docker build . --platform linux/amd64 -t "${REPO}:${TAG}"

# 获取镜像对应ImageID
IMAGE_ID=$(docker images --filter=reference="${REPO}:${TAG}" --format "{{.ID}}")

if [ -n "$IMAGE_ID" ]; then
  echo "镜像ID: $IMAGE_ID"
  docker login --username=bupt_wzh --password="${DOCKER_PWD}" crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com
  docker tag "${IMAGE_ID}" "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mainpage:${TAG}"
  docker push "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mainpage:${TAG}"
  echo "镜像推送阿里云仓库成功"
else
  echo "未找到镜像"
  exit 1
fi
