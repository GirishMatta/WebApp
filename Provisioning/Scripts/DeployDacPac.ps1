$ErrorActionPreference = "Stop"

$DacPath = $args[0]
$TargetDatabaseName = $args[1]
$SourceFile = Get-ChildItem $DacPath -Recurse
$SourceFile

trap {
    Write-Error $_
    Exit 1
}

 $switches = @('/Action:Publish'
             ,"/SourceFile:`"$SourceFile`""
             ,"/TargetServerName:$env:COMPUTERNAME"
             ,"/TargetDatabaseName:$TargetDatabaseName"
             )            
    
    try {
        & "C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" $switches
        Write-Host "DacPack file "$SourceFile.name" has been published to the database $TargetDatabaseName"        

    }
    catch {
        Write-Host $_ ;
    }