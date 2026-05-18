#!/bin/bash
set -ouex pipefail

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

### Build fresh xwayland-satellite (and sneak bluetui in)
dnf5 -y install rust cargo @development-tools dbus-devel xcb-util-cursor-devel clang git
(
    export CARGO_HOME=/tmp/cargo
    export RUSTUP_HOME=/tmp/rustup
    export CARGO_INSTALL_ROOT=/usr

    # If we have 2 bluetooth receivers, we need an easy way to access them!
    cargo install bluetui

    # Build xwayland-satellite from specific commit
    cd /tmp
    git clone https://github.com/Supreeeme/xwayland-satellite.git
    cd xwayland-satellite
    git checkout a879e5e

    cargo build --release

    install -Dm755 target/release/xwayland-satellite /usr/bin/xwayland-satellite
)
rm -rf /tmp/cargo /tmp/rustup /tmp/xwayland-satellite
dnf5 -y remove rust cargo @development-tools dbus-devel xcb-util-cursor-devel clang git

### Example for enabling a System Unit File (I'll just leave this here for now)
systemctl enable podman.socket

### Setup dms
systemctl --global enable dms

### Setup dms-greeter
systemctl disable gdm
systemctl enable greetd

mkdir -p /var/cache/dms-greeter

# REQUIRED for dms-greeter to work
tee /usr/lib/sysusers.d/greeter.conf <<'EOF'
g greeter 767
u greeter 767 "greetd greeter" /var/lib/greeter
EOF

mkdir -p /var/lib/greeter
chown 767:767 /var/lib/greeter

### Setup user services
mkdir -p /usr/lib/systemd/user/graphical-session.target.wants
ln -s /usr/lib/systemd/user/dms-niri-config.service \
    /usr/lib/systemd/user/graphical-session.target.wants/dms-niri-config.service

ln -s /usr/lib/systemd/user/dsearch.service \
    /usr/lib/systemd/user/graphical-session.target.wants/dsearch.service

