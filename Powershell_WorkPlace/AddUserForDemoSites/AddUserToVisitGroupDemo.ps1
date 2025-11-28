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

$arr_TeamSite = @(
    "https://smartholdingcom.sharepoint.com/sites/it_empl-onboarding"
    "https://smartholdingcom.sharepoint.com/sites/it_crisis-communication"
    "https://smartholdingcom.sharepoint.com/sites/it_training-design-team"
    "https://smartholdingcom.sharepoint.com/sites/it_retail-management-team"
    "https://smartholdingcom.sharepoint.com/sites/it_training-course"

    "https://smartholdingcom.sharepoint.com/sites/it_event-planning"
    "https://smartholdingcom.sharepoint.com/sites/it_help-desk"
    "https://smartholdingcom.sharepoint.com/sites/it_store-collaboration"
    "https://smartholdingcom.sharepoint.com/sites/it_project-management"

)

$arr_forAudit = @(
    "https://smartholdingcom.sharepoint.com/sites/SBS_PO_280"
    "https://smartholdingcom.sharepoint.com/sites/SBS_IT_283"
    "https://smartholdingcom.sharepoint.com/sites/SBS_PM_384"
    "https://smartholdingcom.sharepoint.com/sites/SBS_IT_202"


)

$arr_fordemo = @(
    "https://smartholdingcom.sharepoint.com/sites/sh_compl_main_demo"
    "https://smartholdingcom.sharepoint.com/sites/sh_compl_demo"
    "https://smartholdingcom.sharepoint.com/sites/smg_compl_demo"
    "https://smartholdingcom.sharepoint.com/sites/ss_compl_demo"
)

$arr_UsersToAdd=@(
    "yevhen.shevchenko@smart-holding.com"
    #"nataliia.zahirniak@smart-holding.com"
   # "elena.nusinova@smart-holding.com"

)
#endregion
 
Try
{
    foreach($SiteURL in $arr_TeamSite )
    {
        #$SiteURL = "https://smartholdingcom.sharepoint.com/sites/it_demo_template"
        Write-Host $SiteURL -ForegroundColor Green
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Cred

        #Get all Groups
        $Groups=$Ctx.Web.SiteGroups
        $Ctx.Load($Groups)
        $Ctx.ExecuteQuery()

        $findVisitorsG  =  $Groups | Where-Object -Property Title -Like "*Visitors*"
        $findVisitorsG.Title

         $Group= $Ctx.Web.SiteGroups.GetByName($findVisitorsG.Title)
           $Ctx.Load($Group)
        $Ctx.ExecuteQuery()

        $Group.Id

       <# $gr=$Ctx.Web.AssociatedVisitorGroup
        $Ctx.Load($gr)
        $Ctx.ExecuteQuery()
        $gr.Title#>

        #region Get 
       <# $webPerm=$Ctx.Web.RoleAssignments
        $Ctx.Load($webPerm)
        $Ctx.ExecuteQuery()


        $oo = $webPerm | Where-Object -Property PrincipalId -EQ $Group.Id
        $Ctx.Load($oo.RoleDefinitionBindings)
        $Ctx.ExecuteQuery()#>

         foreach($emailUser in $arr_UsersToAdd)
         {
            Write-Host "add $($emailUser)"
              #ensure user sharepoint online powershell - Resolve the User
            $User=$Ctx.Web.EnsureUser($emailUser)
 
            #Add user to the group
            $Result = $Group.Users.AddUser($User)
            $Ctx.Load($Result)
            $Ctx.ExecuteQuery()

        }
    Write-Host "----"
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