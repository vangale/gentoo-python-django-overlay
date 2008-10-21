# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.999.ebuild,v 1.13 2008/01/17 18:13:59 grobian Exp $

ESVN_REPO_URI="http://django-mailer.googlecode.com/svn/trunk/"

inherit python distutils eutils versionator subversion

DESCRIPTION="Mail queuing and management for the Django web framework."
HOMEPAGE="http://code.google.com/p/django-mailer/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-lang/python
	dev-python/django"

src_compile() {
	cd "${S}/mailerdev"
	distutils_src_compile
}

src_install() {
	distutils_python_version
	cd "${S}/mailerdev"
	distutils_src_install
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/mailer
}

pkg_postrm() {
	python_mod_cleanup
}
