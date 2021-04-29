# VM-Setup-Manual

## Before

 - place The SSH Private key (id_rsa.key) into ~/.ssh 

## Install 


```
  repository=https://github.com/RafalMaleska/VM-Setup
  sudo apt install vim curl git -y 
  sudo mkdir ~/projects
  cd ~/projects/
  sudo git clone $repository
  sudo ~/install/VM-Setup/install.sh
```

## Manual Steps

- Add Keyboard Layout Icon on the TopBar

- Set Walpaper from /pics

## Backup 

```
sudo ~/install/VM-Setup/backup.sh
```