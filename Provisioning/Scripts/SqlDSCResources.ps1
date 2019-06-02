# Install required DSC modules
Write-Host "Installing SQLServer DSC Modules"
Install-Module -Name SQLServerDSC -RequiredVersion 12.4.0.0 -Force
Import-Module -Name SQLServerDSC -Force
Install-Module -Name NetworkingDsc -RequiredVersion 6.0.0.0 -Force
Import-Module -Name NetworkingDsc -Force
Install-Module -Name xDatabase -RequiredVersion 1.9.0.0 -Force
Import-Module -Name xDatabase -Force
Install-Module -Name xPSDesiredStateConfiguration -RequiredVersion 8.6.0.0 -Force
Import-Module -Name xPSDesiredStateConfiguration -Force