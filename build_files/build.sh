#!/bin/bash

set -ouex pipefail
cp -avf /ctx/files/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

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
    quickshell \
    wl-clipboard \
    xwayland-satellite

dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable avengemedia/danklinux

### Example for enabling a System Unit File (I'll just leave this here for now)

systemctl enable podman.socket

### Add single-run bootstrap for adding the proper default niri configs for dms

systemctl --global enable bazzite-user-bootstrap.service

### Setup dms and dms-search

systemctl --global enable dsearch
systemctl --global enable dms

### Setup dms-greeter

systemctl disable gdm
systemctl enable greetd

mkdir -p /var/cache/dms-greeter

# REQUIRED for dms-greeter to work (taken from bazzirco)
tee /usr/lib/sysusers.d/greeter.conf <<'EOF'
g greeter 767
u greeter 767 "Greetd greeter"
EOF

