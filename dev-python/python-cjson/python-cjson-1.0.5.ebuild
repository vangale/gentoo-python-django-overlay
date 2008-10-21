# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit distutils

DESCRIPTION="Fast JSON encoder/decoder for Python"
HOMEPAGE="http://ag-projects.com/"
SRC_URI="http://pypi.python.org/packages/source/p/python-cjson/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

DOCS="CHANGES LICENSE README"

src-install() {
	distutils_src_install
}
