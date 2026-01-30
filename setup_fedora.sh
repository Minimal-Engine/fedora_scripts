# /bin/sh

# setup fastest mirror and parrallel downloads in dnf config
echo "fastestmirror=True
max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf

# setup rpmfusion repos
# see: https://rpmfusion.org/Configuration
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# install essential software

## Install VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code -y

## Install essential tools
sudo dnf install rclone tldr mpv nvim cmus tmux alacritty vim nvim zsh stow yt-dlp 
     \ vlc unison gnome-tweaks gtk-murrine-engine gh pass
     \ fastfetch mc -y

## Install steam
sudo dnf install steam -y

## install and configure git
sudo dnf install git -y
git config --global user.name "${USER}-${HOSTNAME}"
git config --global user.email "d.rzeszutek@icloud.com"
git config --global core.editor "nvim"

## install and start syncthing
sudo dnf install syncthing -y
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

## install yubikey-programs
sudo dnf install --skip-unavailable c
    wget gnupg2 \
    cryptsetup gnupg2-scdaemon pcsc-lite \
    yubikey-personalization-gui yubikey-manager

# install and setup additional codecs, fw and hw-acceleration for amd
# see https://rpmfusion.org/Howto/Multimedia
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y

sudo dnf install rpmfusion-free-release-tainted -y
sudo dnf install libdvdcss -y 

sudo dnf install rpmfusion-nonfree-release-tainted -y
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware" -y

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sh


# change standardshell to zsh
chsh -s $(which zsh)