Configuration BuildApplications
{
    $Sln = Get-ChildItem -Path "C:\vagrant\**\*.sln" -Recurse
    Import-DscResource -modulename PSDesiredStateConfiguration, xPSDesiredStateConfiguration

    node $env:COMPUTERNAME
    {
        File CreateWorkFolder
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\TMP"
        }

        File CopySolutionFiles
        {
            DependsOn = "[File]CreateWorkFolder"
            Ensure = "Present"
            Recurse = $true
            SourcePath = $Sln.Directory.FullName
            DestinationPath = "C:\TMP\"
        }

        File CreateDropFolder
        {
            DependsOn = "[File]CreateWorkFolder"
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\TMP\Drop"
        }

        xEnvironment SetMSBuildPath 
        {
            DependsOn = "[File]CreateDropFolder"
            Name = 'PATH'
            Ensure = 'Present'
            Path = $true
            Value = "${ENV:ProgramFiles(x86)}\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\amd64"
            Target = @('Process', 'Machine')
        }

        Script BuildWebPackage
        {
            DependsOn = "[File]CopySolutionFiles", "[File]CreateDropFolder", "[xEnvironment]SetMSBuildPath"
            GetScript = {
                SetScript = $SetScript
                TestScript = $TestScript
                GetScript = $GetScript
            }
            SetScript = {
                $WebDeployOutput = "C:\TMP\drop"
                $WebProjFile = Get-ChildItem -Path "C:\TMP\**\*.csproj" -Recurse
				$SlnFile = Get-ChildItem -Path "C:\TMP\**\*.sln" -Recurse
                $CmdForWebBuild = "& msbuild.exe $WebProjFile"
				$CmdForWebPublish = "& msbuild.exe -verbosity:d $WebProjFile /p:Configuration=Release /p:DeployOnBuild=true /p:Platform=AnyCPU /t:WebPublish /p:WebPublishMethod=FileSystem /p:DeleteExistingFiles=True /p:publishUrl=$($WebDeployOutput)"
				$CmdForNugetRestore = "& nuget.exe restore $SlnFile"
                
				Invoke-Expression $CmdForNugetRestore | Out-File c:\tmp\NugetRestore.log -Force
                
                Invoke-Expression $CmdForWebBuild | Out-File c:\tmp\WebBuild.log -Force
				
				Invoke-Expression $CmdForWebPublish | Out-File c:\tmp\WebPublish.log -Force
            }
            TestScript = {$false}
        }

        Script BuildDbPackage
        {
            DependsOn = "[Script]BuildWebPackage"
            GetScript = {
                SetScript = $SetScript
                TestScript = $TestScript
                GetScript = $GetScript
            }
            SetScript = {
                $DbProjFile = Get-ChildItem -Path "C:\TMP\**\*.sqlproj" -Recurse
                $DbProjFile | Out-File c:\tmp\dbproj.txt -Force
                $CmdForDb = "& msbuild.exe '$DbProjFile' /t:build"

                Invoke-Expression $CmdForDb | Out-File c:\tmp\DBBuild.log -Force
            }
            TestScript = {$false}
        }

        File MoveWebBinaries
        {
            
            DependsOn = "[Script]BuildWebPackage"
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            Force = $true
            SourcePath = "C:\TMP\Drop"
            DestinationPath = "C:\Vagrant\Release\WebPackage"
            Checksum = "CreatedDate"
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

BuildApplications -ConfigurationData $ConfigurationData -outputpath $args[0]

Start-DSCConfiguration -Path $args[0] -Force -Wait -Verbose

