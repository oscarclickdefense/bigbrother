# BigBrother Logging Stack

This repository sets up a centralized logging environment using rsyslog in a Docker container. Provisioning is automated using Ansible and Vagrant.

---

## ✅ Requirements

- A machine (real or virtual) with:
  - SSH access to the target host.
  - A user with passwordless `sudo` privileges (typically `ansible_user`).
- `vagrant` and `virtualbox` installed (if using the included Vagrant setup).
- `ansible` installed via system packages (not pip).
- Docker and Docker Compose on the target host (installed automatically).

---

## 🚀 Quickstart

### 1. Spin up the target virtual machine

```bash
vagrant up
```

This will:

- Launch a Debian-based VM at `192.168.1.100`.
- Run the `bootstrap_ansible.yml` playbook to create `ansible_user` with SSH access and passwordless sudo.

### 2. Prepare SSH access (optional)

Ensure that the public key from your bastion or control machine (e.g. `~/.ssh/id_ed25519.pub`) is added to the `ansible_user`'s `authorized_keys`.

### 3. Configure inventory variables

Edit `provision/ansible/inventory.yml` and ensure these variables are defined:

```yaml
all:
  vars:
    ansible_user: ansible_user
    container_user: container_user
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    ansible_become_password: "{{ vault_become_pass | default(omit) }}"
```

You can override `container_user` to match an existing user on the host system.

---

## 🛠️ Running Playbooks

Use the `Makefile` to run each playbook individually or all at once:

### Run full provisioning

```bash
make all
```

This runs:

- `rsyslog_docker_setup.yml` → deploys the rsyslog container
- `rsyslog_client_setup.yml` → configures client logging to the rsyslog server

### Run individual playbooks

```bash
make rsyslog_docker
make rsyslog_client
make bootstrap
```

Use `make bootstrap_password` if you want to be prompted for the `ansible_user` sudo password.

---

## 📦 Generated Files

The Docker Compose and configuration files are rendered and stored in:

```
/home/<container_user>/services/rsyslog/
├── docker-compose.yml
└── rsyslog.conf
```

These are based on templates located in:

```
provision/ansible/templates/
```

---

## 🧪 Debugging

To test SSH manually:

```bash
ssh -i ~/.ssh/id_ed25519 ansible_user@192.168.1.100
```

To re-run provisioning without destroying the VM:

```bash
make rsyslog_docker
```

---

## 🔐 Notes

- `authorized_key` is provided by `ansible.posix`. It must be available via your system Ansible installation.
- The playbooks are designed to work without requiring Ansible collections installed via pip or galaxy.

---

