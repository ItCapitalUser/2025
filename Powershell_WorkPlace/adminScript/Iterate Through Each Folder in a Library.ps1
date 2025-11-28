Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Function to Get Sub-folders of a Folder in SharePoint Online
Function Get-SPOFolders([Microsoft.SharePoint.Client.Folder]$Folder)
{
    Try {
         
        Write-host $Folder.ServerRelativeUrl
 
        #Process all Sub Folders
        $Ctx.Load($Folder.Folders)
        $Ctx.ExecuteQuery()
 
        #Iterate through each sub-folder of the folder
        Foreach ($Folder in $Folder.Folders)
        {
            #Call the function recursively
            Get-SPOFolders $Folder
        }
    }
    Catch {
        write-host -f Red "Error Getting Folder!" $_.Exception.Message
    }
}
 
#Variables
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/fo-contEvents-test"
$ListName = "SMART HOLDING Group"
 
#Get Credentials to connect
$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials
 
#Get the Library
$List = $Ctx.web.Lists.GetByTitle($ListName)
$Ctx.Load($List.RootFolder)
$Ctx.ExecuteQuery()
 
#call the function to get all folders of a document library
Get-SPOFolders $List.RootFolder


#Read more: https://www.sharepointdiary.com/2018/03/sharepoint-online-powershell-to-get-folder-in-document-library.html#ixzz8pZnGEtyN