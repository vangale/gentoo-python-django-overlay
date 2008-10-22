# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit distutils

MY_P="${P/minimalist-/}"
DESCRIPTION="Minimalist Twitter API and command-line tool for Python"
HOMEPAGE="http://mike.verdone.ca/twitter/"
SRC_URI="http://mike.verdone.ca/twitter/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE="irc"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/simplejson-1.7.1
	>=dev-python/python-dateutil-1.1
	irc? ( dev-python/python-irclib )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/"

src_install() {
        distutils_src_install
}

pkg_postinst() {
        python_version
        python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/twitter
}

pkg_postrm() {
        python_mod_cleanup
}
