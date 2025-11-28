#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Variables for Processing
$SiteURL ="https://smartholdingcom.sharepoint.com/sites/fo-contEvents-test" # "https://smartholdingcom.sharepoint.com/sites/testEmptySite"

#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)


#region Create $ParentFolder.Folders.Add($FolderName) 
#from example web
 #Variables for Processing
$SiteUrl = "https://crescent.sharepoint.com/sites/marketing"
$ListURL="/sites/marketing/Shared Documents"
$FolderName="Reports"
$UserName="salaudeen@crescent.com"
$Password ="password goes here"
  
#Setup Credentials to connect
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
Try {
    #Set up the context
    $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)
    $Context.Credentials = $credentials
   
    #Get the List Root Folder
    $ParentFolder=$Context.web.GetFolderByServerRelativeUrl($ListURL)
 
    #sharepoint online powershell create folder
    $Folder = $ParentFolder.Folders.Add($FolderName)
    $ParentFolder.Context.ExecuteQuery()
 
    Write-host "New Folder Created Successfully!" -ForegroundColor Green
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}

#Read more: https://www.sharepointdiary.com/2016/08/sharepoint-online-create-folder-using-powershell.html

#my example
$FolderURL = "/sites/fo-contEvents-test/GrSH/Test"
$FolderName="Reports"
Try {
    #Set up the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
   
    #Get the List Root Folder
    $ParentFolder=$Context.web.GetFolderByServerRelativeUrl($FolderURL)
 
    #sharepoint online powershell create folder
    $Folder = $ParentFolder.Folders.Add($FolderName)
    $ParentFolder.Context.ExecuteQuery()
 
    Write-host "New Folder Created Successfully!" -ForegroundColor Green
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}

#endregion

#region $Context.Web.Folders.Add
#example from web
#Set up the context
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)
$Context.Credentials = $credentials
 
#sharepoint online powershell create folder in document library
$Folder=$Context.Web.Folders.Add("Shared Documents/Reports/V2")
$Context.ExecuteQuery()
 
Write-host "Folder Created at: " $Folder.ServerRelativeUrl -ForegroundColor Green

#my excample
#Get the Web
$Web = $Ctx.Web
$Ctx.Load($Web)
$Ctx.ExecuteQuery()



#endregion

#region $List.RootFolder.Folders.Add
#add folder first level
$NewFolder = $List.RootFolder.Folders.Add("Test")
$Ctx.ExecuteQuery()

#add subfolder
$NewFolder = $List.RootFolder.Folders.Add("GrSH/Test/test2410_new")
$Ctx.ExecuteQuery()
#endregion

#region function Create-Folder() from web
 Function Create-Folder()
{
    param(
        [Parameter(Mandatory=$true)][string]$SiteURL,
        [Parameter(Mandatory=$false)][System.Management.Automation.PSCredential] $Cred,
        [Parameter(Mandatory=$true)][string]$LibraryName,
        [Parameter(Mandatory=$true)][string]$FolderName
    )
 
    Try {
        $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
 
        #Get the Library by Name
        $List = $Ctx.Web.Lists.GetByTitle($LibraryName)
 
        #Check Folder Exists already
        $Folders = $List.RootFolder.Folders
        $Ctx.Load($Folders)
        $Ctx.ExecuteQuery()
 
        #Get existing folder names
        $FolderNames = $Folders | Select -ExpandProperty Name
        if($FolderNames -contains $FolderName)
        {
            write-host "Folder Exists Already!" -ForegroundColor Yellow
        }
        else #powershell sharepoint online create folder if not exist
        {
            #sharepoint online create folder powershell
            $NewFolder = $List.RootFolder.Folders.Add($FolderName)
            $Ctx.ExecuteQuery()
            Write-host "Folder '$FolderName' Created Successfully!" -ForegroundColor Green
        }
    }
    Catch {
        write-host -f Red "Error Creating Folder!" $_.Exception.Message
    }
}
 
#Call the function to delete list view
Create-Folder -SiteURL "https://crescent.sharepoint.com" -Cred (Get-Credential) -LibraryName "Project Documents" -FolderName "Active"

#endregion

#region my fuction Create-Folder() 
Function Create-Folder()
{
    param(
        [Parameter(Mandatory=$true)][string]$FolderName,
        [Parameter(Mandatory=$true)][Microsoft.SharePoint.Client.SecurableObject ]$ListObj
    )
 
    Try {
 
        #Check Folder Exists already
        $Folders = $ListObj.RootFolder.Folders
        $Ctx.Load($Folders)
        $Ctx.ExecuteQuery()

 
        #Get existing folder names
        $FolderNames = $Folders | Select -ExpandProperty Name
        if($FolderNames -contains $FolderName)
        {
            write-host "Folder Exists Already!" -ForegroundColor Yellow
        }
        else #powershell sharepoint online create folder if not exist
        {
            #sharepoint online create folder powershell
            $NewFolder = $List.RootFolder.Folders.Add($FolderName)
            $Ctx.ExecuteQuery()
            Write-host "Folder '$FolderName' Created Successfully!" -ForegroundColor Green
        }
    }
    Catch {
        write-host -f Red "Error Creating Folder!" $_.Exception.Message
    }
}

 #Get the Library by Name
    $List = $Ctx.Web.Lists.GetByTitle("SMART HOLDING Group")
    $Ctx.Load($List)

            Create-Folder  -FolderName "GrSH/Test/test2410_ne4" -ListObj $List

#endregion

#region Check If a Folder Exists 
# GrSH - internal name library
$FolderRelativeURL = "/sites/fo-contEvents-test/GrSH/Test/test2410"


Try {
    $Folder = $Web.GetFolderByServerRelativeUrl($FolderRelativeURL)
    $Ctx.Load($Folder)
    $Ctx.ExecuteQuery()
 
    Write-host -f Green "Folder Exists!"
}
Catch {
            Write-host -f Yellow "Folder Doesn't Exist!"
        }  
#endregion

 
