# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.999.ebuild,v 1.13 2008/01/17 18:13:59 grobian Exp $

ESVN_REPO_URI="http://django-logging.googlecode.com/svn/trunk/"

inherit python eutils versionator subversion

DESCRIPTION="A Django wrapper to Python's logging module."
HOMEPAGE="http://code.google.com/p/django-logging/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-lang/python
	dev-python/django"

src_install() {
	python_version
	python_enable_pyc
	dodoc ${WORKDIR}/${PF}/djangologging/LICENCE
	mkdir -p ${D}usr/$(get_libdir)/python${PYVER}/site-packages
	cp -pr ${WORKDIR}/${PF}/djangologging ${D}usr/$(get_libdir)/python${PYVER}/site-packages
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/djangologging
}

pkg_postrm() {
	python_mod_cleanup
}
