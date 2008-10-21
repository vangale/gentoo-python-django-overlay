# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.999.ebuild,v 1.13 2008/01/17 18:13:59 grobian Exp $

ESVN_REPO_URI="http://django-command-extensions.googlecode.com/svn/trunk/"

inherit python distutils eutils versionator subversion

DESCRIPTION="Django custom management command extensions."
HOMEPAGE="http://code.google.com/p/django-command-extensions/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE="graphviz"

DEPEND="dev-lang/python
	dev-python/django
	graphviz? ( media-gfx/graphviz dev-python/pygraphviz )"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_python_version
	distutils_src_install
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/django_extensions
}

pkg_postrm() {
	python_mod_cleanup
}
