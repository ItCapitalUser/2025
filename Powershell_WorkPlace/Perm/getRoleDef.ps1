	
#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Get Credentials to connect
        $Cred= Get-Credential
        $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
  
Function Get-SPOPermissionLevels()
{
  param
    (
        [Parameter(Mandatory=$true)] [string] $SiteURL       
    )
    Try { 
        
  
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
 
        #Get all permission levels
        $RoleDefColl=$Ctx.web.RoleDefinitions
        $Ctx.Load($RoleDefColl)
        $Ctx.ExecuteQuery()
     
        #Loop through all role definitions
        ForEach($RoleDef in $RoleDefColl)
        {
            Write-Host -ForegroundColor Green $RoleDef.Name
        }
     }
    Catch {
        write-host -f Red "Error getting permission Levels!" $_.Exception.Message
    }
}
  
#Set parameter values
$SiteURL="https://smartholdingcom.sharepoint.com/sites/portal/"
 
#Call the function 
Get-SPOPermissionLevels -SiteURL $SiteURL