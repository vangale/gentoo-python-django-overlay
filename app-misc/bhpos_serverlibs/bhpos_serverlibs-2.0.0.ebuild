# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="BhPos serverlibs"
HOMEPAGE="http://www.bananapos.com"
SRC_URI="ftp://bananahead.com/pub/bhpos2/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND=">=app-misc/bhpos_base-2.0.0
>=app-misc/bhpos_commonlibs-2.0.0
>=dev-db/mysql-4.1.10"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}


src_compile() {


	econf || die
	emake || die "emake failed"
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
	install DESTDIR=${D} || die

	dodoc AUTHORS COPYING ChangeLog README INSTALL NEWS
}
