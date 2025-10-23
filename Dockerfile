# syntax=docker/dockerfile:latest
FROM golang:1.25.3-alpine3.22 AS go

ENV MINIO_VERSION=RELEASE.2025-10-15T17-29-55Z
ENV GOPATH=/go
ENV CGO_ENABLED=0

WORKDIR /build

RUN set -ex; \
    apk upgrade --no-cache -a; \
    apk add --no-cache \
        build-base; \
    go install github.com/minio/minio@$MINIO_VERSION;

FROM alpine:3.22.2
RUN set -ex; \
    apk upgrade --no-cache -a; \
    apk add --no-cache \
        tzdata \
        ca-certificates

COPY --from=go --chmod=775 /go/bin/minio /usr/local/bin/minio

EXPOSE 9000

VOLUME ["/data"]

LABEL com.centurylinklabs.watchtower.enable="false" \
    org.label-schema.vendor="Nextcloud"

# Needed for Nextcloud AIO so that image cleanup can work. 
# Unfortunately, this needs to be set in the Dockerfile in order to work.
LABEL org.label-schema.vendor="Nextcloud"

# hadolint ignore=DL3002
USER root

CMD ["minio", "server", "/data"]
