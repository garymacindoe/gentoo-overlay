# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="openBVE is a free-as-in-freedom train simulator placed in the public domain"
HOMEPAGE="http://openbve.trainsimcentral.co.uk/"
SRC_URI="http://openbve.trainsimcentral.co.uk/common/openbve_stable.zip
         http://openbve.trainsimcentral.co.uk/common/tao.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2
         media-libs/openal
         dev-lang/mono"

S="${WORKDIR}"

src_install() {
  insinto "${GAMES_DATADIR}"/${PN}
  doins -r "${S}"/* || die "Install failed!"
  dodoc COPYING Readme.txt

  doicon "${FILESDIR}"/OpenBve.xpm
  make_desktop_entry "/usr/bin/mono ${GAMES_DATADIR}/${PN}/OpenBve.exe" OpenBVE OpenBve Game Path="${GAMES_DATADIR}"/${PN}

  prepgamesdirs
}
