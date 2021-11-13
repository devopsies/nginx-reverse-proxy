#!/bin/bash

apt update
apt install -y nginx

systemctl is-active nginx

mkdir /var/www/html/api
echo "API works!" | tee /var/www/html/api/index.nginx-debian.html

curl localhost/api/
