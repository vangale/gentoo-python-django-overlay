# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="BhPos server"
HOMEPAGE="http://www.bananapos.com"
SRC_URI="ftp://bananahead.com/pub/bhpos2/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=app-misc/bhpos_serverlibs-2.0.0"

RDEPEND="${DEPEND}"

#S=${WORKDIR}/${P}

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
	#To unpack tarballs with sql-dumps etc. not needed in the present, but doing no harm
	for i in ${A}; do
		test=`expr match ${i} '.*\(.tar.gz\|.tgz\|tar.bz2\)'`
		if ( [ -n  "${test}" ] ) ; then
			unpack ${i}
		else
			echo ">>> Copying ${i} to ${S}"
			cp ${DISTDIR}/${i} ${S}
		fi ;
	done ;
	
	DB_CONF=""
	if ( [ -a /etc/plusd.conf ] ) ; then
		#Read the old database configuration
		get_conf_var "/etc" host
		db_host=${conf_var}
		get_conf_var "/etc" database
		db_data=${conf_var}
		get_conf_var "/etc" user
		db_user=${conf_var}
		get_conf_var "/etc" password
		db_pwd=${conf_var}
		#Database validation:
		if ( [ -z "${db_pwd}" ] ) ; then
			err_msg=`mysql -h ${db_host} -u ${db_user} ${db_data} -e "QUIT" 2>&1`
		else
			err_msg=`mysql -h ${db_host} -u ${db_user} -p${db_pwd} ${db_data} -e "QUIT" 2>&1`
		fi
		err=`expr match "${err_msg}" 'ERROR\ \([0-9]*\).*'`
		#ERROR 1044: Access denied for user to database
		#ERROR 1045: Access denied for user
	        #ERROR 1049: Unknown database
		if ( [ "${err}" == "" ] ) ; then
			#Everything seems to be ok.
			DB_CONF="OK"
			einfo "Database configuration validated."
		elif ( [ "${err}" == "1045" ] || [ "${err}" == "1044" ]) ; then
			#Bad password and/or username
                	DB_CONF="BAD"
			ewarn "mySQL: Access denied for user: '${db_user}@${db_host}' (Using password: YES)"
			einfo "Manual verification of db setup:"
			echo -n "mySql host [${db_host}]:"
			read db_host
			if ( [ -z "${db_host}" ] ) ; then
				get_conf_var "/etc" host
				db_host=${conf_var}
			fi ;
			echo -n "mySql database [${db_data}]:"
			read db_data
			if ( [ -z "${db_data}" ] ) ; then
				get_conf_var "/etc" database
				db_data=${conf_var}
			fi ;
			echo -n "mySql user [${db_user}]:"	
			read db_user
			if ( [ -z "${db_user}" ] ) ; then
				get_conf_var "/etc" user
				db_user=${conf_var}
			fi ;
			echo -n "mySql password for ${db_user} [${db_pwd}]:"	
			read db_pwd
			if ( [ -z "${db_pwd}" ] ) ; then
				get_conf_var "/etc" password
				db_pwd=${conf_var}
			fi ;
		else
			eerror "Unknown mySQL error: ${err_msg}"
			return 1
		fi
	else
		#Create a new datbase configuration
		DB_CONF="NEW"
		#Create random password.
		local lower="a b c d e f g h i j k l m n o p q r s t u v w x y z"
		local upper="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
		local numbers="0 1 2 3 4 5 6 7 8 9"
		randstr -l 32 ${upper} ${lower} ${numbers}
		db_pwd=${_RANDSTR}
		einfo "Interactive part of setup...."
		echo -n "mySql host [localhost]:"
		read db_host
		if ( [ -z "${db_host}" ] ) ; then
			db_host="localhost"
		fi ;
		echo -n "mySql database [bananas]:"
		read db_data
		if ( [ -z "${db_data}" ] ) ; then
			db_data="bananas"
		fi ;
		echo -n "mySql user [bhpos]:"
		read db_user
		if ( [ -z "${db_user}" ] ) ; then
			db_user="bhpos"
		fi ;
	fi ;
	#Set database configuration.
	echo ">>> Patching ${S}/scripts/plusd.conf"
	replace -s "host=localhost" "host=${db_host}" \
	"database=bananas" "database=${db_data}" \
	"user=root" "user=${db_user}" \
	"password=bollocks" "password=${db_pwd}" \
	-- ${S}/scripts/plusd.conf
}

src_compile() {
	CONF_FLAGS=""
	
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

	#make \
	#	prefix=${D}/usr \
	#	mandir=${D}/usr/share/man \
	#	infodir=${D}/usr/share/info \
	#	sysconfdir=${D}/etc \
	#	localstatedir=${D}/var/lib \
	#	sbindir=/usr/sbin \
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS COPYING ChangeLog README INSTALL NEWS

	newinitd ${FILESDIR}/plusd2.init.d plusd || die

	keepdir /var/bhpos
	fowners bhpos:bhpos /var/bhpos
}

pkg_setup() {
	enewgroup bhpos
	enewuser bhpos -1 -1 /dev/null bhpos
}

pkg_postinst() {
	if ( [ "${DB_CONF}" == "NEW" ] ) ; then
		get_conf_var "/etc" host
		db_host=${conf_var}
		get_conf_var "/etc" database
		db_data=${conf_var}
		get_conf_var "/etc" user
		db_user=${conf_var}
		get_conf_var "/etc" password
		db_pwd=${conf_var}
		einfo "On your mySql server, run:"
		einfo "mysql -u root -h ${db_host} -p -e \"\
GRANT ALL PRIVILEGES ON ${db_data}.* TO ${db_user}@${db_host} \
IDENTIFIED BY '${db_pwd}'; FLUSH PRIVILEGES;\""
	elif  ( [ "${DB_CONF}" == "BAD" ] ) ; then
		ewarn "Your plusd mySql configuration might be corrupt."
		ewarn "You might want to check the mySql privilegies, and if the mySql server is up."
	fi
}
