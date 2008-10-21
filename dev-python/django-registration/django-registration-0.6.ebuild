# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-2.3.ebuild,v 1.2 2008/07/09 18:45:02 corsair Exp $

inherit python distutils

DESCRIPTION="Generic user-registration application for Django projects."
HOMEPAGE="http://code.google.com/p/django-registration/"
SRC_URI="http://django-registration.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ppc64 ~s390 ~sparc x86"
IUSE=""

DEPEND="dev-lang/python dev-python/django"

src_install() {
	distutils_src_install
	dobin ${WORKDIR}/${PF}/registration/bin/delete_expired_users.py
	dodoc ${WORKDIR}/${PF}/docs/*.txt
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/registration
}

pkg_postrm() {
	python_mod_cleanup
}
