# Debugging ngnix

sudo apt install nginx -y

sudo systemctl start nginx
sudo systemctl enable nginx

sudo systemctl status nginx

cat /etc/nginx/sites-available/default

sudo nano /etc/nginx/sites-available/default

replace
location / {
    try_files $uri $uri/ =404;
}
with
location / {
    proxy_pass http://127.0.0.1:6000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}

sudo nginx -t
sudo systemctl restart nginx

# Debugging for gunicorn
sudo systemctl start mldeploy_intent_gunicorn
sudo systemctl enable mldeploy_intent_gunicorn

systemctl status mldeploy_intent_gunicorn

cat /etc/systemd/system/mldeploy_intent_gunicorn.service

sudo nano /etc/systemd/system/mldeploy_intent_gunicorn.service

sudo systemctl daemon-reload
sudo systemctl restart mldeploy_intent_gunicorn
sudo systemctl status mldeploy_intent_gunicorn

# verify gunicorn actually exists in the venv:
ls /opt/intent-app/.venv/bin/
ls /opt/intent-app/.venv/bin/gunicorn
ls /opt/intent-app/