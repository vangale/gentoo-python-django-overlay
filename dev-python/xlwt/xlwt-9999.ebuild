# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.999.ebuild,v 1.13 2008/01/17 18:13:59 grobian Exp $

ESVN_REPO_URI="https://secure.simplistix.co.uk/svn/xlwt/trunk/"

inherit python distutils eutils versionator subversion

DESCRIPTION="Read and write Excel files."
HOMEPAGE="http://groups.google.com/group/python-excel/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-lang/python"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_python_version

	site_pkgs="/usr/$(get_libdir)/python${PYVER}/site-packages/"
	export PYTHONPATH="${PYTHONPATH}:${D}/${site_pkgs}"
	dodir ${site_pkgs}

	distutils_src_install
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/xlwt
}

pkg_postrm() {
	python_mod_cleanup
}
