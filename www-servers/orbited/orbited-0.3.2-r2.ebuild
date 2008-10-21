# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted/twisted-2.5.0.ebuild,v 1.2 2007/02/13 13:24:02 vapier Exp $

inherit eutils distutils

DESCRIPTION="Highly scalable web server for real-time applications"
HOMEPAGE="http://orbited.org"
SRC_URI="http://pypi.python.org/packages/source/o/orbited/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE="libevent"

DEPEND=">=dev-lang/python-2.3
	libevent? ( dev-python/pyevent )
	dev-python/python-cjson"

DOCS="CREDITS INSTALL NEWS README"

src_install() {
	keepdir /var/log/${PN}

	distutils_src_install

	newconfd "${FILESDIR}/orbited.conf" orbited
	newinitd "${FILESDIR}/orbited.init" orbited

	dodir "${ROOT}"/etc/${PN}
	insinto "${ROOT}"/etc/${PN}
	doins conf/*

}
