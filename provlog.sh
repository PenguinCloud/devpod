#!/bin/bash
lxc exec $1-devpod -- tail -f /var/log/cloud-init-output.log 
