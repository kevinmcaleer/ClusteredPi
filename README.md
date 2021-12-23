# Clustered-Pi
Welcome to Clustered-Pi

# Installing Ansible
To install Ansible we can use the Python package manager 'Pip'. On your main computer, open a terminal/commandline.

## Clone the Clustered-Pi repository
Type:
`git clone https://github.com/kevinmcaleer/clusteredpi`

## Create a new Python virtual Environment
Type:
`python3 -m venv venv`

## Activate the environment
Type:
`source venv/bin/activate`

## Install the dependencies
Type:
`pip install pip --upgrade`
`pip install -r requirements.txt`

---

# To run a playbook
`ansible-playbook apt-update.yml -u=pi` - the -U parameter changes the login username to `pi` rather than the currently logged in user on the master PC.

* `apt-update.yml` - updates the Raspberry Pi's package management system 


# Playbooks
Grafana - default username is admin, password admin.

---
To run the playbooks, makes sure you `source venv\bin\activate` in the `ClusteredPi` folder