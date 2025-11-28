Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
      
#Config Parameters
$SiteURL= "https://smartholdingcom-my.sharepoint.com/personal/andrey_romaniv_ifsmart_com_ua"
$ListName = "Test1"
$CSVPath = "C:\Temp\DocumentLibraryRpt6.csv"
$BatchSize = 500

  
#Get Credentials to connect
$Cred = Get-Credential

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

$DataList = @()
Do
    {
        Write-Host "-----"
        #get List items
        $ListItems = $List.GetItems($Query) 
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery() 
 


        $DataList += $ListItems
        $iii=$ListItems[$ListItems.Count-1].FieldValues.FileLeafRef
        Write-Host $ListItems.Count -f Red
        Write-Host  $iii -f Green
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition

    }While($Query.ListItemCollectionPosition -ne $null)


   $yu= $DataList | Select-Object -ExpandProperty FieldValues 

    $yu | Select -ExpandProperty FileRef 

    foreach($elem in $yu)
    {
        Write-Host 
    }

    $ui= $yu.GetEnumerator() | Select-Object -ExpandProperty FileRef
    # | Measure-Object

     $ui | Select

     $yu[3]
     $DataList[3]

$DataCollFromMemory = @()
$startD = Get-Date -Format G

  ForEach($ListItem in $DataList )
        {
        
            Write-Host -f Yellow $ListItem.FieldValues.FileRef

            #Collect data        
            $Data = New-Object PSObject -Property ([Ordered] @{
                IdF=$ListItem.FieldValues.ID
                Name  = $ListItem.FieldValues.FileLeafRef
                TypeFile= $ListItem.FieldValues.File_x0020_Type  
                RelativeURL = $ListItem.FieldValues.FileRef
                Len=$ListItem.FieldValues.FileRef.Length
                Type =  $ListItem.FileSystemObjectType
                CreatedBy =  $ListItem.FieldValues.Author.Email
                CreatedOn = $ListItem.FieldValues.Created
                ModifiedBy =  $ListItem.FieldValues.Editor.Email
                ModifiedOn = $ListItem.FieldValues.Modified
                FileSizeMB = [math]::Round($ListItem.FieldValues.File_x0020_Size /1MB,2)
            })
            $DataCollFromMemory += $Data
            }
            $endD = Get-Date -Format G

            $DataCollFromMemory1 = $DataCollFromMemory

            $diff= New-TimeSpan -Start $startD -End $endD

$diff.Minutes

    $DataCollFromMemory | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Encoding UTF8



$DataCollFromMemory | Measure-Object

 $DataSort | Group-Object -Property TypeFile -NoElement |  Sort-Object -Property Count -Descending

        $DataCollFromMemory | Group-Object -Property TypeFile -NoElement |  Sort-Object -Property Count -Descending
