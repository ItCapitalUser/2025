#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables for Processing
$SiteURL ="https://smartholdingcom.sharepoint.com/sites/sbs_hr"

$CSVPath = "C:\Temp\Study\testAll2.csv"
$CSVPathF = "C:\Temp\Study\test2.csv"

$ListName = "ІТ КАПІТАЛ"



$LoginName ="spsitecoladm@smart-holding.com"
$LoginPassword ="uZ#RJpSS2%U9!PR"

#region ctreate object Context by SiteURL

$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
 
#supply Login Credentials
$SecurePWD = ConvertTo-SecureString $LoginPassword -asplaintext -force 
$Credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($LoginName,$SecurePWD)
$Ctx.Credentials = $Credential
#endregion

$Groups=$Ctx.Web.SiteGroups
$Ctx.Load($Groups)
$Ctx.ExecuteQuery()
 
$table = new-object system.data.datatable
$table.Columns.Add("layer 1", "System.string") | Out-Null
$table.Columns.Add("layer 2", "System.string") | Out-Null
$table.Columns.Add("layer 3", "System.string") | Out-Null
$table.Columns.Add("layer 4", "System.string") | Out-Null
foreach ($name in $Groups.Title){
      $table.Columns.Add($name,  "System.string") | Out-Null
} 

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
    $pattern = "/"
    Do
    {
        #get List items
        $ListItems = $List.GetItems($Query) 
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery() 
 
        #Iterate through each item in the document library
        ForEach($ListItem in $ListItems)
        {
        
           if($ListItem.FileSystemObjectType -eq "Folder")
            {
            #Collect data 
            $stringTest = $ListItem.FieldValues.FileRef
            $count = [regex]::matches($stringTest, $pattern).count
       
            $Data = New-Object PSObject -Property ([Ordered] @{
                IdF=$ListItem.FieldValues.ID
                Name  = $ListItem.FieldValues.FileLeafRef
                RelativeURL = $ListItem.FieldValues.FileRef
                Len=$ListItem.FieldValues.FileRef.Length
                ForLayr=$count
                Type =  $ListItem.FileSystemObjectType
                CreatedBy =  $ListItem.FieldValues.Author.Email
                CreatedOn = $ListItem.FieldValues.Created
                ModifiedBy =  $ListItem.FieldValues.Editor.Email
                ModifiedOn = $ListItem.FieldValues.Modified
                FileSize = $ListItem.FieldValues.File_x0020_Size
            })
            $DataCollection += $Data
            }
        }
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
    }While($Query.ListItemCollectionPosition -ne $null)

    $DataCollection | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Encoding UTF8

    $stringTest = "/sites/sbs_hr/CompIT/Накази кадрові/Матдопомога (накази, заяви)"

    $pattern = "/"
    $count = [regex]::matches($stringTest, $pattern).count

    $DataSort = $DataCollection | Where-Object {$_.ForLayr -eq 4}#{ $_.RelativeURL -like '*Documents/Документы/Проект А*' } 

    foreach($item in $DataSort)
    {
       $item.Name
       $DataLay2 = $DataCollection | Where-Object -FilterScript {($_.ForLayr -eq 5) -and ( $_.RelativeURL -like '*$item.RelativeURL*') }

       foreach($item1 in $DataLay2)
    {
      Write-Host $item1.Name -ForegroundColor Green
    }
    }


     ForEach($folderStaff in $foldersStaff)
            {
                Write-Host  $folderStaff.Name -ForegroundColor Cyan
    $row = $table.NewRow()
$row[“layer 1”] = $folderStaff.Name 
$table.rows.Add($row)
                
               if (-not([string]::IsNullOrEmpty($folderStaff.ArrSubFolders)))
                {
                  Write-Host $folderStaff.ArrSubFolders -ForegroundColor Red

                  $arr= Get-Variable $folderStaff.ArrSubFolders
                  ForEach($fSubFolder in $arr.Value)
                  {
                       Write-Host $fSubFolder.Name-ForegroundColor White
                           $row = $table.NewRow()
$row[“layer 2”] = $fSubFolder.Name 
$table.rows.Add($row)
                  }
                }

            }

    $row = $table.NewRow()
$row[“layer 1”] = “RandomStringData1”
$row[“layer 3”] = "RandomStringData3"
$table.rows.Add($row)

$table | Export-Csv -Path $CSVPathF -Force -NoTypeInformation -Encoding UTF8

