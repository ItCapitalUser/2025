

$SiteURL= "https://smartholdingcom-my.sharepoint.com/personal/i_superson_veres_com_ua"

 $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
      
$Lists = $Ctx.Web.Lists
        $Ctx.Load($Lists)
        $Ctx.ExecuteQuery()
$Lists |  Select -Property Title, BaseType

foreach($List in $Lists)
{
            #Get the List
            $List = $Ctx.Web.Lists.GetByTitle($List.Title)
            $Ctx.Load($List)
            $Ctx.ExecuteQuery()
            $Ctx.Load($List.RootFolder)
            $Ctx.ExecuteQuery()

            Write-Host "List $($List.Title) total  items: $($List.ItemCount) "
                        Write-Host "-----   $($List.RootFolder.ServerRelativeUrl) " -f Green
                         Write-Host "       "

}