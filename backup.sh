#!/bin/bash
export CONFIG_DIR="~/projects/VM-Setup/config"

dconf dump / > ${CONFIG_DIR}/config.dconf 
sudo cp ~/.bashrc ${CONFIG_DIR}/.bashrc