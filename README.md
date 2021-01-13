# docker-zabbix-grafana

Para CENTOS:<BR>
~$ sudo yum update -y<BR>
~$ sudo yum install epel-release -y<BR>
~$ sudo yum install git ansible docker vim python-pip -y<BR>
~$ sudo pip install docker<BR>
~$ sudo systemctl enable docker --now<BR>
~$ git clone https://github.com/gustavoortega/docker-zabbix-grafana.git<BR>
~$ cd docker-zabbix-grafana/<BR>
~$ sudo ansible-playbook deployment.yaml<BR>
