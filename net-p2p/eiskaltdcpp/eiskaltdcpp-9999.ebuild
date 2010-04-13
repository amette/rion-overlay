# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

LANGS="be en hu ru"
inherit qt4-r2 cmake-utils subversion

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
ESVN_REPO_URI="http://${PN%pp}.googlecode.com/svn/branches/trunk/"
HOMEPAGE="http://eiskaltdc.googlecode.com/"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE="aspell"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	dev-libs/openssl
	net-libs/libupnp
	dev-libs/boost
	aspell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	for lang in ${LANGS}; do
		if use linguas_${lang}; then
			langs+="${lang} "
		fi
	done
	if [ "${langs}" = "" ]; then
		langs="en"
	fi
	local mycmakeargs=(
		-DFREE_SPACE_BAR_C="1"
		-DFREE_SPACE_BAR="0"
		"$(cmake-utils_use aspell USE_ASPELL)"
		-Dlinguas="${langs}"
	)
	cmake-utils_src_configure
}
