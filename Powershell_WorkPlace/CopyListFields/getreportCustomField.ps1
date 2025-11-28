Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#function to Get all fields from a SharePoint Online list or library
Function Get-SPOListFields()
{ 
    param
    (
        [Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $ListName
    )
 
    Try {
        #$Cred= Get-Credential
       # $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
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

            #Write-Host $xmlAttr.Field.Type -ForegroundColor Magenta

            if ((($Field.ReadOnlyField -eq $False) -or ($xmlAttr.Field.Type -like "Calculated") ) -and ($Field.Hidden -eq $False) -and ($xmlAttr.Field.SourceID -ne "http://schemas.microsoft.com/sharepoint/v3")) 
                {            
                Write-Host $Field.Title `t $Field.Description `t $Field.InternalName `t $Field.Id `t $Field.TypeDisplayName


 
            #Send Data to object array
           $FieldData += New-Object PSObject -Property @{
                    'Field Title' = $Field.Title
                    'Field Description' = $Field.Description
                    'Field ID' = $Field.Id 
                    'Internal Name' = $Field.InternalName
                    'Type' = $Field.TypeDisplayName
                    'Schema' = $Field.SchemaXML
                    }
                    }
        }
        Return $FieldData
    }
    Catch {
        write-host -f Red "Error Getting Fields from List!" $_.Exception.Message
    } 
} 
 
#Set parameter values
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
$ListName="exampleCol"
$CSVLocation ="C:\Temp\ListFields_230425.csv"
 
#Call the function to get all list fields
Get-SPOListFields -SiteURL $SiteURL -ListName $ListName | Export-Csv $CSVLocation -NoTypeInformation -Encoding UTF8

(($true -or $false) -and $false)
($false -or $true)