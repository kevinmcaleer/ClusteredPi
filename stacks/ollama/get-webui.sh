!#/bin/bash

echo "downloading Ollama WebUI"
git clone https://github.com/open-webui/open-webui webui
cd webui
./run-compose.sh
cd ..
docker-compose up -d