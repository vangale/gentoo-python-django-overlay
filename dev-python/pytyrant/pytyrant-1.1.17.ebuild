# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Pure python client implementation of Tokyo Tyrant protocol"
HOMEPAGE="http://pypi.python.org/pypi/pytyrant/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="dev-db/tokyotyrant"
