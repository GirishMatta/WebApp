Configuration InstallConfigureSQLServer
{
    param
    (
        [Parameter()]
        $SAUser,
        [ValidateNotNullOrEmpty()] 
        $SAPass,
        [Parameter()]
        $DacPacPath,
        [Parameter()]
        $DBName

    )

    $SAPassSecured = ConvertTo-SecureString -String $SAPass -AsPlainText -Force
    $SAAccount = New-Object System.Management.Automation.PSCredential($SAUser,$SAPassSecured)

    Import-DscResource -ModuleName SQLServerDSC, xDatabase, xPSDesiredStateConfiguration, PSDesiredStateConfiguration, NetworkingDsc

    node $env:COMPUTERNAME
    {
        WindowsFeature InstallDotNet45
        {
            Name = "Net-Framework-45-Core"
            Ensure = "Present"
        }

        File CreateSQLMediFolder
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Media\SQL2017Express"
        }

        xRemoteFile DownloadSQLPackage
        {
            DependsOn = "[File]CreateSQLMediFolder"
            Uri = "https://azmedia.blob.core.windows.net/gmatta-azmedia/SQL2017Express.zip"
            DestinationPath = "C:\Media\SQL2017Express\SQL2017Express.zip"
        }

        Archive UnzipSQLPackage
        {
            DependsOn = "[xRemoteFile]DownloadSQLPackage"
            Ensure = "Present"
            Path = "C:\Media\SQL2017Express\SQL2017Express.zip"
            Destination = "C:\Media\SQL2017Express\"
        }

        SQLSetup InstallDefaultInstance
        {
            DependsOn = "[WindowsFeature]InstallDotNet45", "[Archive]UnzipSQLPackage"
            InstanceName = "MSSQLSERVER"
            Features = "SQLENGINE"
            SourcePath = "C:\Media\SQL2017Express\"
            # SourcePath = "C:\VAGRANT\Media\SQL2017Express\"
            SQLSysAdminAccounts = @('Administrators')
            SecurityMode = "SQL"
            SAPwd = $SAAccount
            BrowserSvcStartupType = "Automatic"
            SqlSvcStartupType = "Automatic"
        }

        SqlServerNetwork EnableTCP1433
        {
            DependsOn = "[SqlSetup]InstallDefaultInstance"
            ServerName = $env:COMPUTERNAME
            InstanceName = "MSSQLSERVER"
            IsEnabled = $true
            TcpDynamicPort = $false
            TcpPort = 1433
            RestartService = $true
            ProtocolName = "Tcp"
        }

        Firewall CreateSQLFWRule
        {
            DependsOn = "[SqlServerNetwork]EnableTCP1433"
            Name = "Inbound SQL FW Rule"
            DisplayName = "Inbound SQL FW Rule"
            Group = "SQL Firewall Rule Group"
            Ensure = "Present"
            Enabled = "True"
            Profile = ('Public')
            Direction = "Inbound"
            LocalPort = "1433"
            Protocol = "Tcp"
        }

        SqlDatabase CreateDB
        {
            DependsOn = "[SqlSetup]InstallDefaultInstance", "[SqlServerNetwork]EnableTCP1433"
            Ensure = "Present"
            ServerName = $env:COMPUTERNAME
            InstanceName = "MSSQLSERVER"
            Name = $DBName
        }

        SqlServerLogin CreateSAAccount
        {
            DependsOn = "[SqlDatabase]CreateDB"
            Ensure = "Present"
            ServerName = $env:COMPUTERNAME
            InstanceName = "MSSQLSERVER"
            LoginType = "SqlLogin"
            LoginCredential = $SAAccount
            Name = $SAAccount.UserName
            LoginPasswordPolicyEnforced = $false
            LoginMustChangePassword = $false
            LoginPasswordExpirationEnabled = $false
            Disabled = $false
        }

        SqlDatabaseOwner AssignSAAccountOwnership
        {
            DependsOn = "[SqlServerLogin]CreateSAAccount", "[SqlDatabase]CreateDB"
            Database = $DBName
            Name = $SAAccount.UserName
            ServerName = $env:COMPUTERNAME
            InstanceName = "MSSQLSERVER"
        }

        xRemoteFile DownloadDacFramework
        {
            Uri = "https://download.microsoft.com/download/9/5/A/95A27630-B4AE-4F67-B2FA-68165F047CC8/EN/x64/DacFramework.msi"
            DestinationPath = "C:\Media\DacFramework.msi"
        }

        package InstallDacFramework
        {
            DependsOn = "[xRemoteFile]DownloadDacFramework"
            Ensure = "Present"
            Name = "Microsoft SQL Server Data-Tier Application Framework (x64)"
            path = "C:\Media\DacFramework.msi"
            ProductId = "DDFFAE0D-0ACA-43ED-B9F3-ADDFB5B07FD9"
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

InstallConfigureSQLServer -ConfigurationData $ConfigurationData -outputpath $Args[0] -SAUser $Args[1] -SAPass $Args[2] -DBName $Args[3]

Start-DSCConfiguration -Path $Args[0] -Force -Wait -Verbose