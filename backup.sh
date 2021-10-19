#!/bin/bash
export CONFIG_DIR="~/projects/own/VM-Setup/config"

dconf dump / > ~/projects/own/VM-Setup/config/config.dconf 
sudo cp ~/.bashrc ~/projects/own/VM-Setup/config/.bashrc
cp ~/.gitconfig ~/projects/own/VM-Setup/config/.gitconfig 
cp -rf ~/.local/ ~/projects/own/VM-Setup/config
