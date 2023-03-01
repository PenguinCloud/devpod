'#!/bin/bash
ufw allow in on lxdbr0
ufw route allow in on lxdbr0
ufw allow in on lo from  10.0.0.0/8 to 127.0.0.0/8 port 53
ufw allow in on enp1s0 from any to any port 443
sfdisk /dev/sdb < lxd.layout
lxd init --preseed < preseed.yml
lxc profile create devpod
lxc profile edit devpod < lxd-profile.yaml
lxc network edit lxdbr0  < network.yml
#chown guacamole:guacamole server.xml
chmod 777 server.xml
docker cp ./server.xml guac:/home/guacamole/tomcat/conf/server.xml
apt install python3-certbot-nginx certbot nginx-light python3-certbot-dns-cloudflare mariadb-client -y
ufw allow in on lxdbr0 from 10.0.0.0/8 to any 
certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ./cloudflare.token \
  -d devpod.penguintech.group \
wget https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf -P /etc/letsencrypt
rm -f /etc/nginx/sites-enabled/default
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
mysql -u root --host=127.0.0.1 -p  guacdb < ./initdb.sql
