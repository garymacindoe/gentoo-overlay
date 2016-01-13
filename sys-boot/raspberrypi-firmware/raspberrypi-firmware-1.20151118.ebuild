# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

[[ ${PV} == *9999 ]] && SCM="git-r3"

inherit readme.gentoo ${SCM}

DESCRIPTION="Raspberry PI boot loader and firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"

if [[ ${PV} == *9999 ]]; then
  EGIT_REPO_URI=https://github.com/raspberrypi/firmware.git
  KEYWORDS=""
  S="${WORKDIR}/${P}/boot"
else
  SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"
  KEYWORDS="~arm"
  S="${WORKDIR}/firmware-${PV}/boot"
fi


LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"

RESTRICT="binchecks strip"

src_unpack() {
  if [[ ${PV} == *9999 ]]; then
    git-r3_src_unpack
  else
    unpack ${A}
  fi
}

pkg_preinst() {
	if [ -z "${REPLACING_VERSIONS}" ] ; then
		local msg=""
		if [ -e "${D}"/boot/cmdline.txt -a -e /boot/cmdline.txt ] ; then
			msg+="/boot/cmdline.txt "
		fi
		if [ -e "${D}"/boot/config.txt -a -e /boot/config.txt ] ; then
			msg+="/boot/config.txt "
		fi
		if [ -n "${msg}" ] ; then
			msg="This package installs following files: ${msg}."
			msg="${msg} Please remove(backup) your copies durning install"
			msg="${msg} and merge settings afterwards."
			msg="${msg} Further updates will be CONFIG_PROTECTed."
			die "${msg}"
		fi
	fi
}

src_install() {
	insinto /boot
	local a
	for a in bootcode.bin fixup{,_cd,_db,_x}.dat start{,_cd,_db,_x}.elf ; do
		newins "${S}"/${a} ${a}
	done
	newins "${FILESDIR}"/config.txt config.txt
	newins "${FILESDIR}"/cmdline.txt cmdline.txt
	newenvd "${FILESDIR}"/envd 90${PN}
	readme.gentoo_create_doc
}

DOC_CONTENTS="Please configure your ram setup by editing /boot/config.txt"
