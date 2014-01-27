# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="Utilities for app-misc/twin"
SRC_URI="http://downloads.sourceforge.net/project/twin/twutils/${PV}/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/twin/"
KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="app-misc/twin"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-extra-qt-qualification.patch"
}
