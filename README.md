# Cloud Launch in Docker
A Dockerfile for building a Cloud Launch
(https://github.com/galaxyproject/cloudlaunch) image.

## Build an image
Clone this repo and from the root of the repo, run

    $ docker build -t cloudlaunch .

## Run a container
To get an instance of the container, run

    $ docker run --name='cl' -d -p 8000:80 cloudlaunch

This will launch the container and the Cloud Launch web interface will be
available from your local machine at `http://localhost:8000/launch`.

Note that there's a bug in the configuration and/or build process
so you may need to refresh the page to get the UI to show up.
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
