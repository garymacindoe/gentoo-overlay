# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib readme.gentoo systemd user git-r3 autotools

DESCRIPTION="Service providing elegant and stable means of managing Optimus graphics chipsets"
HOMEPAGE="http://bumblebee-project.org https://github.com/Bumblebee-Project/Bumblebee"
EGIT_REPO_URI="https://github.com/Bumblebee-Project/Bumblebee.git"
EGIT_BRANCH="develop"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS=""

IUSE="+bbswitch video_cards_nouveau video_cards_nvidia"

RDEPEND="
	dev-libs/libbsd
  sys-apps/kmod
	virtual/opengl
	x11-base/xorg-drivers[video_cards_nvidia?,video_cards_nouveau?]
	x11-misc/virtualgl:=
	bbswitch? ( sys-power/bbswitch )
"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	sys-apps/help2man
	virtual/pkgconfig
	x11-libs/libX11
"

REQUIRED_USE="|| ( video_cards_nouveau video_cards_nvidia )"

src_prepare() {
  eautoreconf || die "autoconf failed"
}

src_configure() {
	DOC_CONTENTS="In order to use Bumblebee, add your user to 'bumblebee' group.
		You may need to setup your /etc/bumblebee/bumblebee.conf"

	if use video_cards_nvidia ; then
		# Get paths to GL libs for all ABIs
		local nvlib=""
		for i in  $(get_all_libdirs) ; do
			nvlib="${nvlib}:/usr/${i}/opengl/nvidia/lib"
		done

		local nvpref="/usr/$(get_libdir)/opengl/nvidia"
		local xorgpref="/usr/$(get_libdir)/xorg/modules"
		ECONF_PARAMS="CONF_DRIVER=nvidia CONF_DRIVER_MODULE_NVIDIA=nvidia \
			CONF_LDPATH_NVIDIA=${nvlib#:} \
			CONF_MODPATH_NVIDIA=${nvpref}/lib,${nvpref}/extensions,${xorgpref}/drivers,${xorgpref}"
	fi

	econf \
		--docdir=/usr/share/doc/"${PF}" \
		${ECONF_PARAMS}
}

src_install() {
	newconfd "${FILESDIR}"/bumblebee.confd bumblebee
	newinitd "${FILESDIR}"/bumblebee.initd bumblebee
	newenvd  "${FILESDIR}"/bumblebee.envd 99bumblebee
	systemd_dounit scripts/systemd/bumblebeed.service

	readme.gentoo_create_doc

	default
}

pkg_preinst() {
	use video_cards_nvidia || rm "${ED}"/etc/bumblebee/xorg.conf.nvidia
	use video_cards_nouveau || rm "${ED}"/etc/bumblebee/xorg.conf.nouveau

	enewgroup bumblebee
}
