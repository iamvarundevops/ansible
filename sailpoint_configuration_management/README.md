# SailPoint Configuration Management with Ansible

This Ansible project automates the setup of Java, Tomcat, and the deployment of the IdentityIQ WAR file on Windows servers.

---

## 📁 Project Structure

```
sailpoint_configuration_management/
├── files/            # Supporting installation files (e.g., identityiq.war)
├── group_vars/       # Group-specific variables (e.g., dev.yml, encrypted with Ansible Vault)
├── inventory.ini     # Inventory file with host and group definitions
├── roles/            # Ansible roles for modular configuration
│   ├── java/         # Installs OpenJDK and JRE
│   ├── tomcat/       # Installs and configures Apache Tomcat
│   └── identityiq/   # Deploys identityiq.war to Tomcat
└── site.yaml         # Unified playbook to run all roles
```

---

## 🛠️ Prerequisites

- Ansible 2.10+ installed on your control node (e.g., EC2, local machine)
- Python and `pywinrm` installed if targeting Windows hosts
- Windows target machines with WinRM enabled
- SSH or WinRM access to managed hosts
- `identityiq.war` file placed under `files/` or provided in deployment role

---

## 🔐 Using Ansible Vault

Sensitive credentials like `ansible_password` should be stored in `group_vars/dev.yml` and encrypted:

```bash
ansible-vault create group_vars/dev.yml
```

Example contents:

```yaml
ansible_user: ec2-user
ansible_password: YourSecurePassword
```

Then run your playbook with:

```bash
ansible-playbook -i inventory.ini site.yaml --ask-vault-pass
```

---

## 🚀 Running the Playbook

To provision the full stack:

```bash
ansible-playbook -i inventory.ini site.yaml --ask-vault-pass
```

To run only one role:

```bash
ansible-playbook -i inventory.ini site.yaml --tags java
```

---

## 🧪 Testing Tomcat Deployment

After deployment, access Tomcat at:

```
http://<your-windows-host-ip>:8080
```

You can verify the IdentityIQ deployment at:

```
http://<your-windows-host-ip>:8080/identityiq/
```

---

## 🧼 Cleanup

Temporary files (e.g., ZIPs and extracted setup folders) are automatically cleaned up by the playbooks.

---

## 🧠 Tips

- Use `--check` for dry runs.
- Use `--limit` to target specific hosts.
- Secure your `.vault_pass.txt` and add it to `.gitignore`.

---

## 🔗 Maintainer

This project was generated and structured by Ansible automation for SailPoint deployment. Contributions welcome!
