#!/sbin/openrc-run

description="Start rootfspermit Service"

name="rootfspermit"
command="/etc/local.d/rootfspermit"
command_args=""
pidfile="/run/rootfspermit.pid"
command_background=true

