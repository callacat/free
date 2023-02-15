FROM golang:alpine as builder

RUN apk add --no-cache make git curl
WORKDIR /proxypool-src
COPY . /proxypool-src
RUN go mod download && \
    make docker && \
    mv ./bin/proxypool-docker /proxypool

FROM alpine:latest
ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /proxypool-src
COPY ./assets /proxypool-src/assets
COPY ./config /proxypool-src/config
COPY --from=builder /proxypool /proxypool-src/
CMD ["/proxypool-src/proxypool", "-d"]
