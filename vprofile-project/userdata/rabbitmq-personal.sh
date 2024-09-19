#!/bin/bash
#RHEL 9

#Aprovisionamiento de RabbitMQ
sudo update-crypto-policies --set LEGACY
sudo reboot

## We will install RabbitMQ with a YUM repository that contains the package.
sudo dnf -y install wget
wget https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh -O rabbitmq_script.rpm.sh
chmod +x  rabbitmq_script.rpm.sh
sudo os=el dist=8 ./rabbitmq_script.rpm.sh

## Next is to add the YUM repository under the /etc/yum.repos.d/ directory that will install RabbitMQ and its Erlang dependency from PackageCloud.

wget https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh -O erlang_script.rpm.sh
chmod +x  erlang_script.rpm.sh
sudo os=el dist=8 ./erlang_script.rpm.sh

## Update the system after installing the repositories required.
sudo yum -y update
## Depending on the version of Erlang and RabbitMQ, the package names may vary.
sudo yum install socat logrotate -y
## Install Erlang and RabbitMQ
sudo yum install rabbitmq-server erlang -y
# Start the RabbitMQ service and enable it to start on boot.
sudo systemctl enable --now rabbitmq-server


#Firewall
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --reload

########################## ORIGINAL END OF FILE ##########################
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server