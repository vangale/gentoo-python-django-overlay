# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytz/pytz-2008a.ebuild,v 1.1 2008/04/03 21:53:33 lordvan Exp $

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="World Timezone Definitions for Python"
HOMEPAGE="http://pytz.sourceforge.net/"
SRC_URI="http://cheeseshop.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="!<=dev-python/matplotlib-0.82"

DOCS="CHANGES.txt"

src_test() {
	PYTHONPATH=. "${python}" pytz/tests/test_tzinfo.py || die "test failed"
}
