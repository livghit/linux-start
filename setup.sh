#!/bin/bash

# Script for setting up fedora fresh install with necessary packages and configurations

# First we update the system and create a personal folder

# Update the system
sudo dnf update -y

# Create a personal folder in the home directory if it doesn't exist
if [ ! -d $HOME/personal ]; then
  mkdir -p $HOME/personal
fi

# Installing software from source in the personal folder
sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra
cd $HOME/personal
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
