#!/bin/bash

apt update
apt install -y nginx

systemctl is-active nginx

cp /vagrant/nginx.conf /etc/nginx/nginx.conf && service nginx restart

systemctl is-active nginx
