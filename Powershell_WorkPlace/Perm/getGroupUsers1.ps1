
	
#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Parameters
$SiteURL="https://smartholdingcom.sharepoint.com/sites/sbs_fs"
$CSVPath = "C:\Temp\UserInfo090524.csv"
 
#Get Credentials to connect
$Cred= Get-Credential
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
    #Get the User Information List
    $List=$Ctx.Web.SiteUserInfoList
    $FieldColl = $List.Fields
    $Ctx.Load($List)
    $Ctx.Load($FieldColl)
    $Ctx.ExecuteQuery()
  
    #Get All Items from User Information List
    $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
    $Ctx.Load($ListItems)
    $Ctx.ExecuteQuery()
 
    #Array to Hold Result - PSObjects
    $ListItemCollection = @()
   
    #Fetch each list item value to export to excel
    ForEach($Item in $ListItems)
    {
        $ExportItem = New-Object PSObject 
        ForEach($Field in $FieldColl)
        {
            $ExportItem | Add-Member -MemberType NoteProperty -name $Field.InternalName -value $Item[$Field.InternalName]   
        }  
        #Add the object with property to an Array
        $ListItemCollection += $ExportItem
    }
    #Export data to CSV File
    $ListItemCollection | Export-Csv -Path $CSVPath -NoTypeInformation -Force -Encoding UTF8
 
    Write-host "User Information List has been Exported to CSV!'" -f Green
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}