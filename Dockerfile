FROM node:20

# 安装 OpenCV 编译所需的最小依赖
RUN apt-get update && apt-get install -y \
  build-essential cmake git pkg-config libjpeg-dev \
  libpng-dev libtiff-dev libavcodec-dev libavformat-dev \
  libswscale-dev libv4l-dev libx264-dev libxvidcore-dev \
  libgtk-3-dev python3-dev python3-numpy curl unzip

# 安装 Python 用于 opencv 编译时探测
RUN ln -s /usr/bin/python3 /usr/bin/python

# 设置工作目录
WORKDIR /app

# 拷贝项目文件
COPY . .

# 设置环境变量，避免 build 时自动下载 contrib 等扩展模块
ENV OPENCV4NODEJS_DISABLE_AUTOBUILD=0 \
    OPENCV4NODEJS_BUILD_CUDA=0 \
    OPENCV4NODEJS_SKIP_BUILD_TIME_DEPENDENCIES=1

# 安装 Node 依赖（包含 opencv4nodejs）
RUN npm install
RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start"]
