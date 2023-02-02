#!/bin/bash

HOST_DIR_NAME=${PWD}

#Include functions
. $(dirname $0)/script/__functions.sh 

#------------------- Env vars ---------------------------------------------
#Number of Cpu for main VM
mainCpu=4
#GB of RAM for main VM
mainRam=4Gb
#GB of HDD for main VM
mainHddGb=10Gb
VM_INSTALL_PATH=/home/ubuntu/setup
VM_RDP_PATH=/home/$USERNAME
#--------------------------------------------------------------------------

#Prepare sh files
echo "sudo usermod -aG docker ${USERNAME}" > $(dirname $0)/script/__run_vm.sh
echo "echo \"/usr/bin/setxkbmap it\" | sudo tee -a $VM_RDP_PATH/.profile > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "echo \"/usr/bin/setxkbmap it\" | sudo tee -a $VM_RDP_PATH/.bashrc  > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "sudo mkdir -p $VM_RDP_PATH/.config/autostart" >> $(dirname $0)/script/__run_vm.sh
echo "sudo touch $VM_RDP_PATH/.config/autostart/keybit.desktop > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "echo \"[Desktop Entry]\" | sudo tee -a $VM_RDP_PATH/.config/autostart/keybit.desktop > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "echo \"Terminal=true\" | sudo tee -a $VM_RDP_PATH/.config/autostart/keybit.desktop > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "echo \"Name=keybit\" | sudo tee -a $VM_RDP_PATH/.config/autostart/keybit.desktop > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "echo \"Exec=/usr/bin/setxkbmap it\" | sudo tee -a $VM_RDP_PATH/.config/autostart/keybit.desktop > /dev/null" >> $(dirname $0)/script/__run_vm.sh
echo "sudo sh -c \"echo 'xfce4-session' > /home/$USERNAME/.xsession && chown $USERNAME:$USERNAME /home/$USERNAME/.xsession\"" >> $(dirname $0)/script/__run_vm.sh
msg_warn "Check prerequisites..."

#Check prerequisites
check_command_exists "multipass"

msg_warn "Creating vm"
multipass launch -m $mainRam -d $mainHddGb -c $mainCpu -n $VM_NAME lts

msg_info $VM_NAME" is up!"

msg_info "[Task 1]"
msg_warn "Mount host drive with installation scripts"
run_command_on_vm "$VM_NAME" "mkdir -p $VM_INSTALL_PATH/script"
multipass transfer --recursive ${HOST_DIR_NAME}/script $VM_NAME:$VM_INSTALL_PATH
#multipass transfer --recursive ${HOST_DIR_NAME}/config $VM_NAME:$VM_INSTALL_PATH
multipass transfer --recursive ${HOST_DIR_NAME}/install $VM_NAME:$VM_INSTALL_PATH
multipass transfer --recursive ${HOST_DIR_NAME}/images $VM_NAME:$VM_INSTALL_PATH
multipass transfer --recursive ${HOST_DIR_NAME}/projects $VM_NAME:$VM_INSTALL_PATH
multipass transfer --recursive ${HOST_DIR_NAME}/env $VM_NAME:$VM_INSTALL_PATH

msg_info "[Task 2]"
msg_warn "Configure $VM_NAME"

run_command_on_vm "$VM_NAME" "$VM_INSTALL_PATH/script/_configure.sh ${VM_INSTALL_PATH}"

multipass restart $VM_NAME

sleep 10

msg_warn "Installing add-ons"
run_command_on_vm "$VM_NAME" "$VM_INSTALL_PATH/script/_addons.sh ${VM_INSTALL_PATH}"

run_command_on_vm "$VM_NAME" "${VM_INSTALL_PATH}/script/_complete.sh ${VM_INSTALL_PATH}"

CMD_USERADD="sudo useradd -s /bin/bash -d $VM_RDP_PATH/ -m -G sudo -p `perl -e 'print crypt($ARGV[0], "password")' \`echo ${PASSWORD}\`` ${USERNAME}"
run_command_on_vm "$VM_NAME" "$CMD_USERADD"

run_command_on_vm "$VM_NAME" "sudo mkdir -p $VM_RDP_PATH/GNS3"
run_command_on_vm "$VM_NAME" "sudo mkdir -p $VM_RDP_PATH/.config/GNS3"
multipass mount "$HOST_DIR_NAME/volume" "$VM_NAME:$VM_RDP_PATH/GNS3"
multipass mount "$HOST_DIR_NAME/config" "$VM_NAME:$VM_RDP_PATH/.config/GNS3"

run_command_on_vm "$VM_NAME" "sudo cp $VM_INSTALL_PATH/script/__run_vm.sh $VM_RDP_PATH/__run_vm.sh"
run_command_on_vm "$VM_NAME" "sudo chmod a+x $VM_RDP_PATH/__run_vm.sh"
run_command_on_vm "$VM_NAME" "sudo $VM_RDP_PATH/__run_vm.sh"
sleep 2
run_command_on_vm "$VM_NAME" "sudo rm -rf $VM_RDP_PATH/__run_vm.sh"

#run_command_on_vm "$VM_NAME" "sudo mkdir -p $VM_RDP_PATH/.config/GNS3/2.2"
#run_command_on_vm "$VM_NAME" "sudo cp -R $VM_INSTALL_PATH/images $VM_RDP_PATH/GNS3"
#run_command_on_vm "$VM_NAME" "sudo cp -R $VM_INSTALL_PATH/projects $VM_RDP_PATH/GNS3"
run_command_on_vm "$VM_NAME" "sudo chown -R ${USERNAME}:${USERNAME} $VM_RDP_PATH/"

rm $(dirname $0)/script/__run_vm.sh

${HOST_DIR_NAME}/stop.sh

msg_info "[Task 3]"
msg_warn "Start $VM_NAME"
${HOST_DIR_NAME}/start.sh -v

msg_info "[Task 4]"
msg_warn "On task complete"

