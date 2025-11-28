#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)

#region Create arr
$arr_ComunicationSite = @(
    "https://smartholdingcom.sharepoint.com/sites/it_standard-communication"
    "https://smartholdingcom.sharepoint.com/sites/it_brand-central"
    "https://smartholdingcom.sharepoint.com/sites/it_new-employee-onboarding"
    "https://smartholdingcom.sharepoint.com/sites/it_showcase"
    "https://smartholdingcom.sharepoint.com/sites/it_volunteer-center"
    "https://smartholdingcom.sharepoint.com/sites/it_organization-home"
    "https://smartholdingcom.sharepoint.com/sites/it_crisis-management"
    "https://smartholdingcom.sharepoint.com/sites/it_event"
    "https://smartholdingcom.sharepoint.com/sites/it_department"
    "https://smartholdingcom.sharepoint.com/sites/it_leadership-connection"
    "https://smartholdingcom.sharepoint.com/sites/it_human-resources"
    "https://smartholdingcom.sharepoint.com/sites/it_learning-central"

    "https://smartholdingcom.sharepoint.com/sites/it_demo_template"
)

$arr_UsersToAdd=@(
    "oleksandr.ivanchenko@it-capital.com.ua"
)
#endregion
 
Try
{
    foreach($SiteURL in $arr_ComunicationSite)
    {
        $SiteURL = "https://smartholdingcom.sharepoint.com/sites/it_demo_template"
        Write-Host $SiteURL -ForegroundColor Green
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Cred

        #Get all Groups
        $Groups=$Ctx.Web.SiteGroups
        $Ctx.Load($Groups)
        $Ctx.ExecuteQuery()

        $findVisitors  =  $Groups | Where-Object -Property Title -Like "*Visitors*"
         $findVisitors.Title

         $Group= $Ctx.Web.SiteGroups.GetByName("it_demo_template Visitors")
           $Ctx.Load($Group)
        $Ctx.ExecuteQuery()

        $Group.Id

        $gr=$Ctx.Web.AssociatedVisitorGroup
        $Ctx.Load($gr)
        $Ctx.ExecuteQuery()
        $gr.Title

        $webPerm=$Ctx.Web.RoleAssignments
        $Ctx.Load($webPerm)
        $Ctx.ExecuteQuery()

         $t=$webPerm[0].Member
         $Ctx.Load($t)
        $Ctx.ExecuteQuery()

        $oo = $webPerm | Where-Object -Property PrincipalId -EQ $Group.Id
        $Ctx.Load($oo.RoleDefinitionBindings)
        $Ctx.ExecuteQuery()
    }
    
    

}
Catch
{
  write-host -f Red "Error!" $_.Exception.Message
}

 

$arr_TeamSite = @(
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_standard-communication';internalName='it_standard-communication'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_brand-central';internalName='it_brand-central'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_new-employee-onboarding';internalName='it_new-employee-onboarding'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_showcase';internalName='Showcase template'}

    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_volunteer-centerр';internalName='it_standard-communication'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_brand-central';internalName='it_brand-central'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_new-employee-onboarding';internalName='it_new-employee-onboarding'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_showcase';internalName='Showcase template'}

    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_standard-communication';internalName='it_standard-communication'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_brand-central';internalName='it_brand-central'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_new-employee-onboarding';internalName='it_new-employee-onboarding'}
    [pscustomobject]@{UrlSite='https://smartholdingcom.sharepoint.com/sites/it_showcase';internalName='Showcase template'}
)

$arr_ComunicationSite = @(
    "https://smartholdingcom.sharepoint.com/sites/it_standard-communication"
    "https://smartholdingcom.sharepoint.com/sites/it_brand-central"
    "https://smartholdingcom.sharepoint.com/sites/it_new-employee-onboarding"
    "https://smartholdingcom.sharepoint.com/sites/it_showcase"
    "https://smartholdingcom.sharepoint.com/sites/it_volunteer-center"
    "https://smartholdingcom.sharepoint.com/sites/it_organization-home"
    "https://smartholdingcom.sharepoint.com/sites/it_crisis-management"
    "https://smartholdingcom.sharepoint.com/sites/it_event"
    "https://smartholdingcom.sharepoint.com/sites/it_department"
    "https://smartholdingcom.sharepoint.com/sites/it_leadership-connection"
    "https://smartholdingcom.sharepoint.com/sites/it_human-resources"
    "https://smartholdingcom.sharepoint.com/sites/it_learning-central"

    "https://smartholdingcom.sharepoint.com/sites/it_demo_template"
)

$arr_TeamSite = @(
    "https://smartholdingcom.sharepoint.com/sites/it_empl-onboarding"
    "https://smartholdingcom.sharepoint.com/sites/it_crisis-communication"
    "https://smartholdingcom.sharepoint.com/sites/it_new-employee-onboarding"
    "https://smartholdingcom.sharepoint.com/sites/it_showcase"
    "https://smartholdingcom.sharepoint.com/sites/it_volunteer-center"
    "https://smartholdingcom.sharepoint.com/sites/it_organization-home"
    "https://smartholdingcom.sharepoint.com/sites/it_crisis-management"
    "https://smartholdingcom.sharepoint.com/sites/it_event"
    "https://smartholdingcom.sharepoint.com/sites/it_department"
    "https://smartholdingcom.sharepoint.com/sites/it_leadership-connection"
    "https://smartholdingcom.sharepoint.com/sites/it_human-resources"
    "https://smartholdingcom.sharepoint.com/sites/it_learning-central"

    "https://smartholdingcom.sharepoint.com/sites/it_demo_template"
)