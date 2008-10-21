# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="BhPos server"
HOMEPAGE="http://www.bananapos.com"
SRC_URI="http://bananapos.com/download/bhpos/stable/plus/${P}.tar.gz \
ftp://bananahead.com/pub/bhpos/dbdump_v${PV}.mysql"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="odbc mysql postgres debug"

DEPEND=">=app-misc/bhposserverlibs-1.6.3"

RDEPEND="${DEPEND}"


S=${WORKDIR}/${P}

randstr() {
	case ${1} in
		"-l") length=${2}; shift 2 ;;
		*) length=1 ;;
	esac
	_RANDSTR=""
	while [ ${#_RANDSTR} -lt ${length} ] ; do
		eval _RANDSTR=${_RANDSTR}${sep}\${$(( ${RANDOM} % $# + 1 ))}
	done
}

get_conf_var() {
	local i row=`grep -A 100 "\[db\]" \
	${1}/plusd.conf |grep -m 2 -B 100  "\["|grep -v -e "\["| \
		grep "${2}="`
	conf_var=`expr match  ${row} '.*=\(.*\)'|cut -d " " -f 1`
}

src_unpack() {
	for i in ${A}; do
		test=`expr match ${i} '.*\(.tar.gz\|.tgz\|tar.bz2\)'`
		if ( [ -n  "${test}" ] ) ; then
			unpack ${i}
		else
			echo ">>> Copying ${i} to ${S}"
			cp ${DISTDIR}/${i} ${S}
		fi ;
	done ;
	#Create random password.
	local lower="a b c d e f g h i j k l m n o p q r s t u v w x y z"
	local upper="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
	local numbers="0 1 2 3 4 5 6 7 8 9"
	randstr -l 32 ${upper} ${lower} ${numbers}
	echo ">>> Patching ${S}/scripts/plusd.conf"
	replace -s "user=root" "user=bhpos" \
	"password=bollocks" "password=${_RANDSTR}" \
	-- ${S}/scripts/plusd.conf
}

src_compile() {

	#Get the proper flags for configure from the serverlibs.
	#Check current use-flags, error if not matching.
	CONF_FLAGS=""
	local i bhposserverlibs_installed=$(best_version app-misc/bhposserverlibs)
	serverlib_USE=`cat /var/db/pkg/${bhposserverlibs_installed}/USE`
	for serverlib_USE in ${serverlib_USE} ; do
		local i result=`grep -o "${serverlib_USE}" /var/db/pkg/${bhposserverlibs_installed}/IUSE`
		if ( [ "${result}" == "mysql" ] ) ; then
			if [ `use ${result}` ] ; then
				CONF_FLAGS=${CONF_FLAGS}"--enable-${result} "
			else
				eerror "USE-flag ${result} changed since installation of ${bhposserverlibs_installed}. ${PN} must be installed using exactly the same
				USE-flags as bhposserverlibs"
				die
			fi ;
		elif ( [ "${result}" == "postgres" ] ) ; then
			if [ `use ${result}` ] ; then
				CONF_FLAGS=${CONF_FLAGS}"--enable-${result}ql "
			else
				eerror "USE-flag ${result} changed since installation of ${bhposserverlibs_installed}. ${PN} must be installed using exactly the same
				USE-flags as bhposserverlibs"
				die
			fi ;
		elif ( [ "${result}" == "odbc" ] ) ; then
			if [ `use ${result}` ] ; then
				CONF_FLAGS=${CONF_FLAGS}"--enable-${result} "
			else
				eerror "USE-flag ${result} changed since installation of ${bhposserverlibs_installed}. ${PN} must be installed using exactly the same
				USE-flags as bhposserverlibs"
				die
			fi ;
		fi ;
	done ;
	#Check for double db flags. error if enabled.
	if ( [ `use mysql` ] && [ `use postgres` ] ) ; then
		eerror "USE-flags mysql and postgres can not be used at the same time. You must choose only one database."
		die
	fi ;
	
	if ( [ `use debug` ] ) ; then
		CONF_FLAGS=${CONF_FLAGS}"--enable-debug=yes "
	fi ;

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${CONF_FLAGS} || die "./configure failed"


	emake || die "emake failed"
}

src_install() {

	#The script Makefile must be modifyed to work in a sandbox env.
	#When using FEATURES="-sandbox" this can be skipped, but it won't damage anything.
	#It might also be a good idea to move /var/bhpos/log to /var/log/bhpos in the future.
	replace "DIR_INIT = /etc" "DIR_INIT = \${sysconfdir}" \
	"DIR_BHETC = /etc" "DIR_BHETC = \${sysconfdir}" \
	"DIR_PKGCONFIG = /usr/lib/pkgconfig" $'DIR_PKGCONFIG = /usr/lib/pkgconfig\nDIR_BHVAR = ${sysvardir}/bhpos' \
	"/var/bhpos" "\${DIR_BHVAR}" \
	$'\tif test -f $(DIR_INIT)/plusd' $'\tif test -d $(DIR_INIT) ; then \\\n\t\techo $(DIR_INIT) exists ; \\\n\telse \\\n\t\techo creating $(DIR_INIT) ; \\\n\t\t$(mkinstalldirs) $(DIR_INIT) ; \\\n\tfi;\\\n\tif test -f $(DIR_INIT)/plusd' \
	-- ./scripts/Makefile

	#sysvardir is a new flag that is created by the replace code above.

	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		sysvardir=${D}/var \
		localstatedir=${D}/var/lib \
		sbindir=/usr/sbin \
	install DESTDIR=${D} || die


	dodoc AUTHORS COPYING ChangeLog README INSTALL NEWS
	keepdir /var/bhpos/log

	#replace the original startup script, since it's totally f***ed up.
	exeinto /etc/init.d
	newexe ${FILESDIR}/plusd.init.d plusd
	enewuser bhpos
	enewgroup bhpos

	get_conf_var "${S}/scripts" host
	db_host=${conf_var}
	einfo "Give root password to mysql."
	read mysql_root_pwd
	err_msg=`mysql -u root -h ${db_host} -p${mysql_root_pwd} \
		< ${S}/dbdump_v1.2.3.mysql 2>&1`
	err_nbr=`expr match "${err_msg}" 'ERROR\ \([0-9]*\).*'`
	err_desc=`expr match "${err_msg}" '.*: \(.*\)'`
	if ( [ "${err_nbr}" == "1007" ] ) ; then
		eerror "${err_desc}"
	fi ;
}

pkg_postinst() {
	get_conf_var "/etc/bhpos" host
	db_host=${conf_var}
	get_conf_var "/etc/bhpos" database
	db_data=${conf_var}
	get_conf_var "/etc/bhpos"  user
	db_user=${conf_var}
	get_conf_var "/etc/bhpos"  password
	db_pwd=${conf_var}
	err_msg=`mysql -u root -h ${db_host} -p${mysql_root_pwd} -e "\
		GRANT ALL PRIVILEGES ON ${db_data}.* TO ${db_user}@${db_host} \
		IDENTIFIED BY '${db_pwd}'; FLUSH PRIVILEGES;" 2>&1`
}
