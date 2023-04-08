FROM golang:1.20-alpine as builder
WORKDIR /temp
RUN go install github.com/librespeed/speedtest-cli@v1.0.10

FROM alpine:3.17

USER root

COPY --from=builder /go/bin/speedtest-cli /bin/speedtest-cli

RUN apk add --no-cache sqlite tzdata shadow sudo \
    && addgroup -S runner && adduser -S runner -G runner \
    && mkdir /config

COPY entrypoint.sh /entrypoint
COPY run_test.sh /run_test.sh

RUN crontab -l | { cat; echo "/15 * * * * bash /run_test.sh"; } | crontab -

VOLUME /config

ENTRYPOINT ["/entrypoint"]
