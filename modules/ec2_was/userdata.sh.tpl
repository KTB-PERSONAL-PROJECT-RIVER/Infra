#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get install -y nginx ruby wget
sudo apt-get install -y openjdk-17-jdk

# Nginx reverse proxy to Spring Boot
sudo cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo systemctl enable nginx
sudo systemctl restart nginx

# CodeDeploy Agent
cd /home/ubuntu
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent
