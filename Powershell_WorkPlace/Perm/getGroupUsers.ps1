#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Set Variables for Site URL
$SiteURL= "https://smartholdingcom.sharepoint.com/sites/SUF151"
 
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
 
    #Get all Groups
    $Groups=$Ctx.Web.SiteGroups
    $Ctx.Load($Groups)
    $Ctx.ExecuteQuery()
 
    #Get Each member from the Group
    Foreach($Group in $Groups)
    {
        Write-Host "--- $($Group.Title) --- "
        

        #Getting the members
        $SiteUsers=$Group.Users
        $Ctx.Load($SiteUsers)
        $Ctx.ExecuteQuery()
        <#Foreach($User in $SiteUsers)
        {
            Write-Host "$($User.Title), $($User.Email), $($User.LoginName)"
        }#>
    }
}
Catch {
    write-host -f Red "Error getting groups and users!" $_.Exception.Message
}