# DevSecOps Workshops: NGINX Reverse Proxy

This is a brief documentation of NGINX, followed by a workshop. For the workshop material, visit <a href="https://github.com/devopsies/nginx-reverse-proxy" target="_blank">github.com/devopsies/nginx-reverse-proxy</a>. For a complete documentation, visit <a href="https://nginx.org/en/docs/" target="_blank">nginx.org/en/docs</a>.

## What is NGINX?

NGINX, is a web server that can also be used as a reverse proxy, load balancer, mail proxy, HTTP cache and many more. Visit <a href="https://docs.nginx.com" target="_blank">docs.nginx.com</a> for a better understanding of NGINX products. In this workshop we'll be using NGINX Open Source: The open source all-in-one load balancer, content cache, and web server.

## Start using NGINX

In this workshop, the NGINX setup is performed inside Vagrant VMs. We will try to implement the following architecture:

<img src="imgs/target-arch.png"/>

The Vagrantfile in the material folder contains the VMs definition and can be run using `vagrant up --provider virtualbox`, which brings up the VMs and the required network configuration. You can SSH into a VM using `vagrant ssh <vm-hostname>` on your host.

In this workshop we will run two web servers: the first one `web-1` will host our website's main page (i.e `mywebsite.com/`), and the second one `web-2` will host our API on the same domain name (i.e `mywebsite.com/api/`). To do this, we will configure the `client` VM to resolve the domain name `mywebsite.com` to the IP address of the `web-proxy` VM, then we configure the `web-proxy` VM to forward `http://mywebsite.com/` requests to the `web-1` VM and `http://mywebsite.com/api` requests to the `web-2` VM. The configuration is provided in bash scripts in the `material` folder of this repo, but is not automatically applied. I advise students not to copy paste them, and try to finish the workshop on their own, then use the provided scripts for verification.

### Launching Vagrant machines

In this workshop, 4 Vagrant VMs will consume 512 MB of RAM (total of 2 GB) and will use 1 vCPU. First, clone this repository locally, change into the `material` folder, then run the Vagrant VMs:

```bash
git clone https://github.com/devopsies/nginx-reverse-proxy
cd nginx-reverse-proxy/material
vagrant up --provider virtualbox
```

### Installing NGINX and running a web server

When Vagrant VMs are running, SSH into the `web-1` VM:

```bash
vagrant ssh web-1
```

Since we're using a Ubuntu server 20.04 Vagrant Box, installing NGINX is as simple as:

```bash
sudo apt update
sudo apt install -y nginx
```

You can check the NGINX service by running:

```bash
sudo service nginx status
```

Since you're on the `web-1` VM, you can run `curl 10.10.10.11` to view the web page. The NGINX service is aleady running and serving a default web page. Modify the content of `/var/www/html/index.nginx-debian.html` from within the `web-1` VM to display other content, then try `curl` again.

Exit the `web-1` VM and SSH into the `web-2` VM. Install NginX the same way. In the `web-2` VM, create the folder `api` under the public html folder `/var/www/html/`, then create a new `index.nginx-debian.html` file there with a unique content of your choice:

```bash
sudo mkdir /var/www/html/api
echo "API works!" | sudo tee /var/www/html/api/index.nginx-debian.html
```

Make sure you can access the new API by running `curl localhost/api/` from within the `web-2` VM.

### Installing NGINX and running a reverse proxy

Exit the `web-2` VM and SSH into the `web-proxy` VM. Install NGINX the same way. The service will automatically start serving the default web page as ususal. Don't bother changing the content of the HTML.

Exit the `web-proxy` VM and SSH into the `client` VM. Modify the `hosts` file `/etc/hosts` and add this line at the end:

```
10.10.10.10 mywebsite.com
```

This way, we're instructing the `client` VM to resolve `mywebsite.com` to the private IP of the `web-proxy` VM, without having to rely on an external DNS. Run `curl mywebsite.com` from within the `client` VM to confirm the setup, it should return the default NginX web page of the `web-proxy` VM. Running `curl mywebsite.com/api/` from within the `client` VM should return `404 not found`.

Next, exit the `client` VM and SSH back into the `web-proxy` VM. Display the content of `/etc/nginx/nginx.conf` study it. Figure out which configuration section instructs NGINX to serve his default web page. Study it carefully (for you own learning :D) then remove it, since we'll be configuring this NGINX service to work as a reverse-proxy.

Finally, you have to configure NGINX service in the `web-proxy` VM to do the following:
1. Listen on port 80 for http traffic intended to `mywebsite.com`.
2. When it receives requests from clients that used `mywebsite.com` domain name with the root location `/` (i.e `mywebsite.com` or `mywebsite.com/`), it proxies their requests to `http://10.10.10.11`.
3. When it receives requests from clients that used `mywebsite.com` domain name with the `/api` location (i.e `mywebsite.com/api`), it proxies their requests to `http://10.10.10.12`.

You can check your setup by running these commands from the `client` VM:
1. `curl mywebsite.com` (returns the default page of the `web-1` VM).
2. `curl mywebsite.com/api/` (returns the API response of the `web-2` VM.

Start experimenting on your own. When you finish, you can take a look at the `material/nginx.conf` configuration file provided in this repo to compare your work with mine.
