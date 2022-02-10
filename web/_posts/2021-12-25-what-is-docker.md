---
layout: blogpage
title: What is Docker?
subtitle: Its a box of delights
author: Kevin McAleer
categories: [04 Software]
excerpt: Learn about Docker, what it can do, and how to use 
cover: /assets/img/blog/what-is-docker.jpg
---

{:toc}
* toc

# Docker Overview

Docker is an open-source platform for creating and managing software containers.

---

## Containers
So what is a container? Here is a definition from the creators of docker:

> *"A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings."* - [**Docker.com**](https://www.docker.com){:class="white-text text-decoration-none"}

Containers are much smaller than virtual machines, which is the alternative method for separating software services.

Containers are made up of several parts:

| Component | Description                                                                                                               |
|-----------|---------------------------------------------------------------------------------------------------------------------------|
| `Image`     | Contains the software to be run                                                                                           |
| `Volume`    | The data storage, can be stored as a separate file, or mounted from the local file system                                 |
| `Port`      | Network ports that the container exposes to the local network, can allow mapping between internal port and external ports |
| `Network`   | Networks can be used to connect images together - its a bit like having a virtual network switch                          |
{:class="table"}

We will look at each of these components below. To jump to a section click on [Containers](#containers) [Images](#images), [Volumes](#volumes) [Networks](#networks)

### Why not just install software?
Docker turns software into blocks of software, called [images](#images),  that can be switched on and off very easily, it also ensure that dependent libraries and configuration are all inside the container. This makes it really easy to install software, start it up, run it and when the time comes, stop it and remove it.

Docker also has a ***restart policy*** which restarts the software automatically if the containers fails.

### Docker Image Repository - Docker hub
Docker has an official repository of software images, called [Docker Hub](https://hub.docker.com). You can browse or search the hub for officially tested images, and you can download up to 100 images for free, every 6 hours.

### Installing containers
Installing software containers could not be easier. For example, to install Nginx (a popular web server) the command is:

```
docker run -itd nginx
```
...and thats it!

### List all the running containers
To list all the currently running containers, simply type:
```
docker ps
```

To show all the containers, including stopped containers, type:
```
docker ps -a
```

### Starting a container
If a container is stopped, you can restart it by typing:
```
docker start <container-name>
```
Where `container-name` is the name of the container you want to start.

### Stopping containers
To stop a container, simply type:
```
docker stop <container-name>
```
Where `<container-name>` is the name of the container you want to stop.

### Removing containers
To remove a container, type:
```
docker rm <container-name>
```
Where `<container-name>` is the name of the container you want to remove.

### Container options
You can configure container options, such as the restart policy, by using the `update` command. For example, to set the restart policy to always restart on the Portainer container type:
```
docker update --restart=always Portainer
```

To give your containers a specific name, you can use the `--name` option, when creating it; for example to use the image `getting-started` and name the container as `Welcome` type:
```
docker run getting-started --name=Welcome 
```

---

## Images
An image is a pre-configured bundle of software, frozen into a package that can be easily copied and run in a docker environment.

### Creating Images - Build
To create your own image, use the `docker build` command. Docker will look for a `Dockerfile` in the current directory and use that to construct the new image.

```
docker build
```

### Listing the images
To list all the images that are currently installed (but not necessarily running as containers), type:
```
docker images ls
```
Where `<image-name>` is the name of the image you want to pull.

### To pull an image
If you want to cache an image ready for use, but not actually start a container, simply type:
```
docker image pull <image-name>
```

### Removing images
To remove an image type:
```
docker image rm <image-name>
```
Where `<image-name>` is the name of the image you want to remove.

---

## Volumes
A volume is a data file or mount point to the local file system that can be used to store data for the container.

By separating volumes from images we separate the executable code from the storage of data. This means we can quickly upgrade the software without affecting the underlying data. Or if we want to move the data to another server, its just a matter of copying the volume file.

### Creating Volumes
Volumes can be quickly created by typing:
```
docker volume <volume-name>
```
Where `volume-name` is the name of the volume to create.

### Listing Volumes
To list all the volumes available, type:
```
docker volume ls
```

### Removing Volumes
To remove a volume type:
```
docker volume rm <volume-name>
```
Where `volume-name` is the name of the volume to remove.

## Networks
Networks enable containers to talk to each other, without exposing that network traffic outside of the host. The can also enable containers to talk to other computers outside of the host.

### Listing networks
To list all the available networks, type:
```
docker network ls
```
### Creating network
To create a new network, type:
```
docker network create <network-name>
```
Where `network-name` is the name of the new network you want to create.

### Removing networks
To remove a network, type:
```
docker network rm <network-name>
```
Where `network-name` is the name of the new network you want to remove.

---

## Ports
Ports enable data to flow in and out of your container on a specific unix port number.

### Opening a port on a container
When creating a container, you can use the `-p` option to specify the port to expose from the container to the host. For example to expose the container port `80` to the host port `80`, type the following:
```
docker run -p 80:80 <container-name> 
```
Where `container-name` is the name of the container and the `80:80` is the mapping is from the host to the container (host:container). For example, to map port the host port 80 to the container port 8080 you would type `-p 80:8080`

---

## Creating Containers in code
Using the command-line is great for quickly creating, running and managing docker containers, however if you want to create containers more programmatically you can use a Dockerfile.

### Dockerfile
A dockerfile tells docker how to build the image we want to create.

Here is an example dockerfile:
```
FROM alpine:latest AS getfiles
# install git
RUN apk --no-cache add git
RUN mkdir /src
WORKDIR /src
RUN git clone https://www.github.com/kevinmcaleer/ClusteredPi
```

In the example above, we specify which image to build the container `FROM`, which is the latest version of alpine linux, we then `RUN` the command `apk --no-cache add git` to add the git package, using the apk package manager.

We then `RUN` another command to create the folder `/src`.

Next we set the working directory to `/src` using the `WORKDIR` keyword.

Finally we `RUN` the command line `git clone` and the name of the git repository we want to copy.

The result is a linux image with our source code installed.

### Docker-compose
A Docker-compose file, usually called `docker-compose.yml`.

A Docker-compose file contains all the configuration that you would normally specify at the command-line but in a file. 

Here is an example docker-compose.yml file:
```
version: "3.9"
services:
  myapp:
    environment:
      JEKYLL_UID: 1000
      JEKYLL_GID: 1000
      JEKYLL_ENV: production
    build: .
    ports: 
      - "2222:2222"
    # image: myapp
    restart: always
```
First we specify the version of docker-compose we are using, which in this case is `3.9`.
We then define the `services`, which in this case is just one container called `myapp`.

`myapp` has three environment variables.
We then use the `build` command with the parameter `.` which tells if to build the image from the current folder.

We then expose the ports `2222:2222` from the host to the container.

Next is a comment `#`, which docker-compose ignores.
Finally we set the restart policy to `always` restart. This will ensure that docker always starts this container up at boot/start-up too.

### Prune all unused images and containers 
To clean up your system, and remove any unused images or containers, type:
```
docker system prune
```