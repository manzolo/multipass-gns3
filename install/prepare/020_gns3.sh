#!/bin/bash
echo "Install GNS3 packages..."
sudo add-apt-repository --yes ppa:gns3/ppa
DEBIAN_FRONTEND=noninteractive sudo apt -qqy update
DEBIAN_FRONTEND=noninteractive sudo apt -qqy install gns3-gui gns3-server

