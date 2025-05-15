#!/bin/bash -ex

if [ $(grep -ci $CUPS_ADMIN /etc/shadow) -eq 0 ]; then
    useradd -r -G lpadmin -M $CUPS_ADMIN
    # add password
    echo $CUPS_ADMIN:$CUPS_PASSWORD | chpasswd
    # add tzdata
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
fi

# restore default cups config in case user does not have any
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /cups-bak/* /etc/cups/
fi

# Avvia dbus e avahi-daemon per il discovery Bonjour/mDNS solo se non già in esecuzione
if ! pgrep -x dbus-daemon > /dev/null; then
    dbus-daemon --system &
fi
if ! pgrep -x avahi-daemon > /dev/null; then
    avahi-daemon --daemonize --no-chroot
fi

exec /usr/sbin/cupsd -f
