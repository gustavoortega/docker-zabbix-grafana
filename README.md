# docker-zabbix-grafana

Para CENTOS:
~$ sudo yum update -y
~$ sudo yum install epel-release -y
~$ sudo yum install git ansible docker vim python-pip -y
~$ sudo pip install docker
~$ sudo systemctl enable docker --now
~$ git clone https://github.com/gustavoortega/docker-zabbix-grafana.git
~$ cd docker-zabbix-grafana/
~$ sudo ansible-playbook deployment.yaml
