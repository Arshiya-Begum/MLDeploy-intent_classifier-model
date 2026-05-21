#!/bin/bash

# Directory
# Update packages
# Git clone to download the source code
# Python venv and activate the venv
# Install python dependencies using requirements.txt
# Run the model and create .pkl file
# Execute WSGi -> as Linux systemd service
# Install Nginx -> as Linux systemd service
# Enable these services - Even during restart services will go back to running state

set -e

export APP_DIR=/opt/intent-app
mkdir -p $APP_DIR
cd $APP_DIR

apt update -y
apt install -y git python3 python3-venv python3-pip nginx

git clone https://github.com/Arshiya-Begum/MLDeploy-intent_classifier-model.git .

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

python3 -m pip install -r requirements.txt

python3 model/train.py

# Configure Gunicorm systemd service
cat >/etc/systemd/system/mldeploy_intent_gunicorn.service <<'EOF'
[Unit]
Description=Gunicorn instance for Intent Classifier
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/opt/intent-app
Environment="PATH=/opt/intent-app/.venv/bin"
ExecStart=/opt/intent-app/.venv/bin/gunicorn --workers 3 --bind 127.0.0.1:6000 wsgi:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Configure nginx reverse proxy as a Linux systemd service
cat >/etc/nginx/conf.d/mldeploy_intent_app.conf <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:6000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_connect_timeout 60s;
        proxy_read_timeout 120s;
    }
}
EOF

# Disable default nginx site to avoid conflicts
rm -f /etc/nginx/sites-enabled/default

# Start and enable Linux systemd servives - Gunicorn and Nginx
systemctl daemon-reload
systemctl enable mldeploy_intent_gunicorn
systemctl start mldeploy_intent_gunicorn
systemctl enable nginx
systemctl restart nginx 