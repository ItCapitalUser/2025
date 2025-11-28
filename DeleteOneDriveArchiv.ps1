#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
      
#Config Parameters
$SiteURL= "https://smartholdingcom-my.sharepoint.com/personal/andrey_romaniv_ifsmart_com_ua"
$ListName = "Test1"
$CSVPath = "C:\Temp\DocumentLibraryRpt6.csv"
$BatchSize = 500


$SiteURL= "https://smartholdingcom.sharepoint.com/sites/sbs_hr"
$ListName = "Методологія"
$CSVPath = "C:\Temp\DocumentLibrary190623_1.csv"
$BatchSize = 500


$SiteURL= "https://smartholdingcom.sharepoint.com/sites/SH_TOP_238-UA89"
$ListName = "Documents" #!!!
$CSVPath = "C:\Temp\DocumentLibrary260123_1.csv"
$BatchSize = 500

$SiteURL= "https://smartholdingcom.sharepoint.com/sites/sh_ua_legal"
$ListName = "Корпоративна робота" #!!!
$CSVPath = "C:\Temp\DeleteLigal.csv"
$BatchSize = 500

$SiteURL= "https://smartholdingcom-my.sharepoint.com/personal/o_kirichenko_veres_com_ua"
$ListName = "Архивная библиотека"# "Preservation Hold Library"#!!!
$CSVPath = "C:\Temp\AR-o_kirichenko_veres_com_ua-070525.csv"
$BatchSize = 500

$SiteURL= "https://smartholdingcom-my.sharepoint.com/personal/o_kirichenko_veres_com_ua"
$ListName = "Documents" #!!!
$CSVPath = "C:\Temp\Doc-o_kirichenko_veres_com_uaa-070525.csv"
$BatchSize = 500
  
#Get Credentials to connect
$Cred = Get-Credential
  
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
      
    #Get the Document Library
    $List =$Ctx.Web.Lists.GetByTitle($ListName)
      
    #Define CAML Query to Get List Items in batches
    $Query = New-Object Microsoft.SharePoint.Client.CamlQuery
    $Query.ViewXml ="
    <View Scope='RecursiveAll'>
        <Query>
            <OrderBy><FieldRef Name='ID' Ascending='TRUE'/></OrderBy>
        </Query>
        <RowLimit Paged='TRUE'>$BatchSize</RowLimit>
    </View>"
 
    $DataCollection = @()
    Do
    {
        #get List items
        $ListItems = $List.GetItems($Query) 
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery() 
 
        #Iterate through each item in the document library
        ForEach($ListItem in $ListItems)
        {
        
            Write-Host -f Yellow $ListItem.FieldValues.FileRef

            #Collect data        
            $Data = New-Object PSObject -Property ([Ordered] @{
                IdF=$ListItem.FieldValues.ID
                Name  = $ListItem.FieldValues.FileLeafRef
                RelativeURL = $ListItem.FieldValues.FileRef
                Len=$ListItem.FieldValues.FileRef.Length
                TypeFile= $ListItem.FieldValues.File_x0020_Type 
                Type =  $ListItem.FileSystemObjectType
                CreatedBy =  $ListItem.FieldValues.Author.Email
                CreatedOn = $ListItem.FieldValues.Created
                ModifiedBy =  $ListItem.FieldValues.Editor.Email
                ModifiedOn = $ListItem.FieldValues.Modified
                FileSizeMB = [math]::Round($ListItem.FieldValues.File_x0020_Size /1MB,2)

                  
            })
            $DataCollection += $Data
            Write-Host "----"
        }
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
    }While($Query.ListItemCollectionPosition -ne $null)

     $DocLibrary = $Ctx.Web.Lists.GetByTitle($ListName)
    $Ctx.Load($DocLibrary)
    $Ctx.ExecuteQuery()
 
    $DataSort1 = $DataCollection | Select-Object IdF, Name
        $DataSort = $DataCollection | Where-Object { $_.RelativeURL -like '*sites/sh_ua_legal/CrpW/INDUSTRIAL PARK Group/*' }    |  Sort-Object Len -Descending #Where-Object { $_.RelativeURL -like '*Documents/Документы/Проект А*' }   |  Sort-Object Len -Descending

    
    $DataSort = $DataCollection | Where-Object { $_.CreatedOn.Year -eq 2023 }   |  Sort-Object Len -Descending #Where-Object { $_.RelativeURL -like '*Documents/Документы/Проект А*' }   |  Sort-Object Len -Descending

    Foreach($u in $DataCollection[1..3])
    {
        $u.CreatedOn.Year
    }

    $DataSort | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Encoding UTF8
    $CSVPath = "C:\Temp\DL-oleksandr_tsviliy_it-capital_com_ua-200325_afterDelete.csv"


    foreach($itemA in $DataSort)
    {
        
        if($itemA.Type -eq "File")
        {
        Write-Host "File"
                Write-Host $itemA.RelativeURL -ForegroundColor Yellow

          $File = $Ctx.Web.GetFileByServerRelativeUrl($itemA.RelativeURL)
        $Ctx.Load($File)
        $Ctx.ExecuteQuery()
                 
        #Delete the file
        $File.DeleteObject()
        Write-Host "File delete!" -F Green
        }
        else
        {
        Write-Host "Folder"
        Write-Host $itemA.RelativeURL -ForegroundColor DarkGreen
        $Folder = $Ctx.Web.GetFolderByServerRelativeUrl($itemA.RelativeURL)
        $Ctx.Load($Folder)
        $Ctx.ExecuteQuery()
                 
        #Delete the file
        $Folder.DeleteObject()
        
        }
        $Ctx.ExecuteQuery()
    }
    #Export Documents data to CSV
    $DataSort | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Encoding UTF8
    Write-host -f Green "Document Library Inventory Exported to CSV!"
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}


$Ctx.Load($Ctx.Web)  
        $Ctx.Load($Ctx.Web.Lists)  
        $Ctx.Load($ctx.Web.Webs)  
        $Ctx.ExecuteQuery() 
        
        #Get content types of each list from the web  
        $ContentTypeUsages=@()  
        ForEach($List in $Ctx.Web.Lists)  
        {  
            $ContentTypes = $List.ContentTypes  
            $Ctx.Load($ContentTypes)  
            $Ctx.Load($List.RootFolder)  
            $Ctx.ExecuteQuery()  
               
            #Get List URL  
            If($Ctx.Web.ServerRelativeUrl -ne "/")  
            {  
                $ListURL=  $("{0}{1}" -f $Ctx.Web.Url.Replace($Ctx.Web.ServerRelativeUrl,''), $List.RootFolder.ServerRelativeUrl)  
            }  
            else  
            {  
                $ListURL=  $("{0}{1}" -f $Ctx.Web.Url, $List.RootFolder.ServerRelativeUrl)  
            }  
     
            #Get each content type data  
            ForEach($CType in $ContentTypes)  
            {  
                $ContentTypeUsage = New-Object PSObject  
                $ContentTypeUsage | Add-Member NoteProperty SiteURL($SiteURL)  
                $ContentTypeUsage | Add-Member NoteProperty ListName($List.Title)  
                $ContentTypeUsage | Add-Member NoteProperty ListURL($ListURL)  
                $ContentTypeUsage | Add-Member NoteProperty ContentTypeName($CType.Name)  
                $ContentTypeUsages += $ContentTypeUsage  
            }  
        }  
        #Export the result to CSV file  
        $ContentTypeUsages 

$i=8411
for(;$i -le 9999;$i++)
{
    $name = "/sites/SH_TOP_238-70/Shared Documents/88 Архів інформації/Проект А (1)/ARCHIVE/IMG_"+$i+"_1.JPG" #"_1.JPG"
    Write-Host $name

    $File = $Ctx.Web.GetFileByServerRelativeUrl( $name)
        $Ctx.Load($File)
        $Ctx.ExecuteQuery()
                 
        #Delete the file
        $File.DeleteObject()
        $Ctx.ExecuteQuery() 
}
  