#!/bin/sh
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
service nginx start
exec $@
