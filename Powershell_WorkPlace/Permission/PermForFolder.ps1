#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Variables
$SiteURL="https://smartholdingcom.sharepoint.com/sites/sbs_fs" #Or https://crescent.sharepoint.com/sites/Marketing
$FolderURL="/sites/sbs_fs/Audit/Окремий/Урбан" #Or /sites/Marketing/Project Documents/Active - Server Relative URL of the Folder!
$GroupName="Тест після оновлення M365"
$UserAccount="testsh1@smart-holding.com"
$PermissionLevel="Участь"


$GroupNameGlManager="Директор СБС"
$GroupNameOwners="sbs_fs Owners"
$GroupNameAllEditor="Окремий аудит RW"
$GroupNameEditor="Окремий аудит RW Veres"
$GroupNameAuditor="Окремий-Аудитори Veres"
$PermissionLevelEdit="Contribute"
$PermissionLevelRead="Read"
$PermissionLevelDesign="Design"

$GroupNameEditor="Окремий аудит RW SH"
$GroupNameAuditor="Окремий-Аудитори SH"

$GroupNameEditor="Окремий аудит RW SU"
$GroupNameAuditor="Окремий-Аудитори SU"


$SiteURL="https://smartholdingcom.sharepoint.com/sites/SBS_CAS_359" #Or https://crescent.sharepoint.com/sites/Marketing

$FolderURL="/sites/sbs_hr/BudgetPresentation/Фінансування лікарняних (заявки+ повідомлення)/Група СУ"
$GroupName="Керівник Відділу РЗП"
$PermissionLevel="Contribute"
 
Try {
    $Cred= Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

    $LoginName ="spsitecoladm@smart-holding.com"
    $LoginPassword ="uZ#RJpSS2%U9!PR"

    $SecurePWD = ConvertTo-SecureString $LoginPassword -asplaintext -force 
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($LoginName,$SecurePWD)
 
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
    $Web = $Ctx.web
 
    #Get the Folder
    $Folder = $Web.GetFolderByServerRelativeUrl($FolderURL)
    $Ctx.Load($Folder)
    $Ctx.ExecuteQuery()
     
    #Break Permission inheritence of the folder - Keep all existing folder permissions & keep Item level permissions
    #$Folder.ListItemAllFields.BreakRoleInheritance($False,$True)
    #Break Permission inheritence - Keep all existing list permissions & Don't keep Item level permissions
    #$Folder.ListItemAllFields.BreakRoleInheritance($True,$False)

   $Folder.ListItemAllFields.BreakRoleInheritance($False,$False) #Удаляє але залишає права на підпапки
    $Ctx.ExecuteQuery()
    Write-host -f Yellow "Folder's Permission inheritance broken..."

    $User = $Web.EnsureUser("spsitecoladm@smart-holding.com")
    $Ctx.load($User)
    $Folder.ListItemAllFields.RoleAssignments.GetByPrincipal($User).DeleteObject()
    $Ctx.ExecuteQuery()
      
    #Get the SharePoint Group & User
    $GroupManager =$Web.SiteGroups.GetByName($GroupNameGlManager)
    $Ctx.load($GroupManager)
    $Ctx.ExecuteQuery()

    $Role = $web.RoleDefinitions.GetByName($PermissionLevelRead)
    $RoleDB = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Ctx)
    $RoleDB.Add($Role)

   $GroupPermissionsManager = $Folder.ListItemAllFields.RoleAssignments.Add($GroupManager,$RoleDB)


    $GroupOwner =$Web.SiteGroups.GetByName($GroupNameOwners)
    $Ctx.load($GroupOwner)
    $Ctx.ExecuteQuery()

    $RoleDesign = $web.RoleDefinitions.GetByName($PermissionLevelDesign)
    $RoleDBDesign = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Ctx)
    $RoleDBDesign.Add($RoleDesign)

    $GroupPermissionsOwner = $Folder.ListItemAllFields.RoleAssignments.Add($GroupOwner,$RoleDBDesign)


    $GroupAllEditor=$Web.SiteGroups.GetByName($GroupNameAllEditor)
    $Ctx.load($GroupAllEditor)
    $Ctx.ExecuteQuery()

    $GroupAuditor=$Web.SiteGroups.GetByName($GroupNameAuditor)
    $Ctx.load($GroupAuditor)
    $Ctx.ExecuteQuery()

  

    $GroupEditor=$Web.SiteGroups.GetByName($GroupNameEditor)
    $Ctx.load($GroupEditor)
    $Ctx.ExecuteQuery()

      $RoleEdit = $web.RoleDefinitions.GetByName($PermissionLevelEdit)
    $RoleDBEdit = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Ctx)
    $RoleDBEdit.Add($RoleEdit)

   
    $GroupPermissions1 = $Folder.ListItemAllFields.RoleAssignments.Add($GroupAllEditor,$RoleDBEdit)
    $GroupPermissions2 = $Folder.ListItemAllFields.RoleAssignments.Add($GroupAuditor,$RoleDBEdit)
    $GroupPermissions3 = $Folder.ListItemAllFields.RoleAssignments.Add($GroupEditor,$RoleDBEdit)



    $Folder.Update()
    $Ctx.ExecuteQuery()


 
    #sharepoint online powershell set permissions on folder
    #Get the role required
    $Role = $web.RoleDefinitions.GetByName($PermissionLevel)
    $RoleDB = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Ctx)
    $RoleDB.Add($Role)
          
    #add sharepoint online group to folder using powershell
    $GroupPermissions = $Folder.ListItemAllFields.RoleAssignments.Add($Group,$RoleDB)
 
    #powershell add user to sharepoint online folder
    $UserPermissions = $Folder.ListItemAllFields.RoleAssignments.Add($User,$RoleDB)
    $Folder.Update()
    $Ctx.ExecuteQuery()
     
    Write-host "Permission Granted Successfully!" -ForegroundColor Green  
}
Catch {
    write-host -f Red "Error Granting permission to  Folder!" $_.Exception.Message
}