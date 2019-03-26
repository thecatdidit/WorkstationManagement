<#

Sample script to copy logs from a directory to a centralized backup location
KIETH GARNER

Path can only contain folders under c:\

Future: Move to shell.application zip functions for Windows 7 - Not this release, calls are asynchronous

#>

[cmdletbinding()]
param(
    [string[]] $Path = @(

        "$env:Systemdrive\`$WINDOWS.~BT\Sources\Panther"
        "$env:Systemdrive\`$WINDOWS.~BT\Sources\Rollback"
        "$env:SystemRoot\Panther"
        "$env:SystemRoot\SysWOW64\PKG_LOGS"
        "$env:SystemRoot\CCM\Logs"
<#
        "$env:SystemRoot\System32\winevt\Logs"
        "${env:CommonProgramFiles(x86)}\CheckPoint\Endpoint Security\Endpoint Common\Logs\cpda.log"
        "$env:SystemRoot\Logs\CBS\CBS.log"
        "$env:SystemRoot\inf\setupapi.upgrade.log"
        "$env:SystemRoot\Logs\MoSetup\BlueBox.log"
#>
    ),

    [string] $TargetRoot = '\\cm01\logs$',
    [string] $LogID = "IPU\1709\$env:ComputerName",
    [string[]] $Exclude = @( '*.exe','*.wim','*.dll','*.ttf','*.mui' ),
    [switch] $recurse,
    [switch] $SkipZip
)


#region Prepare Target

write-verbose "Log Archive Tool  1.0.<Version>" 

write-verbose "Create Target $TargetRoot\$LogID"
new-item -itemtype Directory -Path $TargetRoot\$LogID -force -erroraction SilentlyContinue | out-null 

$TagFile = "$TargetRoot\$LogID\$($LogID.Replace('\','_'))"

#endregion

#region Create temporary Store

$TempPath = [System.IO.Path]::GetTempFileName()
remove-item $TempPath
new-item -type directory -path $TempPath -force | out-null

foreach ( $Item in $Path ) { 

    $TmpTarget = (join-path $TempPath ( split-path -NoQualifier $Item ))
    write-Verbose "COPy $Item to $TmpTarget"
    copy-item -path $Item -Destination $TmpTarget -Force -Recurse -exclude $Exclude -ErrorAction SilentlyContinue

}

Compress-Archive -path "$TempPath\*" -DestinationPath "$TargetRoot\$LogID\$($LogID.Replace('\','_'))-$([datetime]::now.Tostring('s').Replace(':','-')).zip" -Force
remove-item $tempPath -Recurse -Force

#endregion

#region Metadata

<#

FUTURE - need to create an index folder with right permissions

$LogID | add-content -encoding Ascii -Path "$TargetRoot\Index\$((get-date -f 'd').replace('/','-')).txt"

#>

#endregion
