#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
##Variables for Processing
$SiteUrl = "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
$TargetPermissionLevelName ="TestPow"

$TargetPermissionLevelName ="TestPow1"

$SourcePermissionLevelName ="Full Control"
 
Try {
    #Get Credentials to connect
    $Cred = Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)
    $Ctx.Credentials = $Credentials
    $Web = $Ctx.Web
 
    #Get the source permission level
    $RoleDefinitions = $Web.RoleDefinitions
    $Ctx.Load($RoleDefinitions)  
    $SourceRoleDefinition = $RoleDefinitions.GetByName("Full Control")
    $Ctx.Load($SourceRoleDefinition)
    $Ctx.ExecuteQuery()
 
    #get base permissions from the source and remove "Delete"
    $TargetBasePermissions = $SourceRoleDefinition.BasePermissions
    $TargetBasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::AddListItems)
    $TargetBasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::EditListItems)
    $TargetBasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::DeleteListItems)
    $TargetBasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ApproveItems)

 
    #check if the given permission level exists already!
    $TargetPermissionLevel = $RoleDefinitions | Where-Object { $_.Name -eq $TargetPermissionLevelName } 
    if($TargetPermissionLevel -eq $null)
    {
        #Create new permission level from source permission level
        $PermissionCreationInfo = New-Object Microsoft.SharePoint.Client.RoleDefinitionCreationInformation
        $PermissionCreationInfo.Name = $TargetPermissionLevelName
        $PermissionCreationInfo.Description = $TargetPermissionLevelName
        $PermissionCreationInfo.BasePermissions = $TargetBasePermissions
 
        #Add the role definitin to the site
        $TargetPermissionLevel = $Web.RoleDefinitions.Add($PermissionCreationInfo)
        $Ctx.ExecuteQuery() 
  
        Write-host "New Permission Level Created Successfully!" -ForegroundColor Green
    }
    else
    {
        Write-host "Permission Level Already Exists!" -ForegroundColor Red
    }


     #Get the role definition by name
    $RoleDefinition = $Ctx.web.RoleDefinitions.GetByName($TargetPermissionLevelName)
    $Ctx.Load($RoleDefinition)
    $Ctx.ExecuteQuery()
     
    #Add "Delete Items" Permission to the Permission Level
    $BasePermissions = New-Object Microsoft.SharePoint.Client.BasePermissions
    $BasePermissions = $RoleDefinition.BasePermissions
   <#  $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::OpenItems)
    $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ViewVersions)
     $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::DeleteVersions)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::CancelCheckout)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ManagePersonalViews)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ManageLists)#>

      <# $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ViewListItems)
    $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::AddAndCustomizePages)
     $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ApplyThemeAndBorder)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ApplyStyleSheets)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ViewUsageData)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::CreateSSCSite)#>

     <# $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ManageSubwebs)
    $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::CreateGroups)
     $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::BrowseDirectories)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::AddDelPrivateWebParts)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::UpdatePersonalWebParts)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ManageWeb)#>


       <#$BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::UseClientIntegration)
     $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ManageAlerts)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::CreateAlerts)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::AnonymousSearchAccessList)
      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::AnonymousSearchAccessWebLists)#>


      $BasePermissions.clear([Microsoft.SharePoint.Client.PermissionKind]::ManagePermissions)
      $BasePermissions.set([Microsoft.SharePoint.Client.PermissionKind]::ViewPages)

    $RoleDefinition.BasePermissions =  $BasePermissions
    $RoleDefinition.Update()
    $Ctx.ExecuteQuery()   
}
Catch {
    write-host -f Red "Error Creating Permission Level!" $_.Exception.Message
}