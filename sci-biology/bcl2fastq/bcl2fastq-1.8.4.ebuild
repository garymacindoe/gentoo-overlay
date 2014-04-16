# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Tool to handle BCL conversion and demultiplexing"
HOMEPAGE="https://support.illumina.com/downloads/bcl2fastq_conversion_software_184.ilmn"
SRC_URI="ftp://webdata:webdata@ussd-ftp.illumina.com//Downloads/Software/bcl2fastq/bcl2fastq-1.8.4.tar.bz2"

IUSE="+boost +cmake debug eclipse static test"

LICENSE="Proprietary"
SLOT="1.8"
KEYWORDS="~amd64 ~x86"

RDEPEND="boost? ( =dev-libs/boost-1.4* )
         >=dev-lang/perl-5.8
         dev-perl/XML-Simple
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

src_prepare() {
  cd "${WORKDIR}" && epatch "${FILESDIR}/${P}-casava-config.patch"
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
  sed -i -e "s,${D},/,g" \
    ${D}/${EPREFIX}/usr/bin/configureBclToFastq.pl \
    ${D}/${EPREFIX}/usr/bin/configureQseqToFastq.pl \
    ${D}/${EPREFIX}/usr/bin/configureValidation.pl \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Alignment.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/BaseCalls.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Common/Utils.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Demultiplex/DemultiplexConfig.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Demultiplex/Dx.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Demultiplex/SampleSheet.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Demultiplex.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/Intensities.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/PostAlignment/Plugins.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/PostAlignment/Sequencing/Config.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/PostAlignment/Sequencing/ExportToBam.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/PostAlignment/Sequencing/RmDupAndSplit.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/PostAlignment/Sequencing/SamLib.pm \
    ${D}/${EPREFIX}/usr/lib/bcl2fastq-1.8.4/perl/Casava/PostAlignment/Sequencing/Target.pm \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/Alignment/configureDataset.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/Alignment/printSampleSheetXml.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/copyConfig.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/create_IVC_thumbnail.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/create_tile_thumbnails.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/finishFastq.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/plotIntensity_for_IVC.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/plotIntensity_tiles.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/BaseCalls/produceIntensityStats.pl \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/loggingShell.sh \
    ${D}/${EPREFIX}/usr/libexec/bcl2fastq-1.8.4/transformFasta.pl \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/100723_EAS346_0188_FC626BWAAXX/Aligned/ValidationConfig.txt \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/100723_EAS346_0188_FC626BWAAXX/Build/Project_FC626BWAAXX/Sample_lane4/ValidationConfig.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/100723_EAS346_0188_FC626BWAAXX/Build/Project_FC626BWAAXX/Sample_lane8/ValidationConfig.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/110120_P20_0993_A805CKABXX/Aligned/ValidationConfig.txt \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/110120_P20_0993_A805CKABXX/Build/Project_Demo/Sample_AR008/ValidationConfig.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/110120_P20_0993_A805CKABXX/Build/Project_Demo/Sample_PhiX/ValidationConfig.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/Default/Aligned/ValidationConfig.txt \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/Default/Build/Project_FC626BWAAXX/Sample_lane4/ValidationConfig.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/examples/Validation/Default/Build/Project_FC626BWAAXX/Sample_lane8/ValidationConfig.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/makefiles/Config.mk \
    ${D}/${EPREFIX}/usr/share/bcl2fastq-1.8.4/makefiles/Validation/Makefile || die "Failed to update paths"
  rm -r ${D}/${EPREFIX}/usr/bin/test || die "Unable to remove test directory"
}
