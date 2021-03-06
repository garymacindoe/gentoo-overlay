# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ETYPE=sources
K_DEFCONFIG="bcmrpi_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

EGIT_REPO_URI=https://github.com/raspberrypi/linux.git
EGIT_BRANCH="rpi-4.4.y"
EGIT_COMMIT="af9619c"
EGIT_CHECKOUT_DIR="${S}"
inherit git-r3

DESCRIPTION="Raspberry PI kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"

KEYWORDS="~arm ~arm64"

src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}
