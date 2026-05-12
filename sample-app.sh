#!/bin/bash

# 1. 이전 빌드 찌꺼기 폴더 원천 삭제
rm -rf tempdir

# 2. 새 작업 폴더 생성
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

# 3. 앱 파일 복사
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# 4. Dockerfile 생성 (최신 파이썬 충돌 방지를 위해 3.9-slim 고정, > 기호 1개로 덮어쓰기)
echo "FROM python:3.9-slim" > tempdir/Dockerfile
echo "RUN pip install flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py" >> tempdir/Dockerfile

# 5. 빌드 및 실행
cd tempdir
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a