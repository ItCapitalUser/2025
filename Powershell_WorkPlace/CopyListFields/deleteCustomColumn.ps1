#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
$ListName= "Study290224_1"
$ColumnName="Project Code" #Display Name of the column
 
Try {
    #Get Credentials to connect
    $Cred = Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
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
    #Iterate through each field in the list
    Foreach ($Field in $List.Fields)
      {   
            [xml]$xmlAttr= $Field.SchemaXml 
            if(($Field.ReadOnlyField -eq $False) -and ($Field.Hidden -eq $False) -and ($xmlAttr.Field.SourceID -ne "http://schemas.microsoft.com/sharepoint/v3")) 
                {            
                Write-Host $Field.Title `t $Field.Description `t $Field.InternalName `t $Field.Id `t $Field.TypeDisplayName


 
            #Send Data to object array
           $FieldData += New-Object PSObject -Property @{
                    'FieldTitle' = $Field.Title
                    'FieldDescription' = $Field.Description
                    'FieldID' = $Field.Id 
                    'Internal Name' = $Field.InternalName
                    'Type' = $Field.TypeDisplayName
                    'Schema' = $Field.SchemaXML
                    }
                    }
       }

    Foreach($FieldSource in $FieldData)
    {
        $ColumnName= $FieldSource.FieldTitle
        #Get the Column to delete
        $Column = $List.Fields.GetByTitle($ColumnName)
     
        #sharepoint online delete list column powershell
        $Column.DeleteObject()
        $Ctx.ExecuteQuery() 
         
        Write-host "Column '$ColumnName' deleted Successfully!" -ForegroundColor Green

    }
 
    
 
 }
Catch {
    write-host -f Red "Error Deleting Column from List!" $_.Exception.Message
}