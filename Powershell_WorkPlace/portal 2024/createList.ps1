#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/holding_portal_test"
$ListName="DMainPage"
 
#Get Credentials to connect
$Cred = Get-Credential
 
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)

#Create a  Directory for app in main page site
Try{    
    $ListCreationInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
    $ListCreationInfo.Title = $ListName
    $ListCreationInfo.TemplateType = 100
    $List = $Ctx.Web.Lists.Add($ListCreationInfo)
    $List.Description = "Directory of custom apps for the homepage"
    $List.Update()
    $Ctx.ExecuteQuery()
    Write-host "Create new list $($ListName)" -ForegroundColor Green 
}
Catch {
    write-host -f Red "Error in block Create List DMainPage:" $_.Exception.Message
}

Try{
    $FieldID = New-Guid

    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='GroupNewsletters' StaticName='GroupNewsletters' DisplayName='Group Newsletters' Description='Група AAD, для відправки листів підписаним користувачам' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""GroupNewsletters"" Added to the List Successfully!" -ForegroundColor Green 

    $FieldID = New-Guid
    
    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='GroupPermm' StaticName='GroupPermm' DisplayName='Group Permission' Description='Група SPO, для управління доступом до новин' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""GroupPermm"" Added to the List Successfully!" -ForegroundColor Green  
    
    $FieldID = New-Guid
    
    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='UrlPortal' StaticName='UrlPortal' DisplayName='Url Portal' Description='Url порталу компанії' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""UrlPortal"" Added to the List Successfully!" -ForegroundColor Green   

    $FieldID = New-Guid
    
    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='EmailServDesk' StaticName='EmailServDesk' DisplayName='Email Service Desk' Description='Email Service Desk' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""EmailServDesk"" Added to the List Successfully!" -ForegroundColor Green   

    $FieldID = New-Guid
    
    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='EmailDomain' StaticName='EmailDomain' DisplayName='Email Domain' Description='Email Domain компанії' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""EmailDomain"" Added to the List Successfully!" -ForegroundColor Green  
}
Catch {
    write-host -f Red "Error in block ""Create columns DMainPage"":" $_.Exception.Message
}

Try{
    $Field = $List.Fields.GetByInternalNameOrTitle("Title")
    $Field.Title = "Company"
    $Field.Update()
    $Ctx.ExecuteQuery()

    Write-host "Column Title rename" -ForegroundColor Green  

}
Catch {
    write-host -f Red "Error in block Update Title column DMainPage :" $_.Exception.Message
}

#Create a list "Newsletters Reason unsubscribing"
$ListName="Newsletters Reason unsubscribing"
$ListUrl = "NewsUnsubscr"
$ListDescription= "List of unsubscribes from news on the site"
Try{    
    $ListCreationInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
    $ListCreationInfo.Title = $ListName
    $ListCreationInfo.Url = $ListUrl
    $ListCreationInfo.TemplateType = 100
    $List = $Ctx.Web.Lists.Add($ListCreationInfo)
    $List.Description = $ListDescription
    $List.Update()
    $Ctx.ExecuteQuery()
    Write-host "Create new list $($ListName)" -ForegroundColor Green 
}
Catch {
    write-host -f Red "Error in block Create List $($ListName) :" $_.Exception.Message
}

Try{

    $FieldID = New-Guid

    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='FullName' StaticName='FullName' DisplayName='ПІБ' Description='ПІБ співробітника' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""FullName"" Added to the List $($ListName)  Successfully!" -ForegroundColor Green 

    $FieldID = New-Guid
    
    $FieldSchema = "<Field Type='Note' ID='{$FieldID}' DisplayName='Причина' Name='Reason' Description='Причина відписки від новини' NumLines='6' RichText='False' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""Reason"" Added to the List $($ListName) Successfully!" -ForegroundColor Green  
     
}
Catch {
    write-host -f Red "Error in block Create columns  $($ListName):" $_.Exception.Message
}

Try{
    $Field = $List.Fields.GetByInternalNameOrTitle("Title")
    $Field.Title = "Email"
    $Field.Update()
    $Ctx.ExecuteQuery()

    Write-host "Column Title rename" -ForegroundColor Green  

}
Catch {
    write-host -f Red "Error in block Update Title column $($ListName) :" $_.Exception.Message
}

#Create a list for save dev. error
$ListName="DevError"
$ListDescription= "List Errors"
Try{    
    $ListCreationInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
    $ListCreationInfo.Title = $ListName
    $ListCreationInfo.TemplateType = 100
    $List = $Ctx.Web.Lists.Add($ListCreationInfo)
    $List.Description = $ListDescription
    $List.Update()
    $Ctx.ExecuteQuery()
    Write-host "Create new list $($ListName)" -ForegroundColor Green 
}
Catch {
    write-host -f Red "Error in block Create List $($ListName) :" $_.Exception.Message
}

Try{

    $FieldID = New-Guid

    $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='NameEvent' StaticName='NameEvent' DisplayName='Name event' Description='Name fuction or procedure' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""NameEvent"" Added to the List $($ListName)  Successfully!" -ForegroundColor Green 

    $FieldID = New-Guid
    
    $FieldSchema = "<Field Type='Note' ID='{$FieldID}' DisplayName='Description' Name='Description' Description='Error message' NumLines='6' RichText='False' />"
    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()    
    Write-host "Column ""Description"" Added to the List $($ListName) Successfully!" -ForegroundColor Green  
     
}
Catch {
    write-host -f Red "Error in block Create columns  $($ListName):" $_.Exception.Message
}


