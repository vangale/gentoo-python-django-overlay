#!/sbin/runscript
# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-misc/plusd/files/plusd,v 1.4 2004/02/13 19:19:04 vapier Exp $

depend() {
	need mysql
}

start() {
	ebegin "Starting plusd"
	start-stop-daemon --start --quiet --exec /usr/sbin/plusd
	eend $?
}

stop() {
	ebegin "Stopping plusd"
	start-stop-daemon --stop --quiet --exec /usr/sbin/plusd
	eend $?
}
