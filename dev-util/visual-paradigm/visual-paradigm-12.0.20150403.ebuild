# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator

MY_PN="Visual_Paradigm_CE"
MY_PV="$(get_version_component_range 1-2)"

SRC_URI_FORMAT="amd64? ( http://www.visual-paradigm.com/downloads/%s/vpce/Visual_Paradigm_CE_Linux64_InstallFree.tar.gz )
                x86? ( http://www.visual-paradigm.com/downloads/%s/vpce/Visual_Paradigm_CE_Linux32_InstallFree.tar.gz )"

DESCRIPTION="Visual Paradigm Community Edition"
HOMEPAGE="http://www.visual-paradigm.com/"
SRC_URI="$(printf "${SRC_URI_FORMAT} " {usa10,usa11,usa12,ca1,uk3,france2,germany4,germany5,europe3})"
LICENSE="as-is"

SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}_${MY_PV}"

INSTALL_DIR="/opt/${MY_PN}_${MY_PV}"

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r Application .install4j Visual_Paradigm
    chmod +x "${D}${INSTALL_DIR}"/Application/bin/* "${D}${INSTALL_DIR}"/Visual_Paradigm

    dodoc -r Application/samples

    dosym ${INSTALL_DIR}/Visual_Paradigm /opt/bin/Visual_Paradigm

    make_desktop_entry Visual_Paradigm "Visual Paradigm" ${INSTALL_DIR}/Application/resources/vpuml.png
    dodir /etc/env.d
    cat - > "${D}"/etc/env.d/99visual-paradigm <<EOF
CONFIG_PROTECT="${INSTALL_DIR}/Application/resources/product_edition.properties"
EOF
}
