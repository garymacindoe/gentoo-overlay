#!/usr/bin/env sh

for sublevel in 0 1 2 3
  do
  git -C ${HOME}/git/linux log --pretty=format:"%s %h" origin/rpi-4.${sublevel}.y | grep "^Linux 4.${sublevel}[.0-9]* " | while read linux version hash
    do
    sed -e "s/ versionator$//" -e "s/^EGIT_BRANCH=.*$/EGIT_BRANCH=\"rpi-4.${sublevel}.y\"\nEGIT_COMMIT=\"${hash}\"/" -e "s/^KEYWORDS=\"\"$/KEYWORDS=\"~arm\"/" ${HOME}/git/gentoo-overlay/sys-kernel/raspberrypi-sources/raspberrypi-sources-4.${sublevel}.9999.ebuild > ${HOME}/git/gentoo-overlay/sys-kernel/raspberrypi-sources/raspberrypi-sources-${version}.ebuild
  done
  mv ${HOME}/git/gentoo-overlay/sys-kernel/raspberrypi-sources/raspberrypi-sources-4.${sublevel}.ebuild ${HOME}/git/gentoo-overlay/sys-kernel/raspberrypi-sources/raspberrypi-sources-4.${sublevel}.0.ebuild
done
