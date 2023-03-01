#!/bin/bash
docker-compose up -d
docker cp ./server.xml guac:/home/guacamole/tomcat/conf/server.xml
mysql -u root --host=127.0.0.1 -p  guacdb < ./init/initdb.sql
docker restart guac
