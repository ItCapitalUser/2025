
#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Site collection URL
$SiteURL="https://smartholdingcom.sharepoint.com/sites/portal"
 
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
#Initialize the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials
 
#Get all users of the site collection
$Users = $ctx.Web.SiteUsers
$ctx.Load($Users) 
$ctx.ExecuteQuery()
 
#Get User name and Email
$Users | ForEach-Object { Write-Host "$($_.Title) - $($_.Email)- $($_.IsSiteAdmin)"}