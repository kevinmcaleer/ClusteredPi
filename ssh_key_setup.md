# SSH Key Setup

From the commandline, type
`ssh-keygen`
This will then generate a new RSA Key pair; a public file and a private file. `ssh-keygen` will ask for a filename, type `myhost`; The Public file will be named `myhost.pub` and the private key file will be named `myhost`.

# Add the new private key 
We will now add the new private key to our local PC/Mac/Linux machine, 
Type: `ssh-add myhost`. This will add the private key to our machine.

# ssh-copy-id
To copy and install the newly generated public key to the Raspberry Pi's we can use the `ssh-copy-id` command:

`ssh-copy-id -i ~/.ssh/myhost.pub <IP_ADDRESS>` where <IP_ADDRESS> is the IP address of the Raspberry Pi we want to copy it to.

Once copied we can now test that this works:
`ssh pi@192.168.1.235` - in this example the Raspberry Pi has the ip address `192.168.1.235`. Ssh should login without the need for a password.

# Rinse & Repeat
Repeat this process for all the Raspberry Pis in your cluster.
