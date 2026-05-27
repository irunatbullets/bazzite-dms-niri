# bazzite-dms-niri

This custom **Bazzite** image is based on `bazzite-gnome`. It includes **Dank
Material Shell** and **niri** along with all of the recommended extras for
Dank Linux.

My goal with this image is to offer a vanilla DMS/niri experience with gaming
capabilities (via Bazzite). I have added **ghostty** as the default termianl
along with tools to allow developers to create their own DMS plugins.

Feel free to suggest additional software - or just fork this repo and do
whatever you like.

To switch, run the following from a terminal in any Universal Blue or Fedora
Atomic based install:

```
sudo bootc switch ghcr.io/irunatbullets/bazzite-dms-niri
sudo bootc switch ghcr.io/irunatbullets/bazzite-dms-niri-nvidia
```

**Important Note:** After switching to this image the login will backup any
existing niri configutation and replace it with standard dms niri configs.
Updates will not retrigger this event.

## What my selection of additional applications achieve

- **ghostty** - nothing, I just switched to it when I started using dms.
- **bluetui** - an application for configuring multiple Bluetooth receivers.

## Known issues and workarounds

### How do I change the dms greeter's background?!

To enable background image syncing with the dms greeter, run the
following from your terminal and follow the steps:

```
dms greeter sync
```
I would like to automate this in future but I'm simply not smart or patient
enough to do it at the moment.

### Matugen isn't themeing my flatpak apps!

Matugen can theme flatpaks by running the following (restart any running apps):

```
sudo flatpak override \
--filesystem=xdg-config/gtk-3.0:rw \
--filesystem=xdg-config/gtkrc-2.0:rw \
--filesystem=xdg-config/gtk-4.0:rw \
--filesystem=xdg-config/gtkrc:rw
```

### The capslock indicator widget doesn't work!

You have to add yourself to the `input` group like this, and then reboot.

```
ujust add-user-to-input-group
```

## Credits:

- https://bazzite.gg/
- https://danklinux.com/
- https://github.com/niri-wm/niri
- https://github.com/bazzirco/bazzirco (for the dms-greeter workaround)

## Thanks!

