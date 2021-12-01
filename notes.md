## Create a volume
docker volume create site

## Create a new blank site:
docker run -v site:/site bretfisher/jekyll new .


## Docker command for spinningi up the jekyll site server
docker run -p 4000:4000 -v site:/site bretfisher/jekyll-serve

---
docker run -d 

Install K3S using ansible-playbook

# Install mosquitto
docker run -itd -p 1883:1883 -p 9001:9001 -v /home/pi/ClusteredPi/config:/mosquitto/config eclipse-mosquitto -restart=always
