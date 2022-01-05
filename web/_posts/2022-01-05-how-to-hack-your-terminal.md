---
layout: blogpage
title: How to Hack the Raspberry Pi Terminal
author: Kevin McAleer
categories: [04 Software]
excerpt: Learn how to customize the Raspberry Pi Terminal
cover: /assets/img/blog/terminal-hacks.jpg
---

{:toc}
* toc

## Overview 
There are a couple of cool things you can do to customize or hack your Raspberry Pi Terminal.

There is an accompanying video to go along with this article:
[![](https://i.ytimg.com/vi/-nMNtW2SAsM/maxresdefault.jpg){:class="container mt-4 img-fluid"}](https://youtu.be/-nMNtW2SAsM)

---

## Synth-Shell
Synth-shell is that cool looking coloured bar prompt at the bottom of the screen that displays the hostname, username and current path. It's really easy to install:

### Installing Synth-Shell
``` bash
git clone --recursive https://github.com/andresgongora/synth-shell.git
chmod +x synth-shell/setup.sh
cd synth-shell
./setup.sh
sudo apt install fonts-powerline
```

You can also customize the colours by editing the file:

``` bash
nano ~/.config/synth-shell/synth-shell-prompt.config
```
and changing the colour values of lines:

``` bash 
font_color_user="white"
background_user="blue"
texteffect_user="bold"

font_color_host="white"
background_host="light-blue"
texteffect_host="bold"

font_color_pwd="dark-gray"
background_pwd="white"
texteffect_pwd="bold"
```

You can either use a colour name such as `white` or the terminal colour code, there is a full list of terminal colour codes [can be found here](https://en.wikipedia.org/wiki/ANSI_escape_code) (scroll down to the 8 bit color section).

### Installing Powerline fonts
To view the terminal properly from another machine, such as a Windows PC, Apple Mac or Linux machine you will need to install the Powerline fonts (Click [here](https://github.com/powerline/fonts.git) for a link to the powerline fonts).

You will need to enable the `Hack` font in your terminal program as the default font. On macOS this is in the Terminal Preferences settings (the default macOS font for terminal is `SF Mono`).

---

## Neofetch
![Terminal screenshot](/assets/img/blog/terminal.png){:class="img-fluid"}

Neofetch displays statistics and information about your current Raspberry Pi host. It also displays an Ascii art graphic on the left hand side of the screen, which you can switch out with other Ascii-Art of your choosing - we'll do this later.

### Installing Neofetch
To install Neofetch, type:

``` bash
sudo apt install neofetch
```

To run Neo fetch directly after login, add 
`neofetch`

as the last line to the `.profile` file in your home directory - `$HOME`.

---

## SSH Login Message
When you type `ssh pi@raspberrypi.local` to login to your Pi, it just prompts you for a password. However you can customize this to add more information, such as the hostname, or a warning message etc.

### Editing the SSH Login Message
First of all - edit the file `/etc/ssh/sshd_config` and change the line that says 

`#Banner None`

to

`Banner /etc/issue.net`

To do this type:

```
sudo nano /etc/ssh/sshd_config
``` bash
And scroll down to the `#Banner None` line.
Once you've saved the file (with `CTRL + x` to write the file), you can then edi the `issue.net` file:

```
sudo nano /etc/issue.net 
```

This will edit the ssh message file.
Add something like `Warning do not access this system unless you have permission to do so.`

Again, save the file using `CTRL + x`.

Next, restart the `ssh daemon` using the command

``` bash
sudo systemctl restart sshd
```

Log out and log back in to see the new message.

---

## motd - Message of the Day
There is a file called Message of the Day which is displayed just after loing (before our new Neofetch command is run). The intention for this file is to enable system administrators to provide timely information to end users, when logging in to a multiuser Unix system. Examples of this would be planned maintenance windows where the system will be unavailable, or contact information to report faults and raise requests via a help desk etc.

The motd file can be found at `/etc/motd`.

You can edit this file by typing:
``` bash
sudo nano /etc/motd
```
Once you have made your changes press `CTRL + x` to save the file.

You will see these changes the next time you login.

---

## Fortune
`Fortune` is a fun utility that provides a random quote or limerick form a huge library.

### Installing Fortune
To install `Fortune` simply type:

``` bash
sudo apt install fortune
```

To get a fortune, simply type:

``` bash
fortune
```

---

## Cowsay
Cowsay displays an ascii graphic of a cow with a speech bubble. You can provide text for Cowsay to display.

### Installing Cowsay
To install `cowsay` simply type:

``` bash
sudo apt install cowsay
```

You can pipe information into `cowsay` from other programs, such as `fortune` - 

``` bash 
fortune | cowsay
```

You can also change the character of cowsay using the `-f` parameter:
```bash
fortune | cowsay -f tux
```

or

```bash
fortune | cowsay -f hellokitty
```

There are lots of characters to choose from (google `cowsay characters` for more).

---

## Putting it all together
Type:

``` bash
neofetch --ascii "$(fortune | cowsay -W 30)"
```

And neofetch will display the cowsay character, speaking a fortune, with all the Raspberry Pi stats next to it.

To make this show at login, replace the:

`neofetch` 

line you added to the `.profile` file you edited earlier (it can be found at `$HOME.profile`), with the line:

`neofetch --ascii "$(fortune | cowsay -W 30)"`

---

Hope you have fun with this!

-Kevin