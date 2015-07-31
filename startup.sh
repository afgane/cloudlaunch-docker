#!/bin/bash

echo "Starting nginx service"
service nginx start

echo "Starting postgresql service"
service postgresql start

echo "Starting supervisor"
# service supervisor start
/usr/bin/supervisord -c /etc/supervisor/supervisor.conf
sleep 5
