#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y nginx ruby wget

# Nginx reverse proxy to Spring Boot
cat <<EOF > /etc/nginx/sites-available/default
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

systemctl enable nginx
systemctl restart nginx

# CodeDeploy Agent
cd /home/ubuntu
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl enable codedeploy-agent
systemctl start codedeploy-agent
