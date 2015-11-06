#!/usr/bin/env sh

git -C ${HOME}/git/firmware log --pretty=format:"%s %h" -- extra/git_hash | grep "kernel: Bump to [0-9].[0-9]*.[0-9]*" | cut -d' ' -f4,5 | while read version commit
  do
  v=(${version//./ })
  h=$(git -C ${HOME}/git/firmware show ${commit}:extra/git_hash | cut -c 1-7)
  sed -e "s/ versionator$//" -e "s/^EGIT_BRANCH=.*$/EGIT_BRANCH=\"rpi-${v[0]}.${v[1]}.y\"\nEGIT_COMMIT=\"${h}\"/" -e "s/^KEYWORDS=\"\"$/KEYWORDS=\"~arm\"/" ${HOME}/git/gentoo-overlay/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild > ${HOME}/git/gentoo-overlay/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.${v[2]}.ebuild
done
