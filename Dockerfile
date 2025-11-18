FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    git wget build-essential && \
    rm -rf /var/lib/apt/lists/*

# Darknet 클론
RUN git clone https://github.com/pjreddie/darknet /darknet
WORKDIR /darknet

# 혹시 GPU/OPENCV가 기본으로 켜져 있으면 꺼주기 (없으면 그냥 넘어가도록 || true)
RUN sed -i 's/GPU=1/GPU=0/' Makefile || true && \
    sed -i 's/CUDNN=1/CUDNN=0/' Makefile || true && \
    sed -i 's/OPENCV=1/OPENCV=0/' Makefile || true

# 빌드
RUN make

# YOLOv3 weights 다운로드
RUN wget https://pjreddie.com/media/files/yolov3.weights

# URL 받아서 실행하는 스크립트 복사
COPY run.sh /darknet/run.sh
RUN chmod +x /darknet/run.sh

# 컨테이너 실행 시: run.sh <이미지 URL>
ENTRYPOINT ["/darknet/run.sh"]

