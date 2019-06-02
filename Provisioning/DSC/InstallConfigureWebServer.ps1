Configuration InstallConfigureWebServer
{
    param
    (
        [Parameter()]
        $SAUser,
        [parameter()] 
        $SAPass,
        [Parameter()]
        $DBServerName,
        [Parameter()]
        $DBName
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration, PSDesiredStateConfiguration, NetworkingDsc, xWebAdministration

    node $env:COMPUTERNAME
    {
        WindowsFeature InstallDotNet45
        {
            Name = "Net-Framework-45-Core"
            Ensure = "Present"
        }

        WindowsFeature InstallAspDotNet45
        {
            Name = "web-asp-net45"
            Ensure = "Present"
        }

        WindowsFeature InstallIIS
        {
            DependsOn = "[WindowsFeature]InstallDotNet45"
            Name = "Web-Server"
            Ensure = "Present"
        }

        WindowsFeature InstallAppInit
        {
            DependsOn = "[WindowsFeature]InstallIIS"
            Name = "Web-AppInit"
            IncludeAllSubFeature = $true
            Ensure = "Present"
        }

        WindowsFeature InstallHttpCommFeatures
        {
            DependsOn = "[WindowsFeature]InstallIIS"
            Name = "Web-Common-Http"
            IncludeAllSubFeature = $true
            Ensure = "Present"
        }

        xWebsite StopDefaultSite
        {
            DependsOn = "[WindowsFeature]InstallHttpCommFeatures"
            Ensure = "Present"
            Name = "Default Web Site"
            PhysicalPath = "C:\inetpub\wwwroot"
            State = "Stopped"
            BindingInfo = MSFT_xWebBindingInformation
            {
                Protocol = "HTTP"
                Port = 8080
            }
        }

        File CopyWebAppFiles
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "C:\Vagrant\Release\WebPackage"
            DestinationPath = "C:\inetpub\wwwroot\WebApp"
        }

        Script UpdateWebConfig 
        {
            dependson = "[File]CopyWebAppFiles"
            GetScript = {
                SetScript = $SetScript
                TestScript = $TestScript
                GetScript = $GetScript
            } 
            SetScript =
            {    
                $WebConfigPath = "C:\inetpub\wwwroot\WebApp" + "\" + "web.config"
                $xml = [xml](Get-Content $WebConfigPath)
                $ReplaceString = "Server=" + $using:DBServerName + ";user id=" + $using:SAUser + ";password=" + $using:SAPass + ";database=" + $using:DBName + ";"
                $xml.configuration.connectionStrings.add.connectionString = $ReplaceString
                $xml.Save($webconfigpath)
            }
            
            TestScript = {$false}
        }

        xWebSite CreateWebSite
        {
            DependsOn = "[Script]UpdateWebConfig". "[WindowsFeature]InstallHttpCommFeatures"
            Ensure = "Present"
            Name = "WebApp"
            State = "Started"
            PhysicalPath = "C:\inetpub\wwwroot\WebApp"
            BindingInfo = MSFT_xWebBindingInformation
            {
                Protocol = "HTTP"
                Port = 80
            }
        }

        Firewall CreateInboundWebFWRule
        {
            DependsOn = "[xWebSite]CreateWebSite"
            Ensure = "Present"
            Name = "http Inbound"
            DisplayName = "http Inbound"
            Group = "http"
            Enabled = "True"
            Profile = ('Public')
            Direction = "Inbound"
            LocalPort = 80
            Protocol = "TCP"
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = $env:COMPUTERNAME
            PSDscAllowPlainTextPassword = $true
        }
    )
}

InstallConfigureWebServer -ConfigurationData $ConfigurationData -outputpath $Args[0] -SAUser $Args[1] -SAPass $Args[2] -DBServerName $Args[3] -DBName $Args[4]

Start-DSCConfiguration -Path $Args[0] -Force -Wait -Verbose