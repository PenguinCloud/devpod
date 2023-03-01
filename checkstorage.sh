#!/bin/bash
lxc list | cut -f 2 -d " " | grep -i devpod > /tmp/devpods
while IFS="" read -r p || [ -n "$p" ]
do
  lxc info $p | grep -i root
done < /tmp/devpods
