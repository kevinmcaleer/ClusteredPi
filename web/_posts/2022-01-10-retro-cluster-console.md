---
layout: blogpage
title: 3D Printed Retro Cluster Console
subtitle: Print your own terminal
author: Kevin McAleer
categories: [02. Hardware]
excerpt: 3D Print your own retro cluster console, based on the Cray-1 terminal console
cover: /assets/img/blog/screen.png
---

{:toc}
* toc

## Overview 


![](/assets/img/blog/console08.jpg){:class="container mt-4 img-fluid"}


## 3d Printed Parts & STL Files
This project consists of three 3d printed parts:

| Filename                           | Description            |
|------------------------------------|------------------------|
| [`bottom.stl`](/assets/stl/bottom.stl)         | The bottom of the case |
| [`Front_Case.stl`](/assets/stl/front_case.stl) | The front section      |
| [`Shroud.stl`](/assets/stl/shroud.stl)         | The top cover          |


## Electronics
The screen used is a [Pimoroni HyperPixel 4.0](https://shop.pimoroni.com/products/hyperpixel-4?variant=12569539706963), and the computer is a Raspberry Pi Zero W. The project can be battery powered using a pair of 18650s and a [diymore 18650 Battery Shield V8 3V 5V Micro USB Port Type-C USB for Raspberry Pi ESP32 ESP8266 Wifi](https://www.amazon.co.uk/gp/product/B0822Q4VS4/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)

The case fits together without the need for any glue or screws. The screen might need a couple of blobs of Blutac to hold it in place.

## Gallery
Here are a couple of pictures of the finished model.

{:class="row"}
[![](/assets/img/blog/console01.jpg){:class="img-fluid"}](/assets/img/blog/console01.jpg){:class="col-3 container"}
[![](/assets/img/blog/console02.jpg){:class="img-fluid"}](/assets/img/blog/console02.jpg){:class="col-3 container"}
[![](/assets/img/blog/console03.jpg){:class="img-fluid"}](/assets/img/blog/console03.jpg){:class="col-3 container"}
[![](/assets/img/blog/console06.jpg){:class="img-fluid"}](/assets/img/blog/console06.jpg){:class="col-3 container"}

{:class="row"}
[![](/assets/img/blog/console04.jpg){:class="img-fluid"}](/assets/img/blog/console04.jpg){:class="col-3 container"}
[![](/assets/img/blog/console05.jpg){:class="img-fluid"}](/assets/img/blog/console05.jpg){:class="col-3 container"}

---

## Power
The 18650 batteries last a couple of hours, and its a convenient  size to use and have on the desk. You can connect a USB cable to charge the console, without having to power it down too.

---

## Terminal hacking
[Here is a cool way](/blog/how-to-hack-your-terminal) to extend the terminal to make it even more fun. 

I've also connected up a wireless keyboard to the Raspberry Pi (this version uses RF, rather than bluetooth, but a bluetooth keyboard will work fine too).

To quickly setup the Raspberry Pi Console - see [this article](/blog/raspberry-pi-imager-secret-menu) on the Raspberry Pi Imager.

I hope you enjoy this project!
Kevin

PS this is also available on [Hackster.io](https://www.hackster.io/kevinmcaleer/retro-computer-console-decdec)