# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="BhPos base, base system for BananaPOS, A Point Of Sale System."
HOMEPAGE="http://www.bananapos.com"
SRC_URI="ftp://bananahead.com/pub/bhpos2/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/DBI
	dev-perl/DBD-mysql"


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

	cat  ${D}/usr/share/bhpos2.0/schedule/*/* | grep -v "#" > ${D}/etc/cron.d/plusd
	fperms a+x ${D}/etc/cron.d/plusd

	dodoc COPYING ChangeLog INSTALL

}
