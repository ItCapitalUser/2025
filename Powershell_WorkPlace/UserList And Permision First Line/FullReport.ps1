#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/SUF151"
$GroupName="Support It Team"
$PermissionLevelName="Manage_user_in_group"
$UserAccount = "testsh1@smart-holding.com"
$SuportTeam = @('roman.pashkov@it-capital.com.ua','igor.pozdnyakov@it-capital.com.ua','Yuriy.Polevoy@it-capital.com.ua')
$AADGroupNameSuportTeam= "Adm SPO VSiS"
$FullArr= @("Повний доступ", "Полный доступ", "Full Control")
 
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
    $Web = $Ctx.Web

    #region Create RolePermm
    Try {
        $RoleDefinitions = $Web.RoleDefinitions
        $Ctx.Load($RoleDefinitions) 
        $Ctx.ExecuteQuery()

        $PermissionLevel = $RoleDefinitions | Where-Object { $_.Name -eq $PermissionLevelName } 
        if($PermissionLevel -eq $null)
        {
            #region Create base Permission set
            $Permissions = New-Object Microsoft.SharePoint.Client.BasePermissions
            #Add permissions to it
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::EmptyMask)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::ViewFormPages)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::Open)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::ViewPages)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::BrowseUserInfo)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::UseRemoteAPIs)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::EditMyUserInfo)
            $Permissions.Set([Microsoft.SharePoint.Client.PermissionKind]::EnumeratePermissions)
            #endregion

            #Create new permission level from source permission level
            $PermissionCreationInfo = New-Object Microsoft.SharePoint.Client.RoleDefinitionCreationInformation
            $PermissionCreationInfo.Name = $PermissionLevelName
            $PermissionCreationInfo.Description = "Custom create Permission for manage user in a group."
            $PermissionCreationInfo.BasePermissions = $Permissions
 
            #Add the role definitin to the site
            $PermissionLevel = $Web.RoleDefinitions.Add($PermissionCreationInfo)
            $Ctx.ExecuteQuery() 
  
            Write-host "New Permission Level Created Successfully!" -ForegroundColor Green
        }
        else
        {
            Write-host "Permission Level Already Exists!" -ForegroundColor Red
        } 
    }
    catch {
        write-host "Error Permission Level Created: $($_.Exception.Message)" -foregroundcolor Red
    }
    #endregion


    #region Create Group 
    try{

        #Get all existing groups of the site
        $Groups = $Ctx.Web.SiteGroups
        $Ctx.load($Groups)
        $Ctx.ExecuteQuery()
     
        #Get Group Names
        $GroupNames =  $Groups | Select -ExpandProperty Title
     
        #Check if the given group doesn't exist already
        If($GroupNames -notcontains $GroupName)
        {
            #sharepoint online powershell create group
            $GroupInfo = New-Object Microsoft.SharePoint.Client.GroupCreationInformation
            $GroupInfo.Title = $GroupName     
            $Group = $Ctx.web.SiteGroups.Add($GroupInfo)
            $Ctx.ExecuteQuery()
 
            #Assign permission to the group
            $RoleDef = $Ctx.web.RoleDefinitions.GetByName($PermissionLevelName)
            $RoleDefBind = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Ctx)
            $RoleDefBind.Add($RoleDef)
            $Ctx.Load($Ctx.Web.RoleAssignments.Add($Group,$RoleDefBind))
            $Ctx.ExecuteQuery()
 
            write-host  -f Green "User Group has been Added Successfully!"
        }
        else
        {
            Write-host -f Yellow "Group Exists already!"
        }
        }
    Catch {
        write-host -f Red "Error Creating New user Group!" $_.Exception.Message
    }
    #endregion

    #region !!!Add Team to Group (this block to comment)
    <#Try {
        #Get the Web and Group
        $Group= $Web.SiteGroups.GetByName($GroupName)

        foreach($UserSuportTeam in $SuportTeam)
        {
            Write-Host $UserSuportTeam

            #ensure user sharepoint online powershell - Resolve the User
            $User=$web.EnsureUser($UserSuportTeam)
 
            #Add user to the group
            $Result = $Group.Users.AddUser($User)
            $Ctx.Load($Result)
            $Ctx.ExecuteQuery()
 
            write-host  -f Green "User '$User' has been added to '$GroupName'"
        }
 
        
    }
    Catch {
        write-host -f Red "Error Adding user to Group!" $_.Exception.Message
    }#>

    #endregion

    #region Add AAD Group to SPO Group
    try
    {
        $Group= $Web.SiteGroups.GetByName($GroupName)

        $AADGroup = $web.EnsureUser($AADGroupNameSuportTeam)
  
        #sharepoint online powershell add AD group to sharepoint group
        $Result = $Group.Users.AddUser($AADGroup)
        $Ctx.Load($Result)
        $Ctx.ExecuteQuery()
    }
    Catch {
        write-host -f Red "Error Add AAD Group to SPO Group!" $_.Exception.Message
    }
    #endregion

    #region Change Owner  
    Try {
        $GroupOwner = $Ctx.Web.SiteGroups.GetByName($GroupName)
     
        #Get All Groups of the Site
        $GroupsColl = $Ctx.web.SiteGroups
        $Ctx.Load($GroupsColl)
        $Ctx.ExecuteQuery()
 
        #Iterate through each Group - Exclude SharePoint Online System Groups!
        # ForEach($Group in $GroupsColl | Where {$_.OwnerTitle -ne "System Account
        #get  group -exclude SharePoint Online System Groups, custom group suport, and group with word "Owners"
        #$GroupsColl| Where {($_.OwnerTitle -ne "System Account" -and $_.Title  -ne $GroupName -and !$_.Title.Contains("Owners"))} | Select  Title

        #region get Group with Ful PermLevel
        $WebRoleAssig = $Web.RoleAssignments
        $Ctx.Load($WebRoleAssig)
        $Ctx.ExecuteQuery()

        #Get All permLevel for Web
       <# $PermissionCollection = @()
        Foreach($RoleAssignment in $WebRoleAssig)
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
        }#>

        $GroupFullControl = @()
        Foreach($RoleAssignment in $WebRoleAssig)
        {  
            $Ctx.Load($RoleAssignment.Member)
            $Ctx.executeQuery()
             
            #Get the Permission Levels assigned
            $Ctx.Load($RoleAssignment.RoleDefinitionBindings)
            $Ctx.ExecuteQuery()
            $isFullPermLevel =$RoleAssignment.RoleDefinitionBindings| Where  Name -in $FullArr  <#-eq "Повний доступ"#> | Select -ExpandProperty Name

            if($isFullPermLevel -and ($RoleAssignment.Member.PrincipalType -ne "User"))
            {
                $GroupFullControl+=$RoleAssignment.Member.Title
            }
        }
        Write-Host "Get Group with Full permLevel"
        #endregion

        # Get group - Exclude SharePoint Online System Groups, custom group suport, and group with permLevel Full
        #$GroupsColl| Where {($_.OwnerTitle -ne "System Account" -and $_.Title  -ne $GroupName -and $_.Title -notin $GroupFullControl)} | Select  Title

        #Set new Owner group - Exclude SharePoint Online System Groups, custom group suport, and group with permLevel Full
        ForEach($Group in $GroupsColl| Where {($_.OwnerTitle -ne "System Account" -and $_.Title  -ne $GroupName -and $_.Title -notin $GroupFullControl)})
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
    #endregion
}
Catch {
    write-host -f Red "Error!" $_.Exception.Message
}

#region Delete all users from spo group
try
{
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
    $Web = $Ctx.Web

    $Group =$Web.SiteGroups.GetByName($GroupName)

    $allUsers = $Group.Users
    $Ctx.Load($allUsers)
    $Ctx.ExecuteQuery()

    $OnlyUsersInGroup = $allUsers | Where {$_.PrincipalType -eq "User"}

    foreach($UserInGroup in $OnlyUsersInGroup)
    {
        Write-Host "$($UserInGroup.Title), $($UserInGroup.PrincipalType )"
        $Group.Users.RemoveByLoginName($UserInGroup.LoginName)
        $Ctx.ExecuteQuery()
    }
}
Catch{
    Write-Host -f Red "Error delete all users from group! " $_.Exception.Message
}
#endregion

#Get all permission levels
        $RoleDefColl=$Ctx.web.RoleDefinitions
        $Ctx.Load($RoleDefColl)
        $Ctx.ExecuteQuery()
     
        #Loop through all role definitions
        ForEach($RoleDef in $RoleDefColl)
        {
            Write-Host -ForegroundColor Green $RoleDef.Name
        }