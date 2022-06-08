[CmdletBinding(SupportsShouldProcess = $True)]
param 
(
  [Parameter(Mandatory = $True)]
  [ValidateNotNullOrEmpty()]
  [String]
  $HostPoolName,

  [Parameter(Mandatory = $True)]
  [ValidateNotNullOrEmpty()]
  [String]
  $RegistrationInfoToken
)

$url = 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration.zip'
$zipPath = ".\Configuration.zip"
$extractPath = ".\Configuration\"

$ScriptPath = [system.io.path]::GetDirectoryName($PSCommandPath)

Write-Host "Script Path: $ScriptPath"

Write-Host "Downloading $url to $zipPath"
Invoke-WebRequest $url -OutFile $zipPath

Write-Host "Expanding $zipPath to $extractPath"
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

Write-Host "Executing $extractPath\Script-AddRdshServer.ps1"

& ".\$($extractPath)\Script-AddRdshServer.ps1" -HostPoolName $HostPoolName -RegistrationInfoToken $RegistrationInfoToken