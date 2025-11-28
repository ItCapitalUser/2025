#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Variables for Processing
$SiteURL="https://crescent.sharepoint.com"
$ListName= "Study290224_1"
$ColumnName="Number1" #Display Name of the column
 
Try {
    #Get Credentials to connect
    <#$Cred = Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials#>
 
    #Get the List
    $List = $Ctx.Web.Lists.GetByTitle($ListName)
 
    #Get the Column to delete
    $Column = $List.Fields.GetByTitle($ColumnName)
     
    #sharepoint online delete list column powershell
    $Column.DeleteObject()
    $Ctx.ExecuteQuery()
 
    Write-host "Column '$ColumnName' deleted Successfully!" -ForegroundColor Green
 }
Catch {
    write-host -f Red "Error Deleting Column from List!" $_.Exception.Message
}