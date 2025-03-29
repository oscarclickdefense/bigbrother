# Path configuration
ANSIBLE_DIR := provision/ansible
INVENTORY := $(ANSIBLE_DIR)/inventory.yml
ANSIBLE_CFG := $(ANSIBLE_DIR)/ansible.cfg

export ANSIBLE_CONFIG := $(ANSIBLE_CFG)

.PHONY: all provision client clean known_hosts logs debug_server debug_client

# Deploy the rsyslog server container
provision:
	ansible-playbook $(ANSIBLE_DIR)/rsyslog_docker_setup.yml -i $(INVENTORY) $(V)

# Configure a client to forward logs
client:
	ansible-playbook $(ANSIBLE_DIR)/rsyslog_client_setup.yml -i $(INVENTORY) $(V)

# Debug version: server setup with verbosity
debug_server:
	ansible-playbook $(ANSIBLE_DIR)/rsyslog_docker_setup.yml -i $(INVENTORY) -vv

# Debug version: client setup with verbosity
debug_client:
	ansible-playbook $(ANSIBLE_DIR)/rsyslog_client_setup.yml -i $(INVENTORY) -vv

# Remove known_hosts fingerprint if SSH key has changed
known_hosts:
	@echo "🔐 Cleaning up known_hosts entry for 192.168.1.100..."
	@ssh-keygen -f ~/.ssh/known_hosts -R 192.168.1.100 || true

# Delete Ansible retry files
clean:
	@find $(ANSIBLE_DIR) -name "*.retry" -delete

# Follow logs from the rsyslog container
logs:
	sudo docker logs -f rsyslog

# Full setup
all: provision client

