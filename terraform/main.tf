terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

provider "docker" {}

resource "docker_network" "mysql-net" {
  name = "mysql-net"
  check_duplicate = true
  attachable = true
}

resource "docker_network" "zabbix-net" {
  name = "zabbix-net"
  check_duplicate = true
  attachable = true
}

resource "docker_network" "grafana-net" {
  name = "grafana-net"
  check_duplicate = true
  attachable = true
}

resource "docker_volume" "mysql-server-data" {
  name = "mysql-server-data"
}

resource "docker_volume" "grafana-config" {
  name = "grafana-config"
}

resource "docker_volume" "grafana-storage" {
  name = "grafana-storage"
}

resource "docker_image" "mysql-server" {
  name = "mysql:8.0"
}

resource "docker_image" "zabbix-server" {
  name = "zabbix/zabbix-server-mysql:latest"
}

resource "docker_image" "zabbix-web" {
  name = "zabbix/zabbix-web-apache-mysql:latest"
}

resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "mysql-server" {
  name  = var.container_mysql_name
  image = docker_image.mysql-server.name
  volumes {
            volume_name = docker_volume.mysql-server-data.name
            container_path = "/var/lib/mysql"
          }
  networks_advanced {
    name = docker_network.mysql-net.name
  }
  networks_advanced {
    name = docker_network.zabbix-net.name
  }
  
  restart = "unless-stopped"
  env = [
  "MYSQL_DATABASE=${var.mysql_zabbix_database}",
  "MYSQL_USER=${var.mysql_zabbix_username}",
  "MYSQL_PASSWORD=${random_password.mysql_zabbix_pw.result}",
  "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_pw.result}"
  ]

  start = true
  command = ["mysqld", "--character-set-server=utf8", "--collation-server=utf8_bin", "--default-authentication-plugin=mysql_native_password"]
}

resource "docker_container" "zabbix-server" {
  name  = "${var.container_zabbix_name}-server"
  image = docker_image.zabbix-server.name
  networks_advanced {
    name = docker_network.zabbix-net.name
  }
  ports {
      internal = 10051
      external = 10051
  }
  links = ["${var.container_mysql_name}:mysql"]
  restart = "unless-stopped"
  env = [
  "MYSQL_DATABASE=${var.mysql_zabbix_database}",
  "MYSQL_USER=${var.mysql_zabbix_username}",
  "MYSQL_PASSWORD=${random_password.mysql_zabbix_pw.result}",
  "DB_SERVER_HOST=${var.container_mysql_name}",
  "ZBX_CACHESIZE=256M",
  "ZBX_STARTVMWARECOLLECTORS=2",
  "ZBX_TIMEOUT=20"
  ]

  start = true

  depends_on = [docker_container.mysql-server]
}

resource "docker_container" "zabbix-web" {
  name  = "${var.container_zabbix_name}-web"
  image = docker_image.zabbix-web.name
  networks_advanced {
    name = docker_network.zabbix-net.name
  }
  ports {
      internal = 8080
      external = 80
  }
  links = ["${var.container_mysql_name}:mysql", "${var.container_zabbix_name}-server:zabbix-server"]
  restart = "unless-stopped"
  env = [
  "MYSQL_DATABASE=${var.mysql_zabbix_database}",
  "MYSQL_USER=${var.mysql_zabbix_username}",
  "MYSQL_PASSWORD=${random_password.mysql_zabbix_pw.result}",
  "DB_SERVER_HOST=${var.container_mysql_name}",
  "PHP_TZ=sAmerica/Argentina/Buenos_Aires"
  ]

  start = true

  depends_on = [docker_container.mysql-server, docker_container.zabbix-server]
}

resource "docker_container" "grafana" {
  name  = var.container_grafana_name
  image = docker_image.grafana.name
  networks_advanced {
    name = docker_network.zabbix-net.name
  }
  networks_advanced {
    name = docker_network.grafana-net.name
  }
  ports {
      internal = 3000
      external = 3000
  }
  
  restart = "unless-stopped"
  volumes {
            volume_name = docker_volume.grafana-config.name
            container_path = "/etc/grafana"
          }
  volumes {
            volume_name = docker_volume.grafana-storage.name
            container_path = "/var/lib/grafana/"
          }

  start = true

  depends_on = [docker_container.zabbix-web]
}