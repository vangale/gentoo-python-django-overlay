# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openerp-server/openerp-server-4.0.3.ebuild,v 1.4 2008/05/21 15:53:11 dev-zero Exp $

inherit eutils distutils

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://openerp.com/"
SRC_URI="http://openerp.com/download/stable/sources/tinyerp-server-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=virtual/postgresql-server-7.4
	dev-python/pypgsql
	dev-python/reportlab
	dev-python/pyparsing
	media-gfx/pydot
	=dev-python/psycopg-1*
	dev-libs/libxml2
	dev-libs/libxslt
	dev-python/pychart"

OPENERP_USER=terp
OPENERP_GROUP=terp

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-setup.patch
}

pkg_setup() {
	if ! built_with_use dev-libs/libxslt python ; then
		eerror "dev-libs/libxslt must be built with python"
		die "${PN} requires dev-libs/libxslt with USE=python"
	fi
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}"/openerp-init.d openerp
	newconfd "${FILESDIR}"/openerp-conf.d openerp

	keepdir /var/run/openerp
	keepdir /var/log/openerp
}

pkg_preinst() {
	enewgroup ${OPENERP_GROUP}
	enewuser ${OPENERP_USER} -1 -1 -1 ${OPENERP_GROUP}

	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/run/openerp
	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
}

pkg_postinst() {
	elog "In order to setup the initial database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

pquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! pquery "SELECT usename FROM pg_user WHERE usename = '${OPENERP_USER}'" | grep -q ${OPENERP_USER}; then
		ebegin "Creating database user ${OPENERP_USER}"
		createuser --quiet --username=postgres --createdb --no-adduser ${OPENERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
