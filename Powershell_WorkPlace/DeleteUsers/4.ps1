#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Site collection URL
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/SBS_CAS_359"

 
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
#Initialize the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials
 
#Get all users of the site collection
$Users = $Ctx.Web.SiteUsers
$Ctx.Load($Users) 
$Ctx.ExecuteQuery()

$Lists = $Ctx.Web.Lists
$Ctx.Load($Lists) 
$Ctx.ExecuteQuery()
 
#Get User name and Email
$Users | ForEach-Object { Write-Host "$($_.Title) - $($_.Email) - $($_.PrincipalType) - $($_.IsSiteAdmin)"}

$select = $Users | Where-Object {($_.PrincipalType -eq "User") -and ($_.IsSiteAdmin -ne "True") -and ($_.Email)}
$select | ForEach-Object { Write-Host "$($_.Title) - $($_.Email) - $($_.PrincipalType) - $($_.IsSiteAdmin)"}


foreach($Empl in $select)
{

   $UserAccount =  Get-AzureADUser -Filter "userPrincipalName eq '$($Empl.UserPrincipalName)'" -ErrorAction SilentlyContinue

   If($UserAccount -eq $null) 
   { 
        Write-Host "Delete "+ $Empl.UserPrincipalName
        $Ctx.Web.SiteUsers.RemoveByLoginName($Empl.UserPrincipalName)
        $Ctx.ExecuteQuery()
  
   } 

}