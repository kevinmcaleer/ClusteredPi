---
layout: blogpage
title: Raspberry Pi Imager Secret Menu
author: Kevin McAleer
categories: [04 Software]
excerpt: Learn about the secret menu in the Raspberry Pi Imager 
cover: /assets/img/blog/raspberrypi-imager.png
---

The [Raspberry Pi Imager](https://www.raspberrypi.org/software) is a great piece of software for preparing your SD cards for use with Raspberry Pis. However, if you're setting up a number of Raspberry Pis you will find that you still need to connect a monitor, keyboard and mouse to them to complete the setup, to:
- update the wifi ssid and password
- change the hostname and default password
- change localisation settings

There is another, better alternative to doing those 3 steps - use the Raspberry Pi Imager secret menu. 

## CTRL + SHIFT + X
To activate the secret menu, hold down `CTRL + SHIFT + X` after you have already choosen the OS and storage device.

This will open up the secret menu:

![Screenshot](/assets/img/blog/rpi-imager01.png){:class="img-fluid my-4"}

---

### Image Customization Options
The first drop down allows you to select if the settings are for just this session, or settings you want to keep everytime you run the Raspberry Pi imager.

Image Customization Options:
- to always use
- for this session only

---

### Overscan, hostname, ssh, wifi and locale 
The next group of settings allow you to change:
- the hostname, which defaults to `Raspberrypi`
- whether you want to enable `ssh` for remote connection, which is especially useful if you don't intend to use a monitor (so called headless)
- what the `ssh` password for the default `pi` user is or if you want to use a public-key instead (paste your key in the field)
- if you want to configure the wifi, and what the SSID and password are, along with the Wifi Country - it will pull your currently connected SSID and password if you are using this over wifi
- whether you want to skip the `first-run wizard` which runs the first time you boot the pi

![Screenshot](/assets/img/blog/rpi-imager02.png){:class="img-fluid m-0 p-1 w-50"}
![Screenshot](/assets/img/blog/rpi-imager03.png){:class="img-fluid m-0 p-1 w-50"}
{:class="row"}

---

### Persistent settings
Finally, the persistent settings - these are for the imager app:
- `Play sound when finished`, does exactly that - once image has been written it will play the OS's alert sound
- `Eject media when finished`, will unmount the ssd card 
- `Enable telemetry` - sends data back to the Raspberry Pi organisation about how you used the app, so that they can understand usage and make it better in subsequent releases.

![Screenshot](/assets/img/blog/rpi-imager04.png){:class="img-fluid m-0 p-1 w-50"}

---

### Summary
For me, changing the hostname and configuring the wifi settings are the most useful parts of this app, my only wish is that they would add a button to the main UI instead of making it a hidden menu that you would only know about if you read the [blog article back](https://www.raspberrypi.com/news/raspberry-pi-imager-update-to-v1-6/) in March 2021.