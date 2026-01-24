# NVIDIA driver setup script for Fedora
#!/bin/bash

sudo dnf update -y # and reboot if you are not on the latest kernel
sudo dnf install -y akmod-nvidia  # rhel/centos users can use kmod-nvidia instead
sudo dnf install -y xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support

sudo dnf mark user akmod-nvidia

sudo dnf install -y vulkan

sudo dnf install -y xorg-x11-drv-nvidia-cuda-libs

sudo dnf install -y nvidia-vaapi-driver libva-utils vdpauinfo
