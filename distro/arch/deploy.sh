#!/bin/bash

set -ex
cd distro/arch

# Set up to run makepkg
wget https://www.archlinux.org/packages/core/x86_64/pacman/download/ -O pacman.pkg.tar.xz
tar -Jxf pacman.pkg.tar.xz
bindir="$(pwd)/usr/bin"
export PATH="$bindir:$PATH"
export LIBRARY="$(pwd)/usr/share/makepkg"
config="$(pwd)/etc/makepkg.conf"


# Get the repo
git config --global --add core.sshCommand "ssh -o StrictHostKeyChecking=false -i /tmp/aurkey"
git clone ssh://aur@aur.archlinux.org/amdgpu-fan.git aur

# Update it
cp PKGBUILD aur
cd aur
/bin/bash "$bindir/makepkg" --config="$config" --printsrcinfo >.SRCINFO

# Commit
git add PKGBUILD .SRCINFO
git config user.email "chestm007+aurci@hotmail.com"
git config user.name "chestm007-ci"
git commit -m "Release $CIRCLE_TAG"

# Deploy to AUR
git push origin master
