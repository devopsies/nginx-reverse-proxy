#!/bin/bash

cat << EOF | tee -a /etc/hosts
10.10.10.10 web-1.com
10.10.10.10 web-2.com
EOF
