#Load SharePoint CSOM Assemblies  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"  
   
Function ReadStructure  
{  
  param  
    (  
        [Parameter(Mandatory=$true)] [Microsoft.SharePoint.Client.Folder] $SourceFolder  
    )  
    Try {  
        #Get all Files from the source folder  
       <# $SourceFilesColl = $SourceFolder.Files  
        $SourceFolder.Context.Load($SourceFilesColl)  
        $SourceFolder.Context.ExecuteQuery()  
   
        #Iterate through each file and copy  
        Foreach($SourceFile in $SourceFilesColl)  
        {  
           Write-host -f blue "Copied File '$($SourceFile.ServerRelativeUrl)' start"  

           
        }  #>
   
        #Process Sub Folders  
        $SubFolders = $SourceFolder.Folders  
        $SourceFolder.Context.Load($SubFolders)  
        $SourceFolder.Context.ExecuteQuery()  
        Foreach($SubFolder in $SubFolders)  
        {  
            If($SubFolder.Name -ne "Forms")  
            {  
                #Prepare Target Folder  
                Write-host "SubFolder :" $SubFolder.ServerRelativeUrl -f Magenta

                $SubFolder.Retrieve("HasUniqueRoleAssignments")
                $Ctx.ExecuteQuery()
                    If ($SubFolder.HasUniqueRoleAssignments -eq $true)
                    {
                        #Send Data to CSV File
                        
                        Write-host  -ForegroundColor Green "`t`t`t Unique Permissions Found on Item ID:"
                    }
                ReadStructure -SourceFolder $SubFolder

            }  
        }  
    }  
    Catch {  
        write-host -f Red "Error Copying File!" $_.Exception.Message  
    }  
}  


   
#Set Parameter values  
$SiteURL="https://smartholdingcom.sharepoint.com/sites/sbs_hr"  
   
$LibraryName="KPI"  
    


$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials
    
#Get Lists from the web
$Ctx.Load($Ctx.Web.Lists)
$Ctx.executeQuery()  

$ServerRelativeUrl= "/sites/sbs_hr/Kpi/2023/Квартал 3" 
 $FolderS = $Ctx.Web.GetFolderByServerRelativeUrl($ServerRelativeUrl)
    $Ctx.Load($FolderS)
    $Ctx.ExecuteQuery()
    
    $FolderS.ListItemAllFields.Retrieve("HasUniqueRoleAssignments") 
     $Ctx.ExecuteQuery()

     If ($FolderS.ListItemAllFields.HasUniqueRoleAssignments -eq $true)
                    {
                     Write-Host "1"
                    }
                    else
                    {
                    Write-Host "2"
                    }
   
#Call the function  
ReadStructure -SourceFolder $FolderS 
