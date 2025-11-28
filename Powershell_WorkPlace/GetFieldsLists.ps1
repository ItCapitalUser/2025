#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
#function to Get all fields from a SharePoint Online list or library
Function Get-SPOListFields()
{
    param
    (
        [Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $ListName
    )
 
    Try {
       
 
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
         
        #Get the List
        $List = $Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.Load($List.Fields)
        $Ctx.ExecuteQuery()
         
        #Array to hold result
        $FieldData = @()
        $FieldCustomData = @()
        #Iterate through each field in the list
        Foreach ($Field in $List.Fields)
        {  
            Write-Host $Field.Title `t $Field.Description `t $Field.InternalName `t $Field.Id `t $Field.TypeDisplayName

            [xml]$xmlAttr= $Field.SchemaXml 
 
            #Send Data to object array
            $FieldData += New-Object PSObject -Property @{
                    'Field Title' = $Field.Title
                    'Field Description' = $Field.Description
                    'Field ID' = $Field.Id
                    'Internal Name' = $Field.InternalName
                    'Type' = $Field.TypeDisplayName
                    'Schema' = $Field.SchemaXML
                    }
            if((($Field.ReadOnlyField -eq $False) -or ($xmlAttr.Field.Type -like "Calculated") ) -and ($Field.Hidden -eq $False) -and ($xmlAttr.Field.SourceID -ne "http://schemas.microsoft.com/sharepoint/v3")) 
                {
                    $FieldCustomData += New-Object PSObject -Property @{
                            'Field Title' = $Field.Title
                            'Field Description' = $Field.Description
                            'Field ID' = $Field.Id
                            'Internal Name' = $Field.InternalName
                            'Type' = $Field.TypeDisplayName
                            'Schema' = $Field.SchemaXML
                            }
                    }
        }
        Return $FieldData, $FieldCustomData
    }
    Catch {
        write-host -f Red "Error Getting Fields from List!" $_.Exception.Message
    }
}
 
#Set parameter values
$SiteURL="https://smartholdingcom.sharepoint.com/sites/wem"
$ListName="Projects"
$CSVFolderLocation ="C:\Temp\wem\"#.csv"


Try
{
   $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
   $Ctx.Credentials = $Credentials 

   #Get the Lists
   $AllLists = $Ctx.Web.Lists
   $Ctx.Load($AllLists)
   $Ctx.ExecuteQuery()
   
   $SelectCustomList =$AllLists | Where  {($_.Hidden -EQ $False ) -and ($_.IsCatalog  -EQ $False) -and (($_.BaseTemplate -EQ 100) -or ($_.BaseTemplate -EQ 101)) -and ($_.EntityTypeName -notin  ("SiteAssets", "FormServerTemplates", "Shared_x0020_Documents")) } | select -Property Title, Itemcount, BaseTemplate, Created, Hidden, IsSiteAssetsLibrary, IsCatalog, EntityTypeName #| Format-Table
    #| Select-Object -Property * ($_.EntityTypeName -notmatch  "SiteAssets") | Where  {($_.BaseTemplate -EQ 100) -or ($_.BaseTemplate -EQ 101) }  

    foreach($ElList in $SelectCustomList)
    {
        $CSVLocation = $CSVFolderLocation+$ElList.EntityTypeName + "_AllFields.csv"
        $CSVLocation_CustomF = $CSVFolderLocation+$ElList.EntityTypeName + ".csv"
        $ListName = $ElList.Title

        $returneDataAboutFields= Get-SPOListFields -SiteURL $SiteURL -ListName $ListName 
        $AllFields = $returneDataAboutFields[0];
        $CustomFields = $returneDataAboutFields[1];
        $AllFields | Export-Csv $CSVLocation -NoTypeInformation -Encoding UTF8
        $CustomFields | Export-Csv $CSVLocation_CustomF -NoTypeInformation -Encoding UTF8
    }
   
}
catch
{
    Write-Host -f Red "Error connect to site ot get lists"
}

 
#Call the function to get all list fields
Get-SPOListFields -SiteURL $SiteURL -ListName $ListName | Export-Csv $CSVLocation -NoTypeInformation

