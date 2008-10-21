# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

HOMEPAGE="http://www.bananapos.com"
DESCRIPTION="BhPos common libraries"
SRC_URI="ftp://bananahead.com/pub/bhpos2/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=app-misc/bhpos_base-2.0.0
>=dev-libs/libxml2-2.6.0
>=dev-libs/openssl-0.9.7
>=dev-cpp/gtkmm-2.6.4
>=dev-libs/libusb-0.1.8
>=dev-libs/libxslt-1.1.0
>=dev-cpp/libxmlpp-2.5.8"
RDEPEND=""

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


	dodoc COPYING ChangeLog README INSTALL NEWS

}
