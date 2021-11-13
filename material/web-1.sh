#!/bin/bash

apt update
apt install -y nginx

systemctl is-active nginx

cat << EOF | tee /var/www/html/index.nginx-debian.html
<h1>Hello!</h1>
<p>Hello from DevSecOps - NginX reverse proxy workshop !</p>
EOF

curl localhost
