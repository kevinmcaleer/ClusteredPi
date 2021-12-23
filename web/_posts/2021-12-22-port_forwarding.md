---
layout: blogpage
title: Port Forwarding
excerpt: Learn how to make your local server visible on the world wide web
cover: /assets/img/port_forwarding.jpg
author: Kevin McAleer
categories: [03. Networking]
---

*Learn how to make your local server visible on the world wide web.*

## What is port fowarding?
You may be familiar with the concept of ports - HTTP data is sent via port 80, Secure HTTP (HTTPS) is sent via port 443, email is sent via port 143 (IMAP) and port 110 (POP3).

| Common Port    | Port  |
|:---------------|-------|
| FTP            | 21    |
| SSH            | 22    |
| Telnet         | 23    |
| SMTP           | 25    |
| DNS            | 53    |
| HTTP           | 80    |
| POP3           | 110   |
| IMAP           | 143   |
| Minecraft      | 25565 |
| Remote Desktop | 3389  |
| PC Anywhere    | 5631  |

{:class="my-4"}

Most people have a **broadband router** to connect them to the Internet. This broadband device has a unique IP address so that every other device on the internet can be contacted. This broadband router will also provide internal network addresses to devices on your home network, such as laptops, games consoles, mobiles and tables. You may even refer this simply as your WiFi.

To make your Raspberry Pi cluster to be able to serve pages to others on the Internet we will need a way of routing internet traffic to the cluster, via the broadband router. This is where port forwarding comes in.

We will need to route **HTTP** traffic, on port **80** to our Cluster. One Raspberry Pi in our cluster will be assigned the role of Web server (or if multiple web servers as used, it will be a load balancer).

---

## How to forward ports
To forward ports, you will need to know 3 things:
1. Which **port** to forward (for web traffic it will be port `80`)
1. Which **server** to forward traffic to (in my example it is a Raspberry Pi using IP address - `192.168.1.4`)
1. How to forward ports on your [specific router](https://www.noip.com/support/knowledgebase/general-port-forwarding-guide/) - NoIP has a great guide to do this for many common routers

To help you troubleshoot port forwarding, you can use sites such as <https://www.canyouseeme.org>. This will enable you to see if your ports are open to the Internet at large.

**Warning!** Please note that opening ports can expose your network to ***cyber attacks*** - please make sure you understand the risks of doing this.
{:class="alert alert-warning"}