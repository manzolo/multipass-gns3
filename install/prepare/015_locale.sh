#!/bin/bash
echo "Install locale..."
L='it' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard
sudo sh -c "echo \"Europe/Rome\" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
	echo 'LANG=\"it_IT.UTF-8\"'>/etc/default/locale && \
	loadkeys it && \
	apt install -yqq locales && \
    locale-gen it_IT.UTF-8 && \
	dpkg-reconfigure --frontend=noninteractive locales &&  \
	update-locale LANG=it_IT.UTF-8 && \
    dpkg-reconfigure -f noninteractive keyboard-configuration && \
    dpkg-reconfigure -f noninteractive console-setup"