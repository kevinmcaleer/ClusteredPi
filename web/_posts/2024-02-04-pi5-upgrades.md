---
layout: blogpage
title: Raspberry Pi 5 Upgrades
subtitle: Swapping out the hardware for the latest and greatest
author: Kevin McAleer
categories: [02. Hardware]
excerpt: 
cover: /assets/img/blog/pi5_cluster.jpg
---

{:toc}
* toc

---

With the launch of the Raspberry Pi 5, it's time to upgrade the Clustered-Pi to the latest and greatest hardware. The Pi 5 has a number of improvements over the Pi 4, including a faster CPU, more memory, and better power management.

Raspberry Pi 5 also has a PCIe interface which enables us to use NVMe drives for storage. This is a significant improvement over the USB 3.0 interface on the Pi 4, which was a bottleneck for storage performance. The NVMe drives can also be used to boot from making a more reliable and faster storage solution than the SD Cards we used previously.

---

Each node in the new 4-node Clustered-Pi will have the following hardware:

* Raspberry Pi 5
* 8Gb RAM
* 1Tb NVMe Drive
* NVMe Base from Pimoroni
* 27W USB-C Power Supply

---

The configuration of the Cluster will remain the same as the Pi 4, with the same software stack and Docker Swarm configuration. The only difference will be the hardware, which will be faster and more reliable.
