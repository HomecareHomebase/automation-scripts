#Requires -Version 5.0

[CmdletBinding(SupportsShouldProcess = $True)]
         
param 
(
  [Parameter(Mandatory = $True, Position = 0)]
  [ValidateNotNullOrEmpty()]
  [String]
  $svcAccount,

  [Parameter(Mandatory = $True, Position = 1)]
  [ValidateNotNullOrEmpty()]
  [String]
  $domain,

  [Parameter(Mandatory = $True, Position = 2)]
  [ValidateNotNullOrEmpty()]
  [String]
  $rootCertName
)

Start-Transcript -Path C:\Temp\setupWinRm.log

if (-not (Get-LocalGroupMember -Group "Administrators" -Member "*$($svcAccount)*" -ErrorAction SilentlyContinue)) {
  Add-LocalGroupMember -Group "Administrators" -Member "$svcAccount"
}

while ($count -le 30) {
  $existingCert = Get-ChildItem Cert:\LocalMachine\Root\ | Where-Object Subject -match $rootCertName

  if (-not $existingCert) {
    $count++
    Start-Sleep -Seconds 1
  } else {
    break
  }

  if ($count -eq 30) {
    throw "Failed to find root certificate $rootCertName"
  }
}

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
