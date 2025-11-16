#!/bin/bash

MKDOCS_TAG="v2-x86"
MKDOCS_PORT="9090"
DOCKER_PWD = "Wangzhenghui123"

docker login --username=bupt_wzh --password="${DOCKER_PWD}" crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com

docker pull "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mkdocs:${MKDOCS_TAG}"

docker run -p "${MKDOCS_PORT}:8000" --name mkdocs -d "crpi-jic5w57mqp9e5onw.cn-hangzhou.personal.cr.aliyuncs.com/zhwang/mkdocs:${MKDOCS_TAG}"


# nginx配置调整 & 重启
NGINX_CONF_ABS_PATH=$(realpath ./nginx.conf)

if [ ! -f "$NGINX_CONF_ABS_PATH" ]; then
  echo "错误：当前目录下未找到 nginx.conf 文件"
  exit 1
fi

# 复制文件到目标路径，-f 强制覆盖已存在的文件
sudo cp -f "$NGINX_CONF_ABS_PATH" /etc/nginx/nginx.conf

# 检查复制是否成功
if [ $? -eq 0 ]; then
  echo "成功将 $NGINX_CONF_ABS_PATH 复制到 /etc/nginx/nginx.conf（已覆盖现有文件）"
  nginx -s reload
else
  echo "复制失败，请检查权限或文件路径"
  exit 1
fi
