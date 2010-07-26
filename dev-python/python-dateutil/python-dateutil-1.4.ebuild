# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Powerful extensions to the standard datetime module."
HOMEPAGE="http://labix.org/python-dateutil"
SRC_URI="http://labix.org/download/python-dateutil/${P}.tar.bz2"

LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="!<=dev-python/matplotlib-0.82"

DOCS="NEWS example.py sandbox/rrulewrapper.py sandbox/scheduler.py"

PYTHON_MODNAME="${PN/python-/}"

src_test() {
	"${python}" test.py
}
