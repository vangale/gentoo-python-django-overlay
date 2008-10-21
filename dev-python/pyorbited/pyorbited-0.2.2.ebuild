# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit distutils

DESCRIPTION="Python client for Orbited (a Comet server)"
HOMEPAGE="http://www.orbited.org/"
SRC_URI="http://pypi.python.org/packages/source/p/pyorbited/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	dev-python/demjson"
RDEPEND="${DEPEND}"

src-install() {
	distutils_src_install
}
