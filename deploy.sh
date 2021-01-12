#!/bin/sh

echo "Creating persistent volumes..."
docker volume create mysql-server-data
docker volume create grafana-config
docker volume create grafana-storage

echo "Creating networks..."
docker network create -o encrypted --attachable mysql-net
docker network create -o encrypted --attachable zabbix-net
docker network create -o encrypted --attachable grafana-net

echo "Creating MYSQL-SERVER container"
docker run --name mysql-server -t \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      -e MYSQL_ROOT_PASSWORD="root_pwd" \
	  --network mysql-net \
	  -v mysql-server-data:/var/lib/mysql \
      --restart unless-stopped \
      -d mysql:8.0 \
      --character-set-server=utf8 --collation-server=utf8_bin \
      --default-authentication-plugin=mysql_native_password

echo "Attach mysql-server container to zabbix network"
docker network connect zabbix-net mysql-server	  
	  
echo "Creating ZABBIX-SERVER container"	  
docker run --name zabbix-server -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      --network zabbix-net \
      --link mysql-server:mysql \
      -p 10051:10051 \
      --restart unless-stopped \
      -d zabbix/zabbix-server-mysql:latest

echo "Creating ZABBIX-WEB container"	  	  
docker run --name zabbix-web -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix_pwd" \
      --network zabbix-net \
      --link mysql-server:mysql \
      --link zabbix-server:zabbix-server \
      -p 80:8080 \
      --restart unless-stopped \
      -d zabbix/zabbix-web-apache-mysql:latest
	  
	  
#Grafana

echo "Creating GRAFANA container"	  
docker run \
--name grafana -d --hostname grafana.ccelmoro.com.ar \
-v grafana-config:/etc/grafana \
-v grafana-storage:/var/lib/grafana/ \
-p 3000:3000 \
--network grafana-net \
--restart unless-stopped \
grafana/grafana:latest

echo "Attach grafana-server container to zabbix network"
docker network connect zabbix-net grafana

###AUX
echo "Installing grafana plugin for zabbix"	  
docker exec -ti grafana grafana-cli plugins install alexanderzobnin-zabbix-app	  
