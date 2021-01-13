# docker-zabbix-grafana

Para CENTOS:<BR>
~$ sudo yum update -y<BR>
~$ echo y | sudo yum install -y epel-release<BR>
~$ sudo yum install -y git ansible<BR>
~$ git clone https://github.com/gustavoortega/docker-zabbix-grafana.git<BR>
~$ sudo ansible-playbook docker-zabbix-grafana/deployment.yaml<BR>
