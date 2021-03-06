# SSH Key Setup

From the commandline, type
`ssh-keygen`
This will then generate a new RSA Key pair; a public file and a private file. `ssh-keygen` will ask for a filename, type `myhost`; The Public file will be named `myhost.pub` and the private key file will be named `myhost`.

# Add the new private key 
We will now add the new private key to our local PC/Mac/Linux machine, 
Type: `ssh-add myhost`. This will add the private key to our machine. If you get an error with this, run the following command:
```
eval `ssh-agent -s`
ssh-add
```
# ssh-copy-id
To copy and install the newly generated public key to the Raspberry Pi's we can use the `ssh-copy-id` command:

```
ssh-copy-id -i ~/.ssh/myhost.pub <IP_ADDRESS>
```
 where <IP_ADDRESS> is the IP address of the Raspberry Pi we want to copy it to.

Once copied we can now test that this works:
```
ssh pi@192.168.1.235
```
- in this example the Raspberry Pi has the ip address `192.168.1.235`. Ssh should login without the need for a password.

# To remove hosts use
```
ssh-add -R <remotehost>
```
# Rinse & Repeat
Repeat this process for all the Raspberry Pis in your cluster.

---

# Install and setup Portainer
``` bash
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:2.9.3
```
