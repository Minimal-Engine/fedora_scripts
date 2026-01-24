#!/bin/bash

sudo dnf update -y # and reboot if you are not on the latest kernel

sudo dnf remove fedora-media-writer -y
sudo dnf remove firefox firefox-langpacks anaconda-webui -y
