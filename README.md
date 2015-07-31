# Cloud Launch in Docker
A Dockerfile for building a Cloud Launch
(https://github.com/galaxyproject/cloudlaunch) image.

## Build an image
Clone this repo and from the root of the repo, run

    $ docker build -t cloudlaunch .

## Run a container
To get an instance of the container, run (having set the password as desired)

    $ docker run --name='cl' -e "ADMIN_PASS=some_pwd" -d -p 8000:80 cloudlaunch

This will launch the container and the Cloud Launch web interface will be
available from your local machine at `http://localhost:8000/launch`. The Admin
interface will be available under `http://localhost:8000/admin/` and you can
log in with user name `admin` and password you set when you launced the
container.

**Note** that there's a bug in the configuration and/or build process
that will redirect you from port 8000 to 80 on many pages. So when you get a
`This page is not available (connection refused)` error, just add `:8000` to the
hostname and refresh the page.

Also, if you are on OS X and using boot2docker, you need to open a new terminal
window and execute the following command to allow port forwarding (see [here][1]
for more info about this):

    $ boot2docker ssh -vnNTL 8000:localhost:8000

## Stop the container
To stop the container, run

    $ docker stop cl

To remove the container entirely, execute

    $ docker rm cl

## Connect to the container
Once running, you can connect to the container with an interactive shell using

    $ docker exec -i -t cl /bin/bash

[1]: https://github.com/boot2docker/boot2docker/blob/master/doc/WORKAROUNDS.md
