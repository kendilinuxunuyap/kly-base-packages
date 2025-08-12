#!/sbin/openrc-run

description="load modules runsystemd"

name="runsystemda"
command="/etc/local.d/runsystemd"
command_args=""
pidfile="/run/runsystemd.pid"
command_background=true
depend() {
        after lightdm
} 
