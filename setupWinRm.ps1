[cmdletbinding()]            
param (
    [string]$svcAccount
)

Add-LocalGroupMember -Group "Administrators" -Member "$svcAccount"

$IP = (Get-NetIPAddress -InterfaceAlias "Ethernet*" -AddressFamily IPv4).IPAddress
$ShortName = "$($Env:COMPUTERNAME)"
$FQDN = "$($Env:COMPUTERNAME).$(($Env:USERDNSDOMAIN).ToLower())"
$Cert = Get-Certificate -Template WebServerExportPrivate -DnsName $IP,$ShortName -SubjectName "CN=$($FQDN)" -CertStoreLocation 'Cert:\LocalMachine\My\'
$CertificateThumbprint = $Cert.Certificate.Thumbprint

$listener = @{
   ResourceURI = "winrm/config/Listener"
   SelectorSet = @{Address="*";Transport="HTTPS"}
   ValueSet = @{CertificateThumbprint=$CertificateThumbprint}
 }
 
 Set-WSManInstance @listener
