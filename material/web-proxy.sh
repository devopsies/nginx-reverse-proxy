#!/bin/bash

apt update
apt install -y nginx

cp /vagrant/nginx.conf /etc/nginx/nginx.conf

service nginx restart
