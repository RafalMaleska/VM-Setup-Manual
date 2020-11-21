#!/bin/bash

### TO-DOs

# Place The SSH Private key (id_rsa.key) into ~/.ssh

### Variables

export username=rmanhart
export repository=https://github.com/RafalMaleska/VM-Setup


### Add Apt for Installation
sudo apt install vim curl git -y 
sudo mkdir ~/projects
cd ~/projects/
sudo git clone $repository


### Add User
sudo usermod -aG sudo $username
sudo mkdir -p /home/$username/.ssh
sudo -i
sudo echo "$username ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rmanhart
chmod 0440 /etc/sudoers.d/rmanhart
exit


### Add SSH
# Important: copy SSH Key into ~/.ssh before
echo "ForwardAgent yes" >> ~/.ssh/config
chmod 600 ~/.ssh/id_rsa.key
ssh-add ~/.ssh/id_rsa.key
ssh-keygen -y -e -f ~/.ssh/id_rsa.key > ~/.ssh/id_rsa.pub
chmod 666 ~/.ssh/id_rsa.pub
eval `ssh-agent -s`


### Customization
timedatectl set-timezone Europe/Berlin
# Set Keyboard to German
setxkbmap de 


### Install VirtualBox Addons
sudo apt-get install dkms virtualbox-guest-dkms
sudo apt install build-essential dkms linux-headers-generic 
sudo apt-get install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
# extension pack
sudo apt install virtualbox
sudo apt install virtualbox-ext-pack
sudo modprobe vboxdrv
sudo apt install virtualbox-dkms
sudo apt install virtualbox-qt
modinfo vboxguest


### Install Basic Software
sudo apt install -y apt-transport-https \
    ca-certificates \
    software-properties-common \
    gnupg-agent \
    wget \
    tree \
    awscli \
    htop \
    guake \

# VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install -y code
# install vscode extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.Go
code --install-extension donjayamanne.githistory
code --install-extension erd0s.terraform-autocomplete
code --install-extension huizhou.githd mauve.terraform
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension redhat.vscode-yaml
code --install-extension stayfool.vscode-asciidoc
code --install-extension yzhang.markdown-all-in-one




### Install Kubernetes Stuff
# Docker 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install update
sudo apt-get install docker-ce docker-ce-cli containerd.io
#check status
sudo systemctl status docker
#create docker group
newgrp docker
#add user to docker group
usermod -aG docker $username
#test the installation
docker version

# Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install kubeadm kubelet kubectl


# Helm 
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm



### Install Multimedia

sudo apt install -y chromium-browser \ 

# Install Walpaper


### Get All Updates
sudo apt upgrade -y
sudo apt autoremove -y


### Manual Steps: 

# Add Keyboard Layout Icon on the TopBar

# Set Walpaper 
