
	
#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Set Variables
$SiteURL = "https://crescent.sharepoint.com/sites/marketing"
$PermissionLevelName = "AddUsers2"
 
#Get Credentials to connect
$Cred = Get-Credential
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
    #Get the role definition by name
    $RoleDefinition = $Ctx.web.RoleDefinitions.GetByName($PermissionLevelName)
    $Ctx.Load($RoleDefinition)
    $Ctx.ExecuteQuery()
     
    #Add "Delete Items" Permission to the Permission Level
    $BasePermissions = New-Object Microsoft.SharePoint.Client.BasePermissions
    $BasePermissions = $RoleDefinition.BasePermissions
    $BasePermissions.Set([Microsoft.SharePoint.Client.PermissionKind]::DeleteListItems)
    $RoleDefinition.BasePermissions =  $BasePermissions
    $RoleDefinition.Update()
    $Ctx.ExecuteQuery()   
     
    Write-host -f Green "Permission Level has been Updated!"
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}