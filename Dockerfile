# syntax = docker/dockerfile:experimental
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

FROM alpine as qemu
RUN apk add util-linux
RUN cat /proc/cpuinfo && uname -mp && uname -a && arch
RUN fallocate -l 2G huge.img
