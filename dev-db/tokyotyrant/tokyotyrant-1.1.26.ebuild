# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils multilib

IUSE="debug"

DESCRIPTION="Remote service (network interface) for Tokyo Cabinet"
HOMEPAGE="http://tokyocabinet.sourceforge.net/"
SRC_URI="mirror://sourceforge/tokyocabinet/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="x86"
SLOT="0"

RDEPEND="dev-db/tokyocabinet"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
