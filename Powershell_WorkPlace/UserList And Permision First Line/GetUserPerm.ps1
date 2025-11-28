Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Parameters
$SiteUrl = "https://salaudeen.sharepoint.com/sites/Retail"
$AdminAccount = "Admin@salaudeen.com"
$UserName = "testsh1@smart-holding.com"
 
Try {
    # Connect to SharePoint Online
    $password = Read-Host -Prompt "Enter password" -AsSecureString
    $credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($AdminAccount, $password)
 
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
    #Get the site
    $web = $Ctx.Web
    $Ctx.Load($web)
    $Ctx.ExecuteQuery()
 
    #get the User
    $User=$web.EnsureUser($UserName)
    $Ctx.Load($User)
    $Ctx.ExecuteQuery()
 
    # Retrieve the user permissions on the site
    $Permissions = $web.GetUserEffectivePermissions($user.LoginName)
    $Ctx.ExecuteQuery()
 
    #get all base permissions granted to the user
    $PermissionKindObj=New-Object Microsoft.SharePoint.Client.PermissionKind
    $PermissionKindType=$PermissionKindObj.getType()
 
    ForEach ($PermissionKind in [System.Enum]::GetValues($PermissionKindType))
    {
        $hasPermisssion = $permissions.Value.Has($PermissionKind)
        if ($hasPermisssion)
        {
            Write-host $permissionKind.ToString()                    
        }
    }
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}