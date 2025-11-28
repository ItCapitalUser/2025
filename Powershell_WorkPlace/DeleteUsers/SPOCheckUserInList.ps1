#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

  $Cred = Get-Credential
 
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
       
 
#Function to check if a user account is valid
Function Ensure-SPOUser()
{
    Param( 
        [Parameter(Mandatory=$true)] [string]$UserID,
        [Parameter(Mandatory=$true)] [string]$SiteURL
        )
    Try {
        #Setup Credentials to connect
      
        #ensure sharepoint online user
        $Web = $Ctx.Web
        $User=$web.EnsureUser($UserID)
        $Ctx.ExecuteQuery()
        Return $True
    }
    Catch {    
        Return $False
    }
}
 
#Variables
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/SBS_CAS_359"
$UserID = "anna.berdii@smartbs.com.ua"
$UserID = "oksana.bilohub@smartbs.com.ua"
   
#Call the function to Check if the user account is valid
Ensure-SPOUser -UserID $UserID -SiteURL $SiteURL