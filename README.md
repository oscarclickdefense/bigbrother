# 🛰️ BigBrother - Centralized Logging with Rsyslog in Docker

This project provides an Ansible-based system to deploy a centralized logging service using `rsyslog` inside a Docker container. It includes provisioning playbooks, SSH-based inventory configuration, and `make` automation for rapid setup.

---

## 🚀 Quickstart

### ✅ Requirements (target machine)
- A running Debian-based machine (tested with Debian *testing/sid*)
- SSH access using a private key
- A user with **passwordless sudo**
- Docker is **not** required beforehand — it will be installed automatically

### ⚙️ Setup (control host)

1. Clone the repository:

    ```bash
    git clone https://your.git.repo/bigbrother.git
    cd bigbrother
    ```

2. Edit the inventory file:

    ```yaml
    # provision/ansible/inventory.yml

    all:
      hosts:
        bigbrother.clickdefense.in:
          ansible_host: 192.168.1.100
          ansible_user: ansible_user
          container_user: ansible_user
    ```

3. Run the deployment:

    ```bash
    make rsyslog_docker
    ```

---

## 🧱 Project Structure

```text
bigbrother/
├── Makefile
├── Vagrantfile
├── bin/
├── provision/
│   └── ansible/
│       ├── ansible.cfg
│       ├── bootstrap_ansible.yml
│       ├── inventory.yml
│       ├── rsyslog_docker_setup.yml
│       ├── rsyslog_client_setup.yml
│       └── templates/
│           ├── docker-compose.yml.j2
│           └── rsyslog.conf.j2
```

---

## 🔧 Make Targets

- `make bootstrap_ansible`: Create a user with sudo access and SSH config (optional).
- `make rsyslog_docker`: Deploy the `rsyslog` container on the target host.
- `make all`: Run both bootstrap and `rsyslog` provisioning.

