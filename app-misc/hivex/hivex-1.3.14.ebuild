# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AUTOTOOLS_IN_SOURCE_BUILD=1
USE_RUBY="ruby21 ruby23 ruby24"
RUBY_OPTIONAL=yes

PYTHON_COMPAT=(python2_7 python3_{3,4})

inherit autotools eutils perl-module ruby-ng python-single-r1

DESCRIPTION="Library for reading and writing Windows Registry 'hive' binary files"
HOMEPAGE="http://libguestfs.org"
SRC_URI="http://libguestfs.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ocaml +perl python readline ruby static-libs test"

RDEPEND="
	virtual/libiconv
	virtual/libintl
	dev-libs/libxml2:2
	ocaml? ( dev-lang/ocaml[ocamlopt]
			 dev-ml/findlib[ocamlopt]
			 )
	readline? ( sys-libs/readline:* )
	perl? ( dev-perl/IO-stringy )
	ruby? ( $(ruby_implementations_depend) )
	python? ( ${PYTHON_DEPS} )
	"

DEPEND="${RDEPEND}
	dev-lang/perl
	perl? (
		test? ( dev-perl/Pod-Coverage
			dev-perl/Test-Pod-Coverage )
		  )
	"

ruby_add_bdepend "ruby? ( dev-ruby/rake
			virtual/rubygems
			dev-ruby/rdoc )"
ruby_add_rdepend "ruby? ( virtual/rubygems )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DOCS=( README )
S="${WORKDIR}/all/${P}"

#We are aware of rather poor quality of this ebuild, but the bump is required to fix security bug. We will fix other matters later.

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	if use perl; then
		perl_set_version
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with readline)
		$(use_enable ocaml)
		$(use_enable perl)
		--enable-nls
		$(use_enable python)
		$(use_enable ruby)
		--disable-rpath )

	econf "${myeconfargs[@]}"

	if use perl; then
		pushd perl
		perl-module_src_configure
		popd
	fi
}

src_compile() {
	default
	use perl && perl-module_src_compile
}

# Test binding's dont't wok properly in gentoo layout
#src_test() {
#	if use perl;then
#		pushd perl
#		perl-app_src_install
#		popd
#	fi
#
#	autotools-utils_src_compile check
#}

src_install() {
	strip-linguas -i po

	emake install DESTDIR="${D}" "LINGUAS=""${LINGUAS}"""

	if use perl; then
		perl_delete_localpod
	fi
}
