# PowerShell script to enable WinRM over HTTPS (port 5986) with a self-signed certificate

# Define the hostname for certificate and listener
$hostname = $env:COMPUTERNAME

# Create a self-signed certificate for WinRM
$cert = New-SelfSignedCertificate `
    -DnsName $hostname `
    -CertStoreLocation Cert:\LocalMachine\My `
    -KeyLength 2048 `
    -FriendlyName "WinRM HTTPS" `
    -NotAfter (Get-Date).AddYears(5)

# Extract thumbprint from the certificate
$thumbprint = $cert.Thumbprint

# Remove existing HTTPS listener (if exists)
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS -ErrorAction SilentlyContinue

# Create a new WinRM HTTPS listener using the certificate
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname='$hostname'; CertificateThumbprint='$thumbprint'}"

# Enable required firewall rule for WinRM over HTTPS
netsh advfirewall firewall add rule name="WinRM HTTPS" dir=in action=allow protocol=TCP localport=5986

# Confirm listener creation
winrm enumerate winrm/config/listener
