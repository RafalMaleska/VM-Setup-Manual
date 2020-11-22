#!/bin/bash

### TO-DOs

# Place The SSH Private key (id_rsa.key) into ~/.ssh

### Variables

export username=rmanhart
export repository=https://github.com/RafalMaleska/VM-Setup


### FRESH INSTALL
#

# Get the Git
function git-clone-script {
  sudo apt install vim curl git -y 
  sudo mkdir ~/projects
  cd ~/projects/
  sudo git clone $repository
}

# Add User
function add-user {
  sudo usermod -aG sudo $username
  sudo mkdir -p /home/$username/.ssh
  sudo -i
  sudo echo "$username ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rmanhart
  sudo chmod 0440 /etc/sudoers.d/rmanhart
  su $username
}

# Add SSH
# Important: copy SSH Key into ~/.ssh before
function add-ssh {
  echo "ForwardAgent yes" >> ~/.ssh/config
  echo "IdentityFile ~/.ssh/id_rsa_key" >> ~/.ssh/config
  chmod 600 ~/.ssh/id_rsa.key
  ssh-add ~/.ssh/id_rsa.key
  ssh-keygen -y -f ~/.ssh/id_rsa.key > ~/.ssh/id_rsa.pub
  chmod 666 ~/.ssh/id_rsa.pub
  eval `ssh-agent -s`
}

# Customization
function customize {
  timedatectl set-timezone Europe/Berlin
  # Set Keyboard to German
  setxkbmap de 
  sudo apt install -y gnome-tweaks
  sudo sysctl vm.swappiness=10
  # Show More Startup Apps
  sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
}


### Instaling Software
#

# Install VirtualBox Addons
function virtualbox-addons {
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
}

# Install Basic Software
function basic-software {
  sudo apt install -y apt-transport-https \
    ca-certificates \
    software-properties-common \
    gnupg-agent \
    wget \
    tree \
    awscli \
    htop \
    guake \
    tmux \
    zsh \
    powerline \
    fonts-powerline \
    jq 
  export VERSION="4.0.0-alpha1"
  export BINARY="yq_linux_amd64"
  sudo wget https://github.com/mikefarah/yq/releases/download/$VERSION/$BINARY -O /usr/bin/yq &&\
  sudo chmod +x /usr/bin/yq
}

# VSCode
function vscode { 
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
  code --install-extension fabiospampinato.vscode-diff
  code --install-extension mads-hartmann.bash-ide-vscode
  code --install-extension rusnasonov.vscode-hugo
}

### Dev Tools
function dev-tools {
# Go
  sudo apt install golang
# Java
  sudo apt install default-jdk
  sudo snap install postman
# Git
  sudo apt-get install meld -y
# Hugo
  sudo apt-get install hugo -y
}

### Install Kubernetes Stuff
#

# Docker 
function docker-install {
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  #sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  sudo apt-get -y update
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io
  #check status
  #sudo systemctl status docker
  #create docker group
  sudo groupadd docker
  #add user to docker group
  sudo usermod -aG docker $username
  #test the installation
  docker version
}
# Kubernetes
function kubernetes {
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
  sudo apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"
  sudo apt-get -y install kubeadm kubelet kubectl
}
# Helm 
function helm {
  curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
  sudo apt-get install apt-transport-https --yes
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get -y update
  sudo apt-get -y install helm
  helm repo add gitlab https://charts.gitlab.io/
  helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
  helm repo add cern https://s3-website.cern.ch/cern-charts                   
  helm repo add prometheus-community	https://prometheus-community.github.io/helm-charts       
  helm repo add bitnami https://charts.bitnami.com/bitnami                       
  helm repo add jenkins-x http://chartmuseum.jenkins-x.io                          
  helm repo add stable https://charts.helm.sh/stable                            
  helm repo add gitlab https://charts.gitlab.io/                                
  helm repo add lighthouse http://chartmuseum.jenkins-x.io    
}
# Kind
function kind-install {
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
  sudo chmod +x ./kind
  sudo mv ./kind /usr/bin/kind
  kind create cluster --name kind
}
# Kustomize
function kustomize-install {
  curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases |\
  grep browser_download |\
  grep download/kustomize |\
  grep -m 1 linux |\
  cut -d '"' -f 4 |\
  xargs curl -O -L
  tar xzf ./kustomize_v*_linux_amd64.tar.gz
  sudo mv kustomize /usr/bin/kustomize
  chmod u+x /usr/bin/kustomize
  rm -rf kustomize_v*_linux_amd64.tar.gz
}
# ArgoCD
function argo-install {
  VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  sudo curl -sSL -o /usr/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
  sudo chmod +x /usr/bin/argocd
}
# Kubebuilder
function kubebuilder-install {
  os=$(go env GOOS)
  arch=$(go env GOARCH) 
  # download kubebuilder and extract it to tmp
  sudo curl -L https://go.kubebuilder.io/dl/2.3.1/${os}/${arch} | tar -xz -C /tmp/
  # move to a long-term location and put it on your path
  # (you'll need to set the KUBEBUILDER_ASSETS env var if you put it somewhere else)
  sudo mv /tmp/kubebuilder_2.3.1_${os}_${arch} /usr/local/kubebuilder
  sudo export PATH=$PATH:/usr/local/kubebuilder/bin
}


### Installing Cloud Stuff
#

function gcloud-sdk {
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt-get install apt-transport-https ca-certificates gnupg
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  sudo apt-get -y update && sudo apt-get install google-cloud-sdk -y
}

### Installing Non-Essentials
#

function multimedia {
  sudo apt install -y chromium-browser
  sudo apt install -y vlc
  sudo apt install -y ubuntu-restricted-extras 
  sudo apt install -y ubuntu-restricted-addons
  # instaling gnome extensions
  sudo apt install -y gnome-shell-extensions
  sudo apt-get install chrome-gnome-shell
  # needed for system monitor
  sudo apt install gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1
  # install theme
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/home:Horst3180.list"
  sudo apt-get update
  sudo apt-get install arc-theme
  # check this for theme instalation
  # https://www.youtube.com/watch?v=MNX7HgcWqHc
}



### Personalization
#

function load-personal-config {
  sudo dconf load / < ~/projects/VM-Setup/config/config.dconf
  sudo cp ~/projects/VM-Setup/config/.bashrc ~/.bashrc
  cp ~/projects/VM-Setup/config/.gitconfig ~/.gitconfig 
  cp -rf ~/projects/VM-Setup/config/.local ~/.local/
  sudo apt install preload
}

function pimp-the-shell {
  sudo rm -rf ~/.zsh-suite
  git clone git@github.com:RafalMaleska/shell.git ~/projects/VM-Setup/shell
  ~/projects/VM-Setup/shell/install.zsh
  zsh
}

### Get All Updates
function finish {
  sudo apt upgrade -y/
  sudo apt autoremove -y
}

### Manual Steps: 
#
# Add Keyboard Layout Icon on the TopBar

# Set Walpaper 

# Set bashrc history (maybe rich in passwords)
###

function main {
#  git-clone-script
#  add-user
#  add-ssh
#  customize
#  virtualbox-addons
#  basic-software
#  vscode
#  dev-tools 
#  docker-install
#  kubernetes
#  helm
#  kind-install
#  kustomize-install
#  argo-install
  kubebuilder-install
#  gcloud-sdk
#  multimedia
#  pimp-the-shell
#  load-personal-config
#  finish
}

main