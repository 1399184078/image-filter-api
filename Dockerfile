FROM node:20

# 安装 OpenCV 所需依赖
RUN apt-get update && apt-get install -y \
  build-essential cmake git pkg-config libgtk-3-dev \
  libavcodec-dev libavformat-dev libswscale-dev \
  libv4l-dev libxvidcore-dev libx264-dev \
  libjpeg-dev libpng-dev libtiff-dev \
  gfortran openexr libatlas-base-dev \
  python3-dev python3-numpy libtbb2 libtbb-dev \
  libdc1394-22-dev libopenblas-dev liblapack-dev

# 设置工作目录
WORKDIR /app

# 拷贝并安装依赖
COPY . .
RUN npm install
RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start"]
