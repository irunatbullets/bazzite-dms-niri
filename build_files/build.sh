#!/bin/bash
set -ouex pipefail

IMAGE_NAME="${IMAGE_NAME:-bazzite-dms-niri}"
IMAGE_VARIANT="${IMAGE_VARIANT:-}"

if [ -z "$IMAGE_VARIANT" ]; then
  FULL_NAME="$IMAGE_NAME"
else
  FULL_NAME="${IMAGE_NAME}-${IMAGE_VARIANT}"
fi

IMAGE_REF="ostree-image-signed:docker://ghcr.io/irunatbullets/${FULL_NAME}"

dnf5 install -y tmux

dnf5 -y copr enable avengemedia/dms
dnf5 -y copr enable avengemedia/danklinux

dnf5 -y install \
    acl \
    breakpad \
    cliphist \
    cava \
    danksearch \
    dgop \
    dms \
    dms-greeter \
    ghostty \
    material-symbols-fonts \
    matugen \
    niri \
    qt6-qt5compat \
    qt6-qtimageformats \
    qt6-qtmultimedia \
    qt6-qtsvg \
    quickshell \
    wl-clipboard

dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable avengemedia/danklinux

dnf5 -y install rust cargo @development-tools dbus-devel xcb-util-cursor-devel clang git

(
    export CARGO_HOME=/tmp/cargo
    export RUSTUP_HOME=/tmp/rustup
    export CARGO_INSTALL_ROOT=/usr

    cargo install bluetui

    cd /tmp
    git clone https://github.com/Supreeeme/xwayland-satellite.git
    cd xwayland-satellite
    git checkout a879e5e

    cargo build --release
    install -Dm755 target/release/xwayland-satellite /usr/bin/xwayland-satellite
)

rm -rf /tmp/cargo /tmp/rustup /tmp/xwayland-satellite
dnf5 -y remove rust cargo @development-tools dbus-devel xcb-util-cursor-devel clang git

systemctl enable podman.socket
systemctl --global enable dms

systemctl disable gdm
systemctl enable greetd

mkdir -p /var/cache/dms-greeter

tee /usr/lib/sysusers.d/greeter.conf <<'EOF'
g greeter 767
u greeter 767 "greetd greeter" /var/lib/greeter
EOF

mkdir -p /var/lib/greeter
chown 767:767 /var/lib/greeter

mkdir -p /usr/lib/systemd/user/graphical-session.target.wants

ln -s /usr/lib/systemd/user/dms-niri-config.service \
    /usr/lib/systemd/user/graphical-session.target.wants/dms-niri-config.service

ln -s /usr/lib/systemd/user/dsearch.service \
    /usr/lib/systemd/user/graphical-session.target.wants/dsearch.service

jq \
  --arg name "$FULL_NAME" \
  --arg ref "$IMAGE_REF" \
  --arg tag "${IMAGE_VARIANT:-latest}" \
  '
  .["image-name"]=$name |
  .["image-ref"]=$ref |
  .["image-tag"]=$tag
  ' \
  /usr/share/ublue-os/image-info.json \
  > /tmp/image-info.json && mv /tmp/image-info.json /usr/share/ublue-os/image-info.json

