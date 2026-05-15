# Bazzite with Dank Material Shell and Niri

This custom bazzite image is based on bazzite-gnome. It include dms and niri
along with all of the recommended extras for dms. My goal with this image is to
offer a vanilla dms/niri experience - though I have added ghostty...

To switch, run the following from a terminal in any Universal Blue or Fedora
Atomic based install:

```
sudo bootc switch ghcr.io/irunatbullets/bazzite-dms-niri
```

*Important Note:* When switching to this image the first run will backup any
existing niri configutation and replace it with the dms niri configs. This will
only happen once.

