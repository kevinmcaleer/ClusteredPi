## Create a volume
docker volume create site

## Create a new blank site:
docker run -v site:/site bretfisher/jekyll new .


## Docker command for spinningi up the jekyll site server
docker run -p 4000:4000 -v site:/site bretfisher/jekyll-serve


Install K3S using ansible-playbook

---

# Installing 

docker run -it -p 1883:1883 -p 9001:9001 -v /home/pi/ClusteredPi/config:/mosquitto/configeclipse-mosquitto