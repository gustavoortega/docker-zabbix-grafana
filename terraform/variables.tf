variable "container_mysql_name" {
  description = "Name for mysql container"
  type        = string
  default     = "mysql-server-using-tfvars"
}

variable "container_zabbix_name" {
  description = "Name for zabbix prefix container"
  type        = string
  default     = "zabbix-using-tfvars"
}

variable "container_grafana_name" {
  description = "Name for grafana container"
  type        = string
  default     = "grafana-using-tfvars"
}

variable "mysql_zabbix_username" {
  description = "Username created for Zabbix´s database connection"
  type        = string
  default     = "zabbix"
  sensitive = true
}

variable "mysql_zabbix_database" {
  description = "Database name used by Zabbix"
  type        = string
  default     = "zabbix"
  sensitive = true
}

resource "random_password" "mysql_root_pw" {
  #For usage: random_password.mysql_root_pw.result
  length = 16
  special = true
  override_special = "_%@"
}

resource "random_password" "mysql_zabbix_pw" {
  #For usage: random_password.mysql_zabbix_pw.result
  length = 16
  special = true
  override_special = "_%@"
}

