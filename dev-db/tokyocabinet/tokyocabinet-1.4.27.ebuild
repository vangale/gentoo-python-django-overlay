# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils multilib

IUSE="debug"

DESCRIPTION="High performance hash database similar to DBM family, also supports B-tree databases"
HOMEPAGE="http://tokyocabinet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="x86"
SLOT="0"

RDEPEND=">=sys-libs/zlib-1.2.3
	>=app-arch/bzip2-1.0.5"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	econf \
		$(use_enable debug) \
		--enable-fastest \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	#dodoc ChangeLog NEWS README THANKS
	#dohtml *.html

	#rm -rf "${D}"/usr/share/${PN}

	#local u mydatadir=/usr/share/doc/${P}/html
}
