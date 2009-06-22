# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils flag-o-matic

IUSE="debug"

DESCRIPTION="Remote service (network interface) for Tokyo Cabinet"
HOMEPAGE="http://tokyocabinet.sourceforge.net/"
SRC_URI="mirror://sourceforge/tokyocabinet/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="x86"
SLOT="0"

RDEPEND=">dev-db/tokyocabinet-1.4.20"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	econf
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	newconfd "${FILESDIR}"/conf tokyotyrant
	newinitd "${FILESDIR}"/init tokyotyrant
	keepdir /var/run/tokyotyrant /var/lib/tokyotyrant
}

#pkg_postinst() {
#	enewuser tokyotyrant -1 -1 /dev/null daemon
#}
