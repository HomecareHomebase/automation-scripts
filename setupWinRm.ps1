$IP = (Get-NetIPAddress -InterfaceAlias "Ethernet*" -AddressFamily IPv4).IPAddress
$Cert = Get-Certificate -Template WebServerExportPrivate -DnsName $IP,"$($Env:COMPUTERNAME).$(($Env:USERDNSDOMAIN).ToLower())" -SubjectName "CN=$($Env:COMPUTERNAME).$(($Env:USERDNSDOMAIN).ToLower())" -CertStoreLocation 'Cert:\LocalMachine\My\'
$CertificateThumbprint = $Cert.Certificate.Thumbprint

$listener = @{
   ResourceURI = "winrm/config/Listener"
   SelectorSet = @{Address="*";Transport="HTTPS"}
   ValueSet = @{CertificateThumbprint=$CertificateThumbprint}
 }
 
 Set-WSManInstance @listener
