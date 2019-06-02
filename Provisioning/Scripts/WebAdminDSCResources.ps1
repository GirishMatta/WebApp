# Install required DSC modules
Write-Host "Installing WebAdministration DSC Modules"
Install-Module -Name xWebAdministration -RequiredVersion 2.5.0.0 -Force
Import-Module -Name xWebAdministration -Force
Install-Module -Name xPSDesiredStateConfiguration -RequiredVersion 8.6.0.0 -Force
Import-Module -Name xPSDesiredStateConfiguration -Force
Install-Module -Name NetworkingDsc -RequiredVersion 7.1.0.0 -Force
Import-Module -Name NetworkingDsc -Force