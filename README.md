# docker-zabbix-grafana

For CENTOS 7 only:<BR>
~$ sudo yum update -y<BR>
~$ echo y | sudo yum install -y epel-release<BR>
~$ sudo yum install -y git ansible<BR>
~$ git clone https://github.com/gustavoortega/docker-zabbix-grafana.git<BR>
~$ sudo ansible-playbook docker-zabbix-grafana/deployment.yaml<BR>
<BR><BR>
Zabbix is running on port 80 and grafana on port 3000<BR>
All settings are factory default.<BR>
<BR><BR>
Enjoy it!