# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Tool to handle BCL conversion and demultiplexing"
HOMEPAGE="https://support.illumina.com/downloads/bcl2fastq_conversion_software_184.ilmn"
SRC_URI="ftp://webdata:webdata@ussd-ftp.illumina.com//Downloads/Software/bcl2fastq/bcl2fastq-1.8.4.tar.bz2"

IUSE="+boost +cmake debug eclipse static test"

LICENSE="Proprietary"
SLOT="1.8"
KEYWORDS="~amd64 ~x86"

RDEPEND="boost? ( =dev-libs/boost-1.4* )
         >=dev-lang/perl-5.8
         dev-libs/libxslt
         dev-libs/libxml2
         app-arch/bzip2
         sys-libs/zlib"

DEPEND="${RDEPEND}
        cmake? ( dev-util/cmake )"

S="${WORKDIR}/${PN}-build"

TMP="${WORKDIR}"
SOURCE="${WORKDIR}/${PN}"
BUILD="${WORKDIR}/${PN}-build"

src_unpack() {
  unpack "${A}"
  mkdir "${S}" || die "Unable to create build directory"
}

src_configure() {
  local ECONF_ARGS="--prefix=\"${EPREFIX}/usr\""

  if use debug; then
    ECONF_ARGS+=" --build-type=\"Debug\""
  else
    ECONF_ARGS+=" --build-type=\"Release\""
  fi

  use cmake   && ECONF_ARGS+=" --with-cmake=\"${EPREFIX}/usr/bin/cmake\""
  use eclipse && ECONF_ARGS+=" --with-eclipse"
  use static  && ECONF_ARGS+=" --static"
  use test    && ECONF_ARGS+=" --with-unit-tests"

  if use boost; then
    ${SOURCE}/src/configure BOOST_ROOT="${EPREFIX}/usr" \
                            BOOST_INCLUDEDIR="${EPREFIX}/usr/include/boost" \
                            BOOST_LIBRARYDIR="${EPREFIX}/usr/lib" \
                            ${ECONF_ARGS} || die "Failed running configure"
  else
    ${SOURCE}/src/configure ${ECONF_ARGS} || die "Failed running configure"
  fi
}

src_install() {
  emake DESTDIR="${D}" install || die "Install failed"
  rm -r ${D}/${EPREFIX}/usr/bin/test || die "Unable to remove test directory"
}
