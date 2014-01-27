# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Text mode window environment for Linux"
SRC_URI="http://downloads.sourceforge.net/project/twin/twin/${PV}/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/twin/"
KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="ggi gtk ncurses static unicode X xml"

DEPEND="X? ( x11-libs/libX11
	gtk? ( x11-libs/gtk+:1 )
	ggi? ( =media-libs/libggi-2* ) )
	ncurses? ( sys-libs/ncurses )
	sys-libs/gpm"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable unicode -unicode) \
		$(use_enable static) \
		$(use_enable gtk tt-hw-gtk) \
		$(use_enable ggi hw-ggi) \
		$(use_enable ncurses hw-tty-termcap) \
		$(use_enable xml tt-hw-xml) \
		$(use_with X x)
}

src_compile() {
	emake -j1 || die "emake compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README BUGS docs/Compatibility docs/Configure docs/diagram.txt docs/FAQ docs/libTT-design.txt docs/libTw.txt docs/ltrace.conf docs/Philosophy docs/Tutorial || die "dodoc failed"
	doman docs/twin.1 || die "doman failed"
}
