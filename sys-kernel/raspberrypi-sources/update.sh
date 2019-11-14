#!/usr/bin/env sh

FIRMWARE="${HOME}/git/firmware"
OVERLAY="${HOME}/git/gentoo-overlay"
GENTOO="/var/db/repos/gentoo"

git -C "${FIRMWARE}" log --pretty=format:"%s %h" -- extra/git_hash | grep -E "^kernel: Bump to [0-9].[0-9]+.[0-9]+" | awk '{print $4,$NF}' | sort -V | while read version commit
  do
  v=(${version//./ })
  h=$(git -C "${FIRMWARE}" show ${commit}:extra/git_hash | cut -c 1-7)
  if [ ! -f "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" ] && [ -f "${GENTOO}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" ]
    then
    cp -v "${GENTOO}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild"
    ebuild "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" manifest
    git add "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" Manifest
    git commit -m"sys-kernel/raspberrypi-sources-${v[0]}.${v[1]}.9999: version bump"
  fi
  if [ -f "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" ] && [ ! -f "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.${v[2]}.ebuild" ]
    then
    sed -e "s/ versionator$//" -e "s/^EGIT_BRANCH=.*$/EGIT_BRANCH=\"rpi-${v[0]}.${v[1]}.y\"\nEGIT_COMMIT=\"${h}\"/" -e "s/^KEYWORDS=\"\"$/KEYWORDS=\"~arm\"/" "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.9999.ebuild" > "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.${v[2]}.ebuild"
    ebuild "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.${v[2]}.ebuild" manifest
    git add "${OVERLAY}/sys-kernel/raspberrypi-sources/raspberrypi-sources-${v[0]}.${v[1]}.${v[2]}.ebuild" Manifest
    git commit -m"sys-kernel/raspberrypi-sources-${v[0]}.${v[1]}.${v[2]}: version bump"
  fi
done
