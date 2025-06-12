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

## 🖥️ WinRM Setup Script for Windows Targets

To prepare a Windows machine for Ansible over WinRM (HTTP), use the included PowerShell script:

### 1. Download the script

[Download enable_winrm_http.ps1](./enable_winrm_http.ps1)

### 2. On the Windows machine:

- Open **PowerShell as Administrator**
- Run the following:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
cd C:\Path\To\Script
.\enable_winrm_http.ps1
```

This configures:
- WinRM service and HTTP listener (port 5985)
- Basic auth and unencrypted traffic (dev only)
- Local admin remote access
- Firewall rule for WinRM

⚠️ Ensure this is used only in **trusted/internal environments**.
For production, prefer HTTPS with a signed certificate.


---

## 🔐 WinRM over HTTPS (Recommended for Production)

To configure a Windows machine for secure WinRM access over HTTPS:

### 1. Download and run the PowerShell script

[Download enable_winrm_https.ps1](./enable_winrm_https.ps1)

### 2. On the Windows target:

- Open PowerShell as Administrator
- Run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
cd C:\Path\To\Script
.\enable_winrm_https.ps1
```

This script:
- Creates a self-signed certificate valid for 5 years
- Binds it to WinRM HTTPS listener on port 5986
- Opens the Windows firewall for port 5986

### 3. Update your Ansible inventory

In `inventory.ini`, update `[windows:vars]`:

```ini
ansible_connection=winrm
ansible_port=5986
ansible_winrm_transport=basic
ansible_winrm_server_cert_validation=ignore
```

> ⚠️ For production, consider using a certificate issued by a trusted internal or public CA.
