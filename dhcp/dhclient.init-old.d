#!/sbin/openrc-run
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

NAME="dhclient"

depend()
{
	need localmount
	keyword -vserver -lxc
}

start()
{
    ebegin "Starting dhclient networking"
    for DEVICE in /sys/class/net/* ; do
        IFACE=${DEVICE##*/}
        [ "$IFACE" = "lo" ] && continue

        # Arayüzü UP yap
        ip link set "$IFACE" up

        # Arayüz hazır olana kadar (timeout 10 saniye)
        TIMEOUT=10
        while [ $TIMEOUT -gt 0 ]; do
            if ip link show "$IFACE" | grep -q "state UP"; then
                break
            fi
            sleep 1
            TIMEOUT=$((TIMEOUT - 1))
        done

        # IP yoksa dhclient başlat
        if ! ip addr show "$IFACE" | grep -q "inet "; then
            dhclient "$IFACE"
        fi
    done
    eend 0
}


xxstart()
{
    ebegin "Starting dhclient networking"
    for DEVICE in /sys/class/net/* ; do
        ip link set ${DEVICE##*/} up
        [ ${DEVICE##*/} != lo ] && dhclient ${DEVICE##*/}
    done
    return 0
}

stop()
{
	return 0
}

# vim:ts=4

