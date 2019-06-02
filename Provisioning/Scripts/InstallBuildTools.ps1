# Install Nuget Commandline tool
Write-Host "Installing Nuget Commandline tool"
choco install Nuget.Commandline -y

# Install VisualStudio Build Tools
Write-Host "Installing VisualStudio 2017 Build Tools with Web and Data workload using Chocolatey"
choco install visualstudio2017buildtools -y --package-parameters "--add Microsoft.VisualStudio.Workload.DataBuildTools --add Microsoft.VisualStudio.Workload.WebBuildTools --includeRecommended --locale en-US"