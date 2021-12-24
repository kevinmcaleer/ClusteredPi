---
layout: blogpage
title: Software Overview
author: Kevin McAleer
category: 04 Software
cover: /assets/img/software-overview.jpg
---

{:toc}
* toc

## Layers

### Operating System
The first layer of software is Raspberry Pi OS - all the cluster nodes run standard Raspberry Pi OS, which at the time of writing is the 32bit Bullseye release.

I use the [Raspberry Pi Imaging](https://www.raspberrypi.org/software) software to write the Operating System to the SD card.

---

### Ansible
Next, I've written a bunch of [Ansible](https://www.ansible.com) Playbooks to automate the installation of software on to the group of Raspberry Pis.

You provide Ansible with an `inventory.ini` file that contains a list of each of the nodes and the roles they have.

Here is my inventory file:

```
[master]
192.168.1.10

[node]
192.168.1.3 
192.168.1.4
192.168.1.6
192.168.1.7

[nodered]
192.168.1.3

[grafana]
192.168.1.10
192.168.1.3

[mongodb]
192.168.1.10

[web]
192.168.1.3
192.168.1.4
192.168.1.6


[k3s_cluster:children]
master
node

[node01]
192.168.1.7

[node02]
192.168.1.6

[node03]
192.168.1.3

[node04]
192.168.1.4
```

As you can see from the file above, each of the servers are grouped into a number of roles. These roles can be used in the Ansible playbooks to install software, or set configuration in a standard, repeatable way.

Ansible is ***idempotent***, meaning that if you run a script to change settings, running the same script again shouldn't make any additional changes, unless the settings were somehow changed.

### Playbooks

Here is an example Ansible-playbook:

```
---
- name: Apt Update
  hosts: all
  tasks:
     - name: Apt Update
       command: "sudo apt update"
     - name: Apt Upgrade
       command: "sudo apt upgrade -y"
```

This simple script will connect to ***all*** the nodes, run the `sudo apt update` command and then the `sudo apt upgrade -y` to install any updates automatically.

---

### Docker
The next layer of software is [Docker](https://www.docker.com), which enables the nodes to run software containers. A Container is a discrete package of software that contains all the dependencies and libraries that are needed, which guarantees that the software will work. A container is an instance of a software image and the software images are available via <https://hub.docker.com>. 

Docker containers can be run very simply using a command such as:
```
docker run -itd getting-started
```

### Docker-Compose
More complex container configurations can be built using **Docker-Compose** with the help of a docker-compose.yml file. In fact, you can build multi-stage containers - this is how this website is built:

```
FROM alpine:latest AS getfiles
# install git
RUN apk --no-cache add git
RUN mkdir /src
WORKDIR /src
RUN git clone https://www.github.com/kevinmcaleer/ClusteredPi

FROM blafy/jekyll as jekyll
COPY --from=getfiles /src/ClusteredPi/web /src
WORKDIR /src
RUN mkdir -p /src/_site
RUN jekyll build 

FROM nginx
COPY --from=getfiles /src/ClusteredPi/stacks/jekyll/nginx.conf /etc/nginx/nginx.conf
COPY --from=jekyll /src/_site /www/data
RUN chown -R nginx:nginx /www/data
RUN chmod -R 755 /www/data/*
```

We'll cover how to use docker-compose files in a later article.

---

### Portainer
I've chosen to use [Portainer](https://www.portainer.com) as a graphical user interface for managing Docker on each node.
