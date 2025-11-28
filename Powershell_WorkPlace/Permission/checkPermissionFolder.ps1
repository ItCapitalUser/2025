#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Function to Get Folder Permissions
Function Get-SPOFolderPermission([String]$SiteURL, [String]$FolderRelativeURL)
{
    Try{
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
      
        #Get the Folder
        $Folder = $Ctx.Web.GetFolderByServerRelativeUrl($FolderRelativeURL)
        $Ctx.Load($Folder)
        $Ctx.ExecuteQuery()

         $Folder.ListItemAllFields.Retrieve("HasUniqueRoleAssignments")
    $Ctx.ExecuteQuery()    
    Write-host -ForegroundColor Green "Folder has unique Permissions:" $Folder.ListItemAllFields.HasUniqueRoleAssignments
 
        #Get permissions assigned to the Folder
        $RoleAssignments = $Folder.ListItemAllFields.RoleAssignments
        $Ctx.Load($RoleAssignments)
        $Ctx.ExecuteQuery()
 
        #Loop through each permission assigned and extract details
        $PermissionCollection = @()
        Foreach($RoleAssignment in $RoleAssignments)
        { 
            $Ctx.Load($RoleAssignment.Member)
            $Ctx.executeQuery()
 
            #Get the User Type
            $PermissionType = $RoleAssignment.Member.PrincipalType
 
#Get the Permission Levels assigned
            $Ctx.Load($RoleAssignment.RoleDefinitionBindings)
            $Ctx.ExecuteQuery()
            $PermissionLevels = ($RoleAssignment.RoleDefinitionBindings | Select -ExpandProperty Name) -join ","
             
            #Get the User/Group Name
            $Name = $RoleAssignment.Member.Title # $RoleAssignment.Member.LoginName
 
            #Add the Data to Object
            $Permissions = New-Object PSObject
            $Permissions | Add-Member NoteProperty Name($Name)
            $Permissions | Add-Member NoteProperty Type($PermissionType)
            $Permissions | Add-Member NoteProperty PermissionLevels($PermissionLevels)
            $PermissionCollection += $Permissions
        }
        Return $PermissionCollection
    }
    Catch {
    write-host -f Red "Error Getting Folder Permissions!" $_.Exception.Message
    }
}
  
#Set Config Parameters
$SiteURL="https://smartholdingcom.sharepoint.com/sites/sbs_fs"
$FolderRelativeURL="/sites/sbs_fs/Audit/Окремий"
$FolderRelativeURL="/sites/sbs_fs/Audit/Окремий/Верес"
$FolderRelativeURL="/sites/sbs_fs/Audit/Окремий/Смарт Холдинг"
$FolderRelativeURL="/sites/sbs_fs/Audit/Окремий/Урбан"
  
#Get Credentials to connect
$Cred= Get-Credential
  
#Call the function to Get Folder Permissions
Get-SPOFolderPermission $SiteURL $FolderRelativeURL