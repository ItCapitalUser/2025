#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
    
#Config Parameters
$SiteURL= "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
$GroupOwnerName="FirstLine"

  $User=$web.EnsureUser($UserAccount)
 
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
  
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
    
    #Get the Group owner - Can be an another Group or User Account
    $GroupOwner = $Ctx.Web.SiteGroups.GetByName($GroupOwnerName)
     
    #Get All Groups of the Site
    $GroupsColl = $Ctx.web.SiteGroups
    $Ctx.Load($GroupsColl)
    $Ctx.ExecuteQuery()
 
    #Iterate through each Group - Exclude SharePoint Online System Groups!
    ForEach($Group in $GroupsColl | Where {$_.OwnerTitle -ne "System Account"})
    {
        Write-Host -f Yellow "Changing the Owner of the Group:", $Group.Title
 
        #sharepoint online powershell set group owner
        $Group.Owner = $GroupOwner
        $Group.Update()
        $Ctx.ExecuteQuery()
    }    
 
    Write-host -f Green "All Group Owners are Updated!"
}
Catch {
    write-host -f Red "Error changing Group Owners!" $_.Exception.Message
}