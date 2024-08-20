!#/bin/bash

echo "downloading Ollama WebUI"
git clone https://github.com/open-webui/open-webui webui

cd webui
# ./run-compose.sh
# cd ..
# docker-compose up -d

# Copying required .env file
cp -RPp .env.example .env

# Building Frontend Using Node
npm install
npm run build

cd ./backend

# Optional: To install using Conda as your development environment, follow these instructions:
# Create and activate a Conda environment
conda create --name open-webui-env python=3.11
conda activate open-webui-env

# Install dependencies
pip install -r requirements.txt -U

# Start the application
bash start.sh