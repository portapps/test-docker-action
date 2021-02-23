#syntax=docker/dockerfile:1.2
FROM golang:alpine as hello
RUN echo 'hello!' > /tmp/hello.txt
RUN --mount=type=secret,id=MULTILINE,target=/tmp/secret cat /tmp/secret

FROM hello as build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I'm running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

FROM alpine
COPY --from=build /log /log

FROM alpine as copy
COPY . .
RUN ls -al

FROM alpine
RUN apk add util-linux
RUN cat /proc/cpuinfo && uname -mp && uname -a && arch
RUN apk --update add \
    build-base \
    gcc \
    git \
    jansson-dev \
    libcap-dev \
    libffi-dev \
    libressl-dev \
    libxml2-dev \
    linux-headers \
    mariadb-dev \
    musl-dev \
    pcre-dev \
    postgresql-dev \
    zlib-dev \
    bash \
    curl \
    libgd \
    mysql-client \
    nginx \
    php7 \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-phar \
    php7-session \
    php7-simplexml \
    php7-sodium \
    php7-tokenizer \
    php7-xml \
    php7-xmlwriter \
    php7-zip \
    php7-zlib \
    php7-pecl-uuid \
    shadow \
    su-exec \
    tar \
    tzdata

ENV DOCKER_VERSION="20.10.3"
RUN set -x; wget -q "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -qO "/tmp/docker.tgz" \
  && tar --extract --file /tmp/docker.tgz --strip-components 1 --directory /usr/local/bin/

ENV BUILDKIT_VERSION="0.8.1"
RUN set -x; wget -q "https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz" -qO "/tmp/buildkit.tar.gz" \
  && tar -xzf /tmp/buildkit.tar.gz --strip 1 -C /usr/local/bin/

ENV BUILDX_VERSION="0.5.1"
RUN mkdir -p /usr/libexec/docker/cli-plugins \
  && set -x; wget -q "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64" -qO "/usr/libexec/docker/cli-plugins/docker-buildx" \
  && chmod +x /usr/libexec/docker/cli-plugins/docker-buildx

RUN apk --update add \
    bash \
    ca-certificates \
    docker-compose \
    git \
    openssh-client

RUN docker --version \
  && buildkitd --version \
  && buildctl --version \
  && docker buildx version \
  && docker-compose --version
