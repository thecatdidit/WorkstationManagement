<# 
.SYNOPSIS 
Remove AppX Apps from Windows 10 During OSD Task Sequence
.DESCRIPTION 
Uses PackageID to Identify Content Type and Other Descriptive Information About Content, Requires  - Created by Mark Godfrey @Geodesicz
.PARAMETER Apps
Comma separated values for the Display Names of the AppX Provisioned Packages you want removed. Each value should be in a separate set of quotes.
.EXAMPLE 
.\Remove-Win10AppsTS.ps1 -Apps "Microsoft.XboxApp","Microsoft.ZuneVideo","Microsoft.SkypeApp"
.LINK
http://www.tekuits.com 
#> 
<#
[CmdletBinding()]
Param(
    [Parameter(HelpMessage="Apps")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Apps
)
#>
$Apps = "Microsoft.MicrosoftSolitaireCollection","Microsoft.Office.OneNote","Microsoft.OneConnect","Microsoft.People","Microsoft.SkypeApp","Microsoft.Wallet","Microsoft.WindowsCommunicationsApps","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechtoTextOverlay","Microsoft.ZuneVideo","Microsoft.Getstarted","Microsoft.GetHelp","Microsoft.Advertising.Xaml","Microsoft.XboxGameCallableUI"

ForEach($App in $Apps){
      Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq "$app" -Verbose -ErrorAction SilentlyContinue | Remove-AppxProvisionedPackage -Online -Verbose

}
$Capabilities = "App.Support.ContactSupport~~~~0.0.1.0","App.Support.QuickAssist~~~~0.0.1.0"
$Capabilities | ForEach{Remove-WindowsCapability -Online -Name $PSItem}
