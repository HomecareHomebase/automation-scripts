[cmdletbinding()]            
param (
    [string]$svcAccount,
    [string]$domain,
    [string]$domainUser,
    [string]$domainPass,
    [string]$oupath,
    [switch]$ChangeOU
)

Add-LocalGroupMember -Group "Administrators" -Member "$svcAccount"
Remove-LocalUser -Name "packer"

$IP = (Get-NetIPAddress -InterfaceAlias "Ethernet*" -AddressFamily IPv4).IPAddress
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

# Move to correct OU if needed (required for vmware provision)
if($ChangeOU) {
  $securePass = $pass | ConvertTo-SecureString -AsPlainText -Force
  $cred = New-Object System.Management.Automation.PSCredential($domainUser, $securePass)
  Add-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
  Get-ADComputer $env:COMPUTERNAME -Credential $cred | Move-ADObject -TargetPath $oupath -Credential $cred -Verbose
}
