#!/bin/bash
export CONFIG_DIR="~/projects/VM-Setup/config"

dconf dump / > ~/projects/VM-Setup/config/config.dconf 
sudo cp ~/.bashrc ~/projects/VM-Setup/config/.bashrc
cp ~/.gitconfig ~/projects/VM-Setup/config/.gitconfig 
cp -rf ~/.local/ ~/projects/VM-Setup/config
