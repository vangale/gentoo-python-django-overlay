#!/sbin/runscript

depend() {
	use net logger
	after postgresql
}


start() {
	[ -n "${SERVER_DB}" ] && SERVER_OPTS="${SERVER_OPTS} --database=${SERVER_DB}"
	[ -n "${SERVER_USER}" ] && SERVER_OPTS="${SERVER_OPTS} --db_user=${SERVER_USER}"
	[ -n "${SERVER_PW}" ] && SERVER_OPTS="${SERVER_OPTS} --db_password=${SERVER_PW}"
	[ -n "${SERVER_HOST}" ] && SERVER_OPTS="${SERVER_OPTS} --db_host=${SERVER_HOST}"
	[ -n "${SERVER_PORT}" ] && SERVER_OPTS="${SERVER_OPTS} --db_port=${SERVER_PORT}"
								
	ebegin "Starting OpenERP"
	start-stop-daemon --start --quiet --background --chuid terp:terp --pidfile=/var/run/openerp/openerp.pid --startas /usr/bin/openerp-server --exec /usr/bin/python -- ${SERVER_OPTS} --pidfile=/var/run/openerp/openerp.pid --logfile=/var/log/openerp/openerp.log
	eend $?
}


stop() {
	ebegin "Stopping OpenERP"
	start-stop-daemon --stop --quiet --pidfile=/var/run/openerp/openerp.pid
	eend $?
}

