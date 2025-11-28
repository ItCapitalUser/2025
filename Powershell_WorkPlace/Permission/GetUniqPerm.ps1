Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Define Parameter values
$SiteURL="https://smartholdingcom.sharepoint.com/sites/testEmptySite"# "https://smartholdingcom.sharepoint.com/sites/sbs_hr"
$ListName= "testJPG" #"Кадровий облік" #"testJPG"#"CheckPerm"
  
Try {
    #Setup Credentials to connect
    $Cred= Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
  
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials

    $Lists = $Ctx.Web.Lists
        $Ctx.Load($Lists)
        $Ctx.ExecuteQuery()

        $Lists | select Title
          
    #Get All Lists of the web
    $List = $Ctx.Web.Lists.GetByTitle($ListName)
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()
    Write-host "Total List Items Found:"$List.ItemCount

    $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())

    $CAMLQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
    $ListItems = $List.GetItems($CAMLQuery)
    $Ctx.Load($ListItems)

$Ctx.Load($ListItems)
$Ctx.ExecuteQuery() 
 
    #Query to Get 2000 items from the list
    $Query = New-Object Microsoft.SharePoint.Client.CamlQuery
    $Query.ViewXml = "<View Scope='RecursiveAll'><RowLimit>2000</RowLimit></View>"
  
    #Batch process list items - to mitigate list threshold issue on larger lists
    Do {  
        $ListItems = $List.GetItems($Query)
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery()
 
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
   
        #Loop through each List item
        ForEach($ListItem in $ListItems)
        {
            $ListItem.Retrieve("HasUniqueRoleAssignments")
            $Ctx.ExecuteQuery()
            if ($ListItem.HasUniqueRoleAssignments -eq $true)
            {        
                Write-Host -f Green "List Item '$($ListItem["Title"])' with ID '$($ListItem.ID)' has Unique Permissions"

                $Ctx.Load($ListItem.RoleAssignments)
                $Ctx.ExecuteQuery()

                Foreach($RoleAssignment in $ListItem.RoleAssignments)
                { 
                    $Ctx.Load($RoleAssignment.Member)
                    $Ctx.executeQuery()
                  
                    #Get the Permissions on the given object
                    $Permissions=@()
                    $Ctx.Load($RoleAssignment.RoleDefinitionBindings)
                    $Ctx.ExecuteQuery()
                    Foreach ($RoleDefinition in $RoleAssignment.RoleDefinitionBindings)
                    {
                        $Permissions += $RoleDefinition.Name +";"
                    }

                    Write-Host $RoleAssignment.Member.LoginName+" "+$Permissions
  
                    
            }
  
            }
            else
            {
                Write-Host -f Yellow "List Item '$($ListItem["Title"])' with ID '$($ListItem.ID)' is inhering Permissions from the Parent"
            }
        }
    } While ($Query.ListItemCollectionPosition -ne $null)
  
}
Catch {
    write-host -f Red "Error Checking Unique Permissions!" $_.Exception.Message
}