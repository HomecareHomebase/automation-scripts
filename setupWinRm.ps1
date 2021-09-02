$Cert = Get-Certificate -Template WebServerExportPrivate -DnsName "$($Env:COMPUTERNAME).$(($Env:USERDNSDOMAIN).ToLower())" -CertStoreLocation 'Cert:\LocalMachine\My\'
$CertificateThumbprint = $Cert.Certificate.Thumbprint

$listener = @{
   ResourceURI = "winrm/config/Listener"
   SelectorSet = @{Address="*";Transport="HTTPS"}
   ValueSet = @{CertificateThumbprint=$CertificateThumbprint}
 }
 
 Set-WSManInstance @listener