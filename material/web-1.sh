#!/bin/bash

apt update
apt install -y nginx

cp /vagrant/web-1.index.html /usr/share/nginx/html/index.html
cp /vagrant/web-1.html /usr/share/nginx/html/web-1.html
