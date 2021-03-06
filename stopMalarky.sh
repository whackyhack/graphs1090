#!/bin/bash
rm -f /etc/systemd/system/collectd.service
sed -i -e 's?DataDir.*?DataDir "/var/lib/collectd/rrd/"?' /etc/collectd/collectd.conf

if ! grep -qs -e '^DB=' /etc/default/graphs1090; then
    echo "DB=" >>/etc/default/graphs1090
fi

sed -i -e 's#^DB=.*#DB=/var/lib/collectd/rrd#' /etc/default/graphs1090

systemctl stop collectd &>/dev/null
systemctl daemon-reload
systemctl restart collectd
systemctl restart graphs1090

rm -f /etc/cron.d/collectd_to_disk

touch /usr/share/graphs1090/noMalarky

echo ---------
echo write reducing measures disabled!
echo ---------
