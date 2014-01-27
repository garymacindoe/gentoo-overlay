# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator

MY_PN="Visual_Paradigm_for_UML_CE"
MY_PV="$(get_version_component_range 1-2)"
SRC_URI_FORMAT="amd64? ( http://%s.visual-paradigm.com/visual-paradigm/vpumlce${MY_PV}/$(get_version_component_range 3)/${MY_PN}_Linux_64bit_NoInstall_$(replace_all_version_separators _).tar.gz )
                x86? ( http://%s.visual-paradigm.com/visual-paradigm/vpumlce${MY_PV}/$(get_version_component_range 3)/${MY_PN}_Linux_NoInstall_$(replace_all_version_separators _).tar.gz )"

DESCRIPTION="Visual Paradigm for UML Community Edition"
HOMEPAGE="http://www.visual-paradigm.com/"
SRC_URI="$(printf "${SRC_URI_FORMAT} " eu{1..4} usa{5..6})"
LICENSE="as-is"

SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.5
         x11-misc/xdg-utils
         sys-auth/polkit"

S="${WORKDIR}/${MY_PN}_${MY_PV}"

INSTALL_DIR="/opt/${MY_PN}_${MY_PV}"

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r bin bundled integration launcher lib ormlib resources scripts sde shapes updatesynchronizer UserLanguage .install4j
    rm "${D}${INSTALL_DIR}/.install4j/firstrun"
    chmod +x "${D}${INSTALL_DIR}"/bin/*

    dodoc -r Samples

    dosym ${INSTALL_DIR}/bin/Visual_Paradigm_for_UML /opt/bin/Visual_Paradigm_for_UML

    make_desktop_entry Visual_Paradigm_for_UML "Visual Paradigm for UML CE" ${INSTALL_DIR}/resources/vpuml.png
    make_desktop_entry "pkexec ${INSTALL_DIR}/bin/VP-UML_Product_Edition_Manager" "VP UML Product Edition Manager" "${INSTALL_DIR}"/resources/vpuml.png
    dodir /etc/env.d
    cat - > "${D}"/etc/env.d/99vpumlce <<EOF
CONFIG_PROTECT="${INSTALL_DIR}/resources/product_edition.properties"
EOF
}
