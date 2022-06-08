#{
#    "commandToExecute":"powershell -ExecutionPolicy Unrestricted -Command { Expand-Archive -Path Configuration.zip -DestinationPath .\\Configuration\\ -Force; .\\Configuration\\Script-AddRdshServer.ps1 -HostPoolName \"${module.primary_avd_r2_host_pool.name}\" -RegistrationInfoToken \"${module.primary_avd_r2_host_pool.token}\" }",
#    "fileUris":[
#       "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration.zip"
#    ]
# }

# [CmdletBinding(SupportsShouldProcess = $True)]
         
# param 
# (
#   [Parameter(Mandatory = $True)]
#   [ValidateNotNullOrEmpty()]
#   [String]
#   $HostPoolName,

#   [Parameter(Mandatory = $True)]
#   [ValidateNotNullOrEmpty()]
#   [String]
#   $RegistrationInfoToken
# )

$HostPoolName = ""
$RegistrationInfoToken = ""

$url = 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration.zip'
$zipPath = ".\Configuration.zip"
$extractPath = ".\Configuration\"

$ScriptPath = [system.io.path]::GetDirectoryName($PSCommandPath)

Write-Host "Script Path: $ScriptPath"

Write-Host "Downloading $url to $zipPath"
# Invoke-WebRequest $url -OutFile $zipPath

Write-Host "Expanding $zipPath to $extractPath"
# Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

Write-Host "Executing $extractPath\Script-AddRdshServer.ps1"

.\$($extractPath)\Script-AddRdshServer.ps1 -HostPoolName $HostPoolName -RegistrationInfoToken $RegistrationInfoToken