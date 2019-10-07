## Variables
#User
export username=rmanhart

## Add User ##
sudo useradd $username
echo $username:U6aMy0wojraho | sudo chpasswd -e
sudo mkdir -p /home/$username/.ssh
sudo adduser $username sudo
sudo chown -R $username /home/$username 
sudo su $username


## Set the timezone ##
timedatectl set-timezone Europe/Berlin


## Update System and Dependencies ##
sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove
sudo snap refresh
sudo apt update


## Base Packages - Install base packages ##
sudo apt install -y vim \
    curl \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    wget


## SSH-Agent - Install ##
#copy the key from shared folder
cp ~/sharedProjectFolder/key.ppk ~/.ssh
sudo apt-get install -y putty-tools
puttygen ~/.ssh/key.ppk -O private-openssh -o ~/.ssh/id_dsa
puttygen ~/.ssh/key.ppk -O public-openssh -o ~/.ssh/id_dsa.pub
chmod 600 ~/.ssh/id_dsa
chmod 666 ~/.ssh/id_dsa.pub
chmod 666 ~/.ssh/known_hosts
echo "Host 10.43.151.100 gitlab.reisendeninfo.aws.db.de" >> config
echo "ForwardAgent yes" >> config
eval `ssh-agent -s`
ssh-add ~/.ssh/id_dsa

#add private private key
cp ~/shared/allmighty ~/.ssh
cp ~/shared/allmighty.pub ~/.ssh
chmod 666 ~/.ssh/allmighty.pub
chmod 666 ~/.ssh/allmighty
ssh-add ~/.ssh/allmighty


## Install Tools ##
#Visual Studio Code:
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code
#install vscode extensions
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

#Guake
sudo apt-get install guake -y

#Chromium
sudo apt-get install -y chromium-browser


## Install SDK ##
#Go

#OpenJDK
sudo apt install -y openjdk-11-jdk


## Containerization ##

#Docker
#remove unnecessary
sudo apt-get purge docker docker-engine docker.io
#install basic tools
sudo apt install apt-transport-https ca-certificates curl software-properties-common
#get official gpg keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add 
#add docker's stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#install latest stable docker ce
sudo apt-get install docker-ce
#check status
sudo systemctl status docker
#create docker group
newgrp docker
#add user to docker group
usermod -aG docker $username
#test the installation
docker version

#Kubernetes
#install tools
sudo apt-get install -y apt-transport-https
#install official gpg keys
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
#install kubectl

#Minikube
#install virtualbox for minikube
sudo apt-get install -y virtualbox virtualbox-ext-pack
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.4.0/minikube-linux-amd64
chmod +x minikube && sudo mv minikube /usr/local/bin/
sudo minikube start --vm-driver=none 
sudo chown -R $USER $HOME/.kube $HOME/.minikube

#Helm
sudo snap install helm --classic


## ZSH Suite - Install ##
sudo apt install -y zsh tmux jq