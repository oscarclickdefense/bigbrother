#!/usr/bin/env bash

######################################################################
# @description : Bootstrap script for setting up a new machine 
######################################################################

# Create service users 
sudo useradd -m -s /bin/bash ansible_user
sudo useradd -m -s /bin/bash container_user 

# Add ansible user to sudoers with no password
echo "ansible_user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible_user
echo "container_user  ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/container_user

# Create sshd snap-in file for sshd configuration
cat > /etc/ssh/sshd_config.d/00-ansible_user <<EOF
# Enable password authentication for ansible_user
PasswordAuthentication yes
EOF

# Ensure there are no PasswordAuthentication lines in the main sshd_config file
sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config || true
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config || true

# Restart sshd
systemctl restart sshd
