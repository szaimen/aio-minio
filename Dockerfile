FROM quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z

# Needed for Nextcloud AIO so that image cleanup can work. 
# Unfortunately, this needs to be set in the Dockerfile in order to work.
LABEL org.label-schema.vendor="Nextcloud"

# hadolint ignore=DL3002
USER root

CMD ["minio", "server", "/data"]
