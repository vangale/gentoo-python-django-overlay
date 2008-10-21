# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit distutils

MY_P=${P/unipath/Unipath}

DESCRIPTION="Object oriented filesystem access and pathname calculations."
HOMEPAGE="http://sluggo.scrapping.cc/python/unipath/"
SRC_URI="http://sluggo.scrapping.cc/python/unipath/${MY_P}.tar.gz"
LICENSE="PYTHON"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.txt"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
}
