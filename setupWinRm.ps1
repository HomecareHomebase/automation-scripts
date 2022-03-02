[cmdletbinding()]            
param (
    [string]$svcAccount,
    [string]$domain
)

Start-Transcript -Path C:\Temp\setupWinRm.log

Add-LocalGroupMember -Group "Administrators" -Member "$svcAccount"

$IP = (Get-NetIPAddress -InterfaceAlias "Ethernet0*" -AddressFamily IPv4).IPAddress
$ShortName = "$($Env:COMPUTERNAME)"
$FQDN = "$($Env:COMPUTERNAME).$(($domain).ToLower())"
$Cert = Get-Certificate -Template WebServerExportPrivate -DnsName $IP,$ShortName,$FQDN -SubjectName "CN=$($FQDN)" -CertStoreLocation 'Cert:\LocalMachine\My\'
$CertificateThumbprint = $Cert.Certificate.Thumbprint

$listener = @{
   ResourceURI = "winrm/config/Listener"
   SelectorSet = @{Address="*";Transport="HTTPS"}
   ValueSet = @{CertificateThumbprint=$CertificateThumbprint}
 }
 
 Set-WSManInstance @listener

 Stop-Transcript
