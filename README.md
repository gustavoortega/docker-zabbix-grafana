# docker-zabbix-grafana

Para CENTOS:<BR>
~$ sudo yum update -y<BR>
~$ echo y | sudo yum install -y epel-release<BR>
~$ sudo yum install -y git ansible
~$ ----sudo yum install git ansible docker vim python-pip -y<BR>
~$ ----sudo pip install docker<BR>
~$ ----sudo systemctl enable docker --now<BR>
~$ git clone https://github.com/gustavoortega/docker-zabbix-grafana.git<BR>
~$ cd docker-zabbix-grafana/<BR>
~$ sudo ansible-playbook deployment.yaml<BR>
