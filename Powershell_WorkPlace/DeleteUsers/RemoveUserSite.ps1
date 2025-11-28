#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Set parameter values
$SiteURL="https://Crescent.sharepoint.com/"
$UserID="peter@crescent.com"
 
Try {
    #Get Credentials to connect
    $Cred= Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
   
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
  
    #Get the web
    $Web=$Ctx.Web
    $Ctx.Load($Web)
    $Ctx.ExecuteQuery()
 
    #Frame Login Name
    $LoginName = "i:0#.f|membership|"+$UserID
 
    #Get the User to Delete
    $User = $Web.SiteUsers.GetByLoginName($LoginName)
    $Ctx.ExecuteQuery()
 
    If($User -ne $null)
    {
        #remove user from sharepoint online powershell
        $Ctx.Web.SiteUsers.RemoveByLoginName($LoginName)
        $Ctx.ExecuteQuery()
  
        Write-Host "User: '$UserID' has been Removed from the site Successfully!" -ForegroundColor Green  
    }
}
Catch {
    write-host -f Red "Error Removing User from Site!" $_.Exception.Message