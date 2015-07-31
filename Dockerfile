FROM ubuntu:14.04

RUN apt-get -qq update && apt-get install --no-install-recommends -y \
    python-virtualenv git postgresql-9.3 libpq-dev postgresql-server-dev-all \
    python-dev nginx supervisor gcc wget vim curl

RUN useradd -r -s "/bin/bash" --create-home -c "Cloud Launch user" launch

RUN mkdir -p /srv/cloudlaunch && chown launch:launch /srv/cloudlaunch

USER launch

RUN cd /srv/cloudlaunch && \
    virtualenv .cl && \
    . /srv/cloudlaunch/.cl/bin/activate && \
    touch /home/launch/.gitconfig && \
    git config --global http.sslVerify false && \
    git clone https://github.com/galaxyproject/cloudlaunch.git && \
    pip install -r /srv/cloudlaunch/cloudlaunch/requirements.txt

USER root

ENV PG_DATA_DIR_DEFAULT=/var/lib/postgresql/9.3/main/ \
    PG_DATA_DIR_HOST=/export/postgresql/9.3/main/
ADD ./setup_postgresql.py /usr/local/bin/setup_postgresql.py
RUN rm -rf $PG_DATA_DIR_DEFAULT && \
    python /usr/local/bin/setup_postgresql.py --dbuser launch --dbpassword gxy_letmein --db-name cloudlaunch --dbpath $PG_DATA_DIR_DEFAULT

RUN rm /etc/nginx/sites-enabled/default && \
    cp /srv/cloudlaunch/cloudlaunch/cl_nginx.conf /etc/nginx/sites-available/ && \
    ln -s /etc/nginx/sites-available/cl_nginx.conf /etc/nginx/sites-enabled/cl

ADD ./supervisor.conf /etc/supervisor/supervisor.conf
RUN cp /srv/cloudlaunch/cloudlaunch/cl_supervisor.conf /etc/supervisor/conf.d/cloudlaunch.conf

USER launch

ADD settings_local.py /srv/cloudlaunch/cloudlaunch/biocloudcentral/settings_local.py

RUN cd /srv/cloudlaunch/cloudlaunch && \
    . /srv/cloudlaunch/.cl/bin/activate && \
    python biocloudcentral/manage.py collectstatic --noinput

USER root

RUN service postgresql start && \
    cd /srv/cloudlaunch/cloudlaunch && \
    . /srv/cloudlaunch/.cl/bin/activate && \
    python biocloudcentral/manage.py syncdb --noinput && \
    python biocloudcentral/manage.py migrate biocloudcentral && \
    python biocloudcentral/manage.py migrate djcelery && \
    python biocloudcentral/manage.py migrate kombu.transport.django

RUN chown launch:launch /srv/cloudlaunch/cloudlaunch

EXPOSE :80

ADD startup.sh /usr/bin/startup
RUN chmod +x /usr/bin/startup
ENTRYPOINT ["/usr/bin/startup"]
