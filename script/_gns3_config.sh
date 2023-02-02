#!/bin/bash
HOST_DIR_NAME=$1
. $HOST_DIR_NAME/script/__functions.sh

#sudo -H -u ${USERNAME} bash -c '/usr/bin/gns3server'
#sleep 10
sudo sed -i 's/host = localhost/host = 0.0.0.0/' /home/${USERNAME}/.config/GNS3/2.2/gns3_server.conf
sudo sed -i 's/auth = True/auth = False/' /home/${USERNAME}/.config/GNS3/2.2/gns3_server.conf

# sudo tee /home/$USERNAME/.config/GNS3/2.2/gns3_server.conf > /dev/null <<-EOF
# [Server]
# path = /usr/bin/gns3server
# ubridge_path = /usr/bin/ubridge
# host = 0.0.0.0
# port = 3080
# images_path = /home/$USERNAME/GNS3/images
# projects_path = /home/$USERNAME/GNS3/projects
# appliances_path = /home/$USERNAME/GNS3/appliances
# additional_images_paths = 
# symbols_path = /home/$USERNAME/GNS3/symbols
# configs_path = /home/$USERNAME/GNS3/configs
# report_errors = True
# auto_start = True
# allow_console_from_anywhere = False
# auth = False
# user = admin
# password = BVKkx63VRJxz3YgHe6GPAMyeuD30OZw8vyOzhQ7WHOd7LfQiJRVmXZ9Zpe6ZFc8n
# protocol = http
# console_start_port_range = 5000
# console_end_port_range = 10000
# udp_start_port_range = 10000
# udp_end_port_range = 20000
# EOF