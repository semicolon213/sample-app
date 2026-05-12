#!/bin/bash

# 이전 빌드 찌꺼기 폴더 삭제
rm -rf tempdir

# 작업 폴더 및 파일 복사
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Dockerfile 생성
echo "FROM python:3.8-slim" > tempdir/Dockerfile
echo "RUN pip install --progress-bar off flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py" >> tempdir/Dockerfile

# 앱 빌드 및 실행 (여기에 보안 해제 옵션 추가!)
cd tempdir
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning --security-opt seccomp=unconfined sampleapp
docker ps -a
