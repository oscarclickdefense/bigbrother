# Variables comunes
ANSIBLE_DIR := provision/ansible
INVENTORY := $(ANSIBLE_DIR)/inventory.yml
KEY_PATH := $(HOME)/.ssh/id_ed25519  
ANSIBLE_CONFIG := $(ANSIBLE_DIR)/ansible.cfg
SSH_ARGS := --private-key $(KEY_PATH) --ssh-common-args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Playbooks
BOOTSTRAP := $(ANSIBLE_DIR)/bootstrap_ansible.yml
RSYSLOG_DOCKER := $(ANSIBLE_DIR)/rsyslog_docker_setup.yml
RSYSLOG_CLIENT := $(ANSIBLE_DIR)/rsyslog_client_setup.yml

export ANSIBLE_CONFIG

.PHONY: all
all: rsyslog_docker rsyslog_client

.PHONY: bootstrap
bootstrap:
	ansible-playbook $(BOOTSTRAP) -i $(INVENTORY)

.PHONY: rsyslog_docker
rsyslog_docker:
	ansible-playbook $(RSYSLOG_DOCKER) -i $(INVENTORY) $(SSH_ARGS) -vvv

.PHONY: rsyslog_client
rsyslog_client:
	ansible-playbook $(RSYSLOG_CLIENT) -i $(INVENTORY) $(SSH_ARGS) -vvv

.PHONY: ask_pass
ask_pass:
	ansible-playbook $(RSYSLOG_DOCKER) -i $(INVENTORY) --ask-pass --ask-become-pass

.PHONY: ask_all
ask_all:
	ansible-playbook $(RSYSLOG_DOCKER) -i $(INVENTORY) --ask-pass --ask-become-pass
	ansible-playbook $(RSYSLOG_CLIENT) -i $(INVENTORY) --ask-pass --ask-become-pass

.PHONY: debug
debug:
	@echo "ANSIBLE_CONFIG = $(ANSIBLE_CONFIG)"
	@echo "Using key at: $(KEY_PATH)"
	@echo "Inventory: $(INVENTORY)"

