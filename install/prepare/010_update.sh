#!/bin/bash
echo "Remove needrestart..."
sudo apt -y remove needrestart
echo "Upgrade packages..."
DEBIAN_FRONTEND=noninteractive sudo apt -qqy update 
DEBIAN_FRONTEND=noninteractive sudo apt -qqy upgrade
