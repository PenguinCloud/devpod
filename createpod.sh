#!/bin/bash

#lxc launch --profile test images:ubuntu/20.04/cloud $1-devpod
lxc init images:ubuntu/20.04/cloud  $1-devpod  -p devpod
cat config.yaml | lxc config set $1-devpod user.user-data - 
lxc start $1-devpod  
#lxc exec $1-devpod -- systemctl disable systemd-resolved
#lxc exec $1-devpod -- systemctl stop systemd-resolved 
#lxc exec $1-devpod --  rm -rf /etc/resolv.conf 
#lxc exec $1-devpod --  echo nameserver 1.1.1.1 | tee /etc/resolv.conf
lxc exec  $1-devpod -- mkdir /opt/vnc /opt/ssh 
echo  Pushing Password 2>&1 
lxc file push passwd $1-devpod/opt/vnc/ 
lxc file push pycharm.desktop $1-devpod/opt/
echo Pushing xstartup 2>&1 
lxc file push xstartup $1-devpod/opt/vnc/ 
lxc file push pycharm-plugins.tgz $1-devpod/opt/
lxc exec  $1-devpod -- chmod u+x  /opt/vnc/xstartup 
echo Pushing service file 
lxc file push vnc.service $1-devpod/etc/systemd/system/vncserver@.service 
lxc exec  $1-devpod -- echo 'alias clog="tail -f /var/log/cloud-init-output.log"' >> /root/.bashrc
echo Create SSH Key 2>&1 | tee create.log
lxc exec $1-devpod -- ssh-keygen -b 4096 -t rsa -f /opt/ssh/id_rsa -q -N "" -C "Devpod User $1" 
lxc exec  $1-devpod -- cat /opt/ssh/id_rsa.pub 2>&1 | tee -a pubkey.log
lxc list
