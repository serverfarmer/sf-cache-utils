#!/bin/bash
. /opt/farm/scripts/init

# /var/cache/cacti is a common caching directory used by several monitoring
# extensions to write temporary files, including every minute or 2 minutes.
#
# So on SSD drives (especially cheap, desktop-grade ones), this directory
# should be cached to prevent decreasing the drive lifespan.
#
# On the other hand, some extensions (eg. sf-ip-monitor) assume that
# the contents of this directory are persistent across reboots.
#
#
# [ "$HWTYPE" = "physical" ] condition definitely isn't sufficient for
# proper handling of all types of servers, drives, drive/raid/usb/esata
# controllers, udevd/systemd configurations, virtualization methods etc.
#
# However in practice, it has over 90% average accuracy for SOHO/entry
# class hardware, and for all cloud providers, where underlying SSD
# lifespan is not a problem.

mkdir -p /var/cache/cacti

if ! grep -q /var/cache/cacti /etc/fstab && [ "$HWTYPE" = "physical" ]; then
	echo "tmpfs /var/cache/cacti tmpfs noatime,size=16m 0 0" >>/etc/fstab
fi
