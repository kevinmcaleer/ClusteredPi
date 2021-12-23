---
layout: blogpage
title: Hardware Overview
excerpt: Learn how to build your own Clustered-Pi
cover: /assets/img/chassis.jpg
author: Kevin McAleer
categories: [02. Hardware]
---

{:toc}
* toc


## Bill of Materials

|Item | Description            | Qty | Approx Price | Total |
|:--:|:---------------|:---:|------------:|-----:|
| ![](/assets/img/raspberry-pi-4.jpg){:style="height:32px"}| [Raspberry Pi 4](https://amzn.to/30SzZw0) |  4  | £58          | £232   |
|![](/assets/img/sd_card.jpg){:style="height:32px"}| [64sdGb SD Card](https://amzn.to/33VboYH) | 4 | £15 | £60 | 
| ![](/assets/img/tp_link_8port_hub.jpg){:style="height:32px"}| [Network Hub](https://amzn.to/3poQp94) | 1 | £18 | £18|
|![](/assets/img/network_cables.jpg){:style="height:32px"}| [CAT6 Cables](https://amzn.to/3FsnSFc) | 1 | £13 | £13 |
|![](/assets/img/usb_cable.jpg){:style="height:32px"}| [USB A to USB C Charging Cables](https://amzn.to/3FsvjfA) | 4 |£6  |£24|
| ![](/assets/img/usb_charger.jpg){:style="height:32px"} | [USB Charger - 3A per port](https://amzn.to/3JehNOY) | 1  | £15  |£15 |
| ![](/assets/img/cluster_chassis.jpg){:style="height:32px"} | [Raspberry Pi 4 Chassis](https://thepihut.com/products/metal-cluster-rack-case-kit-for-raspberry-pi-4?variant=41230817591491&currency=GBP&utm_medium=product_sync&utm_source=google&utm_content=sag_organic&utm_campaign=sag_organic&gclid=Cj0KCQiA2ZCOBhDiARIsAMRfv9IT60o3yFnRcOAhtCzc-M35Q0qapcmBIeexjIhR8EqQ5qvckcffw68aAsajEALw_wcB) | 1 | £42 | £42|
| | | |**Grand Total** |**£404**| 
{:class="table "}


## Raspberry Pi 4
Clustered-Pi consists of 4 [Raspberry Pi 4](https://www.raspberrypi.org) computers. Each one has slightly different sizes of memory, which is more to do with when they released these than a design choice.

![Raspberry Pi 4](/assets/img/raspberry-pi-4.jpg){:class="img-fluid w-50"}
Raspberry Pi 4, 8Gb

---

### SD Cards
I recommend getting a branded SD card, from a reputable supplier; in my experience unbranded SD Cards only last a couple of months under reasonable use, whereas the branded ones, particularly those designed for heavy write demands last years.

![](/assets/img/sd_card.jpg){:class="img-fluid w-50"}
64Gb SanDisk Extreme SD Card

### Disk Imaging

I used the official [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

---

### Configuration
Each node has a `hostname` that is unique:
* `node01`
* `node02`
* `node03`
* `node04`

You set the hostname when first booting up the Raspberry Pi, or later using the `raspi-config` command, from the terminal.

---

## Network hub & Cables
Lets look how to wire this all up.

---

### Network Hub
I purchased a [cheap 8 port network hub](https://amzn.to/3poQp94) (a TP Link 8 port Gigabit Desktop Switch). This gives some room for expansion later on, and doens't take up too much space on the desk. 

It also just happens to be the perfect size to sit underneath the Raspberry Pis.

---

### Network Cables
I also bought bunch of [colourful patch CAT6 cables](https://amzn.to/3FsnSFc) to connect the hub to each Raspberry Pi. The cables are only 25cm long, so they fit neatly into the pi's and hub.

---

|                                                                                                                   |                                                                                                      |
|:-----------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------:|
| [![TP Link 8 Port Hub](/assets/img/tp_link_8port_hub.jpg){:class="img-fluid"}](/assets/img/tp_link_8port_hub.jpg) | [![Cables](/assets/img/network_cables.jpg){:class="img-fluid w-50"}](/assets/img/network_cables.jpg) |
|                                                    Network Hub                                                    |                                                Cables                                                |
{:class="my-4"}

The network hub is connected to my router, so I can connect to them from my laptop, and more importantly, they are connected to the Internet so they can download Docker images.

---

## Chassis & Power
Lets get our Pi's Racked and stacked.

### Cluster Chassis
I originally had the Raspberry Pi's in their cases, just sat on top of the network hub, however this was shortly improved by purchasing a purpose built chassis. Not only does it make the Raspberry Pi's more structurally stable, it provides additional cooling via 2 large fans behind the Pis.

|                                                                                             |                                                                                    |
|:-------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------:|
| [![No Chassis](/assets/img/no_chassis.jpg){:class="img-fluid"}](/assets/img/no_chassis.jpg) | [![Chassis](/assets/img/chassis.jpg){:class="img-fluid"}](/assets/img/chassis.jpg) |
|                                         No Chassis                                          |                                    With Chassis                                    |
{:class="mb-4"}

### Power

For Power, I bought some [short 25cm USBA to USB C charger cables](https://amzn.to/3FsvjfA), and a [4 port USB charger plug](https://amzn.to/3JehNOY) that can deliver 3.1Amps per port.


### UPS
This Cluster will be running a live website, accessible via the internet, so to ensure its always available I have powered it via an uninterruptable power supply (UPS), I used the [Cyberpower BR1200ELCD BRIC](https://amzn.to/3qo9fMy)


![Chassis](/assets/img/ups.jpg){:class="img-fluid w-50"}

Cyberpower UPS: 1200VA/720W, with 6 UK Outlets