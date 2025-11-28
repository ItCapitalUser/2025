$SiteURL = "https://smartholdingcom.sharepoint.com/sites/ChornaTest"
$ListName ="Audits parameters"
$ListURL = "Lists/auditsParameters"

$Cred = Get-Credential

Connect-PnPOnline –Url $SiteURL –Credentials $Cred

Add-PnPSiteCollectionAdmin -Owners "spsitecoladm@smart-holding.com"

New-PnPList -Title $ListName -Url $ListURL -Template GenericList
Add-PnPTaxonomyField -List $ListName -DisplayName "OwnerCompany" -InternalName "OwnerCompany" -TermSetPath "CustomParameters|Company" -AddToDefaultView 
Add-PnPTaxonomyField -List $ListName -DisplayName "OwnerDepartment" -InternalName "OwnerDepartment" -TermSetPath "CustomParameters|Company" -AddToDefaultView
Add-PnPTaxonomyField -List $ListName -DisplayName "TypeSite" -InternalName "TypeSite" -TermSetPath "CustomParameters|TypeSites" -AddToDefaultView
$field =Add-PnPField -List $ListName -Type User -DisplayName "Owner" -InternalName "Owner" -AddToDefaultView
Set-PnPField -List $ListName -Identity $field.Id -Values @{"SelectionMode"=0}

 Add-PnPTaxonomyField -List $ListName -DisplayName "UsersCompanies" -InternalName "UsersCompanies" -TermSetPath "CustomParameters|Company" -AddToDefaultView -MultiValue
 $field = Add-PnPField -List $ListName -Type Boolean -DisplayName "CentralSite" -InternalName "CentralSite" -AddToDefaultView 
 $field.DefaultValue = "0"
$field.Update()
Invoke-PnPQuery

 $field = Add-PnPField -List $ListName -Type Boolean -DisplayName "InHub" -InternalName "InHub" -AddToDefaultView 
  $field.DefaultValue = "0"
$field.Update()
Invoke-PnPQuery

Add-PnPField -List $ListName -Type Text -DisplayName "BusinessApp" -InternalName "BusinessApp" -AddToDefaultView 
Add-PnPField -List $ListName -Type Text -DisplayName "NumberITIL" -InternalName "NumberITIL" -AddToDefaultView 

$field = Add-PnPField -List $ListName -Type Boolean -DisplayName "Archive" -InternalName "Archive" -AddToDefaultView 
  $field.DefaultValue = "0"
$field.Update()
Invoke-PnPQuery

$list = Get-PnPList $ListName
$list.BreakRoleInheritance($true, $true)
$list.Update()
$list.Context.Load($list)
$list.Context.ExecuteQuery()

$list = Get-PnPList $ListName
$cpt = $list.RoleAssignments.Count - 1;
for ($i = $cpt; $i -ge 0; $i--)
{
    $list.RoleAssignments.Remove($i);
}

