ARG BASE_IMAGE=ghcr.io/ublue-os/bazzite-gnome:stable

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS buildctx
COPY build_files /ctx/

FROM ${BASE_IMAGE} AS base

COPY system_files/etc/ /etc/
COPY system_files/usr/ /usr/

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
RUN --mount=type=bind,from=buildctx,source=/ctx,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

