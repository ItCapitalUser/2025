#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$SiteURL="https://smartholdingcom.sharepoint.com/sites/testEmptySite"

$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
    #Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials
 
    #Get the Top Navigation of the web
$QuickLaunch  = $Ctx.Web.Navigation.QuickLaunch
$Ctx.load($QuickLaunch )
$Ctx.ExecuteQuery()

$QuickLaunch | Select-Object -Property *

 #Populate New node data
    $NavigationNode = New-Object Microsoft.SharePoint.Client.NavigationNode #NavigationNodeCreationInformation
    $NavigationNode.Title = "SG Company1"
    #$NavigationNode.ListTemplateType="NoListTemplate"
  # $NavigationNode.Url = "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
    $NavigationNode.AsLastNode = $true

    $NavigationNode = New-Object Microsoft.SharePoint.Client.NavigationNodeCreationInformation
    $NavigationNode.Title = "SG Company1"
    $NavigationNode.ListTemplateType="NoListTemplate"
  # $NavigationNode.Url = "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
    $NavigationNode.AsLastNode = $true


 $Node = $Navigation | Where-Object {$_.Title -eq $Title}
        If($Node -eq $Null)
        {
            #Add Link to Root node of the Navigation
            $Ctx.Load($QuickLaunch.Add($NavigationNode))
            $Ctx.ExecuteQuery()
            Write-Host -f Green "New Navigation Node '$Title' Added to the Navigation Root!"
        }
        Else
        {
            Write-Host -f Yellow "Navigation Node '$Title' Already Exists in Root!"
        }


$QuickLaunch.GetType()