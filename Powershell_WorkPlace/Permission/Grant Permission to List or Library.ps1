#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Configuration Parameters
$SiteURL= "https://smartholdingcom.sharepoint.com/sites/SUF151/"#"https://crescent.sharepoint.com/sites/Projects/"
$ListName="Інвестиції"
$GroupName="Відділ фінансового планування та контролю"
$PermissionLevel="Совместная работа"
 
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
   
    #Get the web and List
    $Web=$Ctx.Web
    $List=$web.Lists.GetByTitle($ListName)
     
    #Break Permission inheritence - keep existing list permissions & Item level permissions
    $List.BreakRoleInheritance($True,$True)
    $Ctx.ExecuteQuery()
    Write-host -f Yellow "Permission inheritance broken..."
     
    #Get the group or user
    $Group =$Web.SiteGroups.GetByName($GroupName) #For User: $Web.EnsureUser('salaudeen@crescent.com')
    $Ctx.load($Group)
    $Ctx.ExecuteQuery()
 
    #Grant permission to Group     
    #Get the role required
    $Role = $web.RoleDefinitions.GetByName($PermissionLevel)
    $RoleDB = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Ctx)
    $RoleDB.Add($Role)
         
    #Assign list permissions to the group
    $Permissions = $List.RoleAssignments.Add($Group,$RoleDB)
    $List.Update()
    $Ctx.ExecuteQuery()
    Write-Host "Added $PermissionLevel permission to $GroupName group in $ListName list. " -foregroundcolor Green
}
Catch {
    write-host -f Red "Error Granting Permissions!" $_.Exception.Message
}  