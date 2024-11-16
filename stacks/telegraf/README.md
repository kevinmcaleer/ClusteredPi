Add 

`export HOSTNAME=$(hostname)`

to the `/etc/profile` at the end of the file. Make sure you log out and back in for this to take effect

---

To read the docker containers, the `/var/run/docker.socket` will need to have its permissions changed to:

`sudo chmod 777 /var/run/docker.sock`

Which isn't the most secure, but it's the easiest way to get it working.