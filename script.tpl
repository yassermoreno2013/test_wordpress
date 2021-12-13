#!/bin/bash
#* wait until efs mount is finished
#sleep 2m
#* update the instnce
sudo apt-get update
sudo apt install git 
#* install the efs client 
sudo apt-get -y install git binutils
sudo git clone https://github.com/aws/efs-utils
cd efs-utils
sudo ./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
#* make the target mount
sudo mkdir /efs
#* mount the efs
sudo mount -t efs -o tls ${efs_id}:/ /efs
#* insure if the instance got rebooted, the instance will remount  efs 
echo '${efs_id} ${efs_mount_id} /efs _netdev,tls,accesspoint=${efs_access_point_id} 0 0' >> /etc/fstab
#* install docker
sudo apt install docker.io -y
#* let it be run without sudo
sudo usermod -a -G docker ubuntu
#* start docker engine
sudo service docker start
sudo update-rc.d docker
#* install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
#* make it executable
sudo chmod +x /usr/local/bin/docker-compose
#* link docker-compose with bin folder so it can be called globally
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
#* give it permission to work without sudo
sudo usermod -a -G docker-compose ubuntu
#* make folders that docker-compose.yaml needs for volumes
sudo mkdir /efs/db /efs/wordpress
#* run docker-compose.yaml
cd /home/ubuntu/
sudo git clone https://github.com/yassermoreno2013/aws_terra_worpress.git
sudo docker-compose -f /home/ubuntu/aws_terra_worpress/docker-compose.yml up --build -d