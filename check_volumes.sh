#!/bin/bash

echo "🔍 Docker 볼륨 내부 확인 중..."

for v in $(docker volume ls -q); do
  echo "=============================="
  echo "📦 볼륨 이름: $v"
  docker run --rm -v $v:/data alpine ls /data 2>/dev/null | head -n 5
done
