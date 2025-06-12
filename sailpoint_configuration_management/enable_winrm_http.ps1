
# PowerShell script to enable WinRM over HTTP with Basic Auth for Ansible connections

# Enable WinRM service and set up basic configuration
winrm quickconfig -force

# Allow unencrypted communication (only for dev/test environments)
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Enable Basic Authentication
winrm set winrm/config/service/auth '@{Basic="true"}'

# Allow local administrator account to access via WinRM
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
  -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWord -Force

# Restart WinRM service to apply all changes
Restart-Service WinRM

# (Optional) Open firewall port 5985 for WinRM HTTP
#netsh advfirewall firewall add rule name="WinRM HTTP" dir=in action=allow protocol=TCP localport=5985
