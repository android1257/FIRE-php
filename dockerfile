FROM python:3.11-slim-bullseye

WORKDIR /usr/src/app

# 安装 PHP 8.1 需要的依赖项
RUN apt-get update && apt-get install -y \
    lsb-release ca-certificates apt-transport-https software-properties-common gnupg curl

# 添加 PHP 8.1 源（Sury.org）
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | tee /etc/apt/trusted.gpg.d/sury-php.gpg > /dev/null

# 更新并安装 PHP 8.1
RUN apt-get update && apt-get install -y php8.1

RUN apt-get update && apt-get install -y git libxml2 libjansson4 libyaml-0-2 vim

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0

COPY . .

# install redis
RUN apt install build-essential -y --no-install-recommends
RUN cd resource/redis-7.2.3 && \
    make && \
    make install && \
    cd .. && \
    rm -rf /usr/src/app/resource/redis-7.2.3

ENV JAVA_HOME "/usr/src/app/resource/jdk-17.0.11"
ENV PATH $PATH:$JAVA_HOME/bin

# CMD redis-server --port 6379

EXPOSE 8000

CMD redis-server --daemonize yes && python3 server.py