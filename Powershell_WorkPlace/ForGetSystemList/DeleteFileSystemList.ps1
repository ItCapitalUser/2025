#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$SiteURL = "https://smartholdingcom-my.sharepoint.com/personal/t_semenova_veres_com_ua"
$SiteURL = "https://smartholdingcom-my.sharepoint.com/personal/n_morozova_veres_com_ua"

$userN= "n_morozova_veres_com_ua"
$DateCurr=Get-Date -Format "ddMMyyyy" 

$CSVPathAllFiles = "C:\Temp\$($userN)-all-$($DateCurr).csv"
$CSVPathFileDelete = "C:\Temp\$($userN)-delete-$($DateCurr).csv"
$CSVPathFileAfter = "C:\Temp\$($userN)-after-$($DateCurr).csv"

$BatchSize = 500 


#Get Credentials to connect
$Cred = Get-Credential
try
{
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)


    $List = $Ctx.Web.lists.GetByTitle("Архивная библиотека")
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()



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
        
            #Collect data        
            $Data = New-Object PSObject -Property ([Ordered] @{
                IdF=$ListItem.FieldValues.ID
                Name  = $ListItem.FieldValues.FileLeafRef
                RelativeURL = $ListItem.FieldValues.FileRef
                Len=$ListItem.FieldValues.FileRef.Length
                Type =  $ListItem.FileSystemObjectType
                CreatedBy =  $ListItem.FieldValues.Author.Email
                CreatedOn = $ListItem.FieldValues.Created
                ModifiedBy =  $ListItem.FieldValues.Editor.Email
                ModifiedOn = $ListItem.FieldValues.Modified
                FileSize = $ListItem.FieldValues.File_x0020_Size
            })
            $DataCollection += $Data
        }
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
    }While($Query.ListItemCollectionPosition -ne $null)

    $DataSort = $DataCollection |   Sort-Object CreatedOn #-Descending
    $DataSort | Export-Csv -Path $CSVPathAllFiles -Force -NoTypeInformation -Encoding UTF8

    $countStart=$DataSort.Count
    Write-Host "Count Files start = $($countStart)" -ForegroundColor Green

    $lastYear = $DataSort[1].CreatedOn.Year+1
    $UntilDate= Get-Date -Year $lastYear -Month 1 -Date 01
    $UntilDate= Get-Date -Year 2023 -Month 1 -Date 01

    $DataSortForDelete = $DataCollection | Where-Object { $_.CreatedOn -lt $UntilDate } 
    $DataSortForDelete | Export-Csv -Path $CSVPathFileDelete -Force -NoTypeInformation -Encoding UTF8

     $countDelete=$DataSortForDelete.Count
     Write-Host "Count Files which delete = $($countDelete)" -ForegroundColor Green


    foreach($itemDelete in $DataSortForDelete)
    {
       Write-Host "$($itemDelete.Name) id: $($itemDelete.IdF)"

      $item = $List.GetItemById($itemDelete.IdF)
       $Ctx.Load($item)
       $Ctx.ExecuteQuery()
       $item.DeleteObject()
       $Ctx.ExecuteQuery()
       Write-Host "Success delete" -ForegroundColor Magenta
    }


    $List = $Ctx.Web.lists.GetByTitle("Архивная библиотека")
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()



    $Query = New-Object Microsoft.SharePoint.Client.CamlQuery
    $Query.ViewXml ="
    <View Scope='RecursiveAll'>
        <Query>
            <OrderBy><FieldRef Name='ID' Ascending='TRUE'/></OrderBy>
        </Query>
        <RowLimit Paged='TRUE'>$BatchSize</RowLimit>
    </View>"
 
    $DataCollectionAfter = @()
    Do
    {
        #get List items
        $ListItems = $List.GetItems($Query) 
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery() 
 
        #Iterate through each item in the document library
        ForEach($ListItem in $ListItems)
        {
        
            #Collect data        
            $Data = New-Object PSObject -Property ([Ordered] @{
                IdF=$ListItem.FieldValues.ID
                Name  = $ListItem.FieldValues.FileLeafRef
                RelativeURL = $ListItem.FieldValues.FileRef
                Len=$ListItem.FieldValues.FileRef.Length
                Type =  $ListItem.FileSystemObjectType
                CreatedBy =  $ListItem.FieldValues.Author.Email
                CreatedOn = $ListItem.FieldValues.Created
                ModifiedBy =  $ListItem.FieldValues.Editor.Email
                ModifiedOn = $ListItem.FieldValues.Modified
                FileSize = $ListItem.FieldValues.File_x0020_Size
            })
            $DataCollectionAfter += $Data
        }
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
    }While($Query.ListItemCollectionPosition -ne $null)

    $DataSortAfter = $DataCollectionAfter |   Sort-Object CreatedOn #-Descending
    $DataSortAfter | Export-Csv -Path $CSVPathFileAfter -Force -NoTypeInformation -Encoding UTF8

     $countAfter=$DataSortAfter.Count
     Write-Host "Count Files which after = $($countAfter)" -ForegroundColor Green

}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}



