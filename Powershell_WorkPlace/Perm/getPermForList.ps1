#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Function to Get List Permissions
Function Get-SPOListPermission([String]$SiteURL, [String]$ListName)
{
    Try{
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
       
        #Get the List
        $List = $Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()
  
        #Get permissions assigned to the List
        $RoleAssignments = $List.RoleAssignments
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
    write-host -f Red "Error Getting List Permissions!" $_.Exception.Message
    }
}
   
#Set Config Parameters
$SiteURL="https://smartholdingcom.sharepoint.com/sites/portal"
$ListName="Pages"
$ReportFile = "C:\Temp\ListPermissions090524.csv"
   
#Get Credentials to connect
$Cred= Get-Credential
   
#Call the function to Get List Permissions
$ListPermissions = Get-SPOListPermission $SiteURL $ListName
 
#Get List Permissions
$ListPermissions
 
#Export List Permissions to CSV File
$ListPermissions | Export-CSV $ReportFile -NoTypeInformation


$Lists = $Ctx.Web.Lists
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()

    $Lists | Select -Property Title