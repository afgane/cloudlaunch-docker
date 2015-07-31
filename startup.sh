#!/bin/bash

echo "Starting nginx service"
service nginx start

echo "Starting postgresql service"
service postgresql start

# This process will automatically exit but we need to
# start Cloud Launch so we can add the admin user
echo "Starting supervisor service"
service supervisor start

echo "Creating a Cloud Launch user"
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'no@email.now', '$ADMIN_PASS')" | /srv/cloudlaunch/.cl/bin/python /srv/cloudlaunch/cloudlaunch/biocloudcentral/manage.py shell

echo "Starting supervisor nodaemon"
/usr/bin/supervisord -c /etc/supervisor/supervisor.conf
