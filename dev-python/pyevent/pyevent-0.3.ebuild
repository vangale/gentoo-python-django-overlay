# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit distutils

DESCRIPTION="Python bindings for libevent"
HOMEPAGE="http://pyevent.googlecode.com/"
SRC_URI="http://pyevent.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	dev-libs/libevent"
RDEPEND="${DEPEND}"

DOCS="CHANGES LICENSE README"

src-install() {
	distutils_src_install
}
