#! /bin/sh
### BEGIN INIT INFO
# Provides:          skeleton
# Required-Start:    $local_fs
# Should-Start:
# Required-Stop:     $local_fs
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d
### END INIT INFO

# The definition of actions: (From LSB 3.1.0)
# start         start the service
# stop          stop the service
# restart       stop and restart the service if the service is already running,
#               otherwise start the service
# try-restart	restart the service if the service is already running
# reload	cause the configuration of the service to be reloaded without
#               actually stopping and restarting the service
# force-reload	cause the configuration to be reloaded if the service supports
#               this, otherwise restart the service if it is running
# status	print the current status of the service

# The start, stop, restart, force-reload, and status actions shall be supported
# by all init scripts; the reload and the try-restart actions are optional

# Common steps to convert this skeleton into a real init script
# 1) cp skeleton <the_real_name>
# 2) Set DESC and NAME
# 3) Check whether the daemon app is /usr/sbin/$NAME, if not, set it.
# 4) Set DAEMON_ARGS if there is any
# 5) Remove the useless code

# NOTE: The skeleton doesn't support the daemon which is a script unless the
#       pidof supports "-x" option, please see more comments for pidofproc ()
#       in /etc/init.d/functions

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin

DESC="initapps"
NAME="dashboard_app"
DAEMON=/usr/bin/$NAME
DAEMON_ARGS=""
PIDFILE=/var/run/$NAME.pid

export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export QT_QPA_PLATFORM=wayland
export WAYLAND_DISPLAY=/run/wayland-0
export VSOMEIP_CONFIGURATION=/usr/etc/vsomeip/Configurations/dashboardclient.json
export VSOMEIP_APPLICATION_NAME=dashboad

. /etc/init.d/functions || exit 1

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

#
# Function that starts the daemon/service
#
do_start() {
	local status pid

	status=0
	pid=`pidofproc $NAME` || status=$?
	case $status in
	0)
		echo "$DESC already running ($pid)."
		exit 1
		;;
	*)
		export QT_QPA_PLATFORM=wayland
		export XDG_RUNTIME_DIR=/run/user/$(id -u)
		
		echo "Starting $DESC ..."
		exec $DAEMON $DAEMON_ARGS >/dev/null 2>&1 || status=$?
		echo "ERROR: Failed to start $DESC."
		exit $status
		;;
	esac

	# Add code here, if necessary, that waits for the process to be ready
	# to handle requests from services started subsequently which depend
	# on this one.  As a last resort, sleep for some time.
}

#
# Function that stops the daemon/service
#
do_stop() {
	local pid status

	status=0
	pid=`pidofproc $NAME` || status=$?
	case $status in
	0)
		# Exit when fail to stop, the kill would complain when fail
		kill -s 15 $pid >/dev/null && rm -f $PIDFILE && \
			echo "Stopped $DESC ($pid)." || exit $?
		;;
	*)
		echo "$DESC is not running; none killed." >&2
		;;
	esac

	# Wait for children to finish too if this is a daemon that forks
	# and if the daemon is only ever run from this initscript.
	# If the above conditions are not satisfied then add some other code
	# that waits for the process to drop all resources that could be
	# needed by services started subsequently.  A last resort is to
	# sleep for some time.
	return $status
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
	local pid status

	status=0
        # If the daemon can reload its configuration without
        # restarting (for example, when it is sent a SIGHUP),
        # then implement that here.
	pid=`pidofproc $NAME` || status=$?
	case $status in
	0)
		echo "Reloading $DESC ..."
		kill -s 1 $pid || exit $?
		;;
	*)
		echo "$DESC is not running; none reloaded." >&2
		;;
	esac
	exit $status
}


#
# Function that shows the daemon/service status
#
status_of_proc () {
	local pid status

	status=0
	# pidof output null when no program is running, so no "2>/dev/null".
	pid=`pidofproc $NAME` || status=$?
	case $status in
	0)
		echo "$DESC is running ($pid)."
		exit 0
		;;
	*)
		echo "$DESC is not running." >&2
		exit $status
		;;
	esac
}

case "$1" in
start)
	do_start
	;;
stop)
	do_stop || exit $?
	;;
status)
	status_of_proc
	;;
restart)
	# Always start the service regardless the status of do_stop
	do_stop
	do_start
	;;
try-restart|force-reload)
	# force-reload is the same as reload or try-restart according
	# to its definition, the reload is not implemented here, so
	# force-reload is the alias of try-restart here, but it should
	# be the alias of reload if reload is implemented.
	#
	# Only start the service when do_stop succeeds
	do_stop && do_start
	;;
reload)
	# If the "reload" action is implemented properly, then let the
	# force-reload be the alias of reload, and remove it from
	# try-restart|force-reload)
	#
	do_reload
	;;
*)
	echo "Usage: $0 {start|stop|status|restart|try-restart|force-reload}" >&2
	exit 3
	;;
esac

