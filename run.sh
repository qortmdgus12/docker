#!/bin/bash

URL="$1"

if [ -z "$URL" ]; then
  echo "사용법: docker run <image> <image_url>"
  exit 1
fi

echo "이미지 다운로드 중: $URL"
wget -O input.jpg "$URL"

echo "YOLOv3로 객체 검출 중..."
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show

