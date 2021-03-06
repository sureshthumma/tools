#!/bin/bash

echo "Starting setup `date` " > uhost_setup.log

mkdir install_tmp
cd install_tmp

sudo apt-get -y update

# Install Node.Js

NODE_VER=5.5.0

echo "Installing Node JS version ${NODE_VER}" >> uhost_setup.log

wget http://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}-linux-x64.tar.gz -O /tmp/node-v${NODE_VER}.tar.gz
tar -xvf /tmp/node-v${NODE_VER}.tar.gz -C /tmp
sudo mv /tmp/node-v${NODE_VER}-linux-x64 /opt/nodejs-v${NODE_VER}

echo "ln -s /opt/nodejs-v${NODE_VER}/bin/node /usr/bin/node"
sudo ln -s /opt/nodejs-v${NODE_VER}/bin/node /usr/bin/node
sudo ln -s /opt/nodejs-v${NODE_VER}/bin/npm /usr/bin/npm
node-${NODE_VER} -v
rm /tmp/node-v${NODE_VER}.tar.gz

echo "Installing git wget ansible" >> uhost_setup.log

echo Installing Git wget
sudo apt-get install -y git wget ansible

echo "Installing Robo Mongo" >> uhost_setup.log

#installing robo mongo
wget https://download.robomongo.org/1.0.0-rc1/linux/robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz
tar xf robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz
sudo mv robomongo-1.0.0-rc1-linux-x86_64-496f5c2 /opt/robomongo-1.0.0
sudo ln -s /opt/robomongo-1.0.0/bin/robomongo /usr/bin/robomongo


echo "Installing Visual Studio Code" >> uhost_setup.log
echo Installing Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders


#downloading rocket chat client
echo "installing rocket chat" >> uhost_setup.log
wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/2.6.0/rocketchat_2.6.0_amd64.deb
sudo dpkg -i rocketchat_2.6.0_amd64.deb
sudo apt-get -f install 

echo "Installing zoom plugin" >> uhost_setup.log
wget https://zoom.us/client/latest/zoom_amd64.deb

sudo dpkg -i zoom_amd64.deb
sudo apt -f install 

echo "Installing Docker" >> uhost_setup.log
curl -fsSL https://get.docker.com | sudo sh

echo "Installing Docker Compose" >> uhost_setup.log
sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installing VirtualBox" >> uhost_setup.log
echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-5.1
sudo apt-get install dkms
sudo apt -f install 

echo "*** Installing Chrome" >> uhost_setup.log

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt -f install 

echo deleting install folder
cd .. && rm -rf install_tmp

sudo mkdir /opt/devzone
sudo chmod 777 /opt/devzone

cat <<EOF >  /opt/devzone/ansible.cfg

[defaults]
# some basic default values...
inventory      = /opt/devzone/ansible/hosts
roles_path    = /opt/devzone/ansible/roles
host_key_checking = False
[privilege_escalation]
#no defaults
[paramiko_connection]
#no default
[ssh_connection]
#no defaults
[accelerate]
#no defaults
[selinux]
#no defaults
[colors]
#no defaults
EOF

sudo apt -f install 
sudo mv /opt/devzone/ansible.cfg /etc/ansible/ansible.cfg

ansible -v
docker --version
docker-compose --version
