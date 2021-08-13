#!/bin/bash

apt update
apt install -y nginx

cp /vagrant/web-2.index.html /usr/share/nginx/html/index.html
cp /vagrant/web-2.html /usr/share/nginx/html/web-2.html
