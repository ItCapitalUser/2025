#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 

$SiteURL = "https://smartholdingcom-my.sharepoint.com/personal/t_semenova_veres_com_ua"

#Get Credentials to connect
$Cred = Get-Credential
 

$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)


  $Lists = $Ctx.Web.Lists
        $Ctx.Load($Lists)
        $Ctx.ExecuteQuery()

        $Lists | Select -Property Title, Hidden

        $ListCollection = @()
        ForEach($List in $Lists)
{
    $ListData = New-Object -TypeName PSObject
    $ListData | Add-Member -MemberType NoteProperty -Name "Title" -Value $List.Title
    $ListData | Add-Member -MemberType NoteProperty -Name "Itemcount" -Value $List.Itemcount
    $ListData | Add-Member -MemberType NoteProperty -Name "BaseTemplate" -Value $List.BaseTemplate
    $ListData | Add-Member -MemberType NoteProperty -Name "Created" -Value $List.Created
    $ListData | Add-Member -MemberType NoteProperty -Name "Hidden" -Value $List.Hidden
    $ListData | Add-Member -MemberType NoteProperty -Name "IsApplicationList" -Value $List.IsApplicationList
    $ListData | Add-Member -MemberType NoteProperty -Name "IsCatalog" -Value $List.IsCatalog
    $ListData | Add-Member -MemberType NoteProperty -Name "IsSiteAssetLibrary" -Value $List.IsSiteAssetLibrary
    $ListData | Add-Member -MemberType NoteProperty -Name "IsSystemList" -Value $List.IsSystemList
    $ListCollection += $ListData
}

$ListCollection | Export-csv -Path "C:\Temp\list-inventory310524_2.csv" -NoTypeInformation -Encoding UTF8

$List = $Ctx.Web.lists.GetByTitle("Архивная библиотека")
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()

    $item = $List.GetItemById(1)
$Ctx.Load($item)
        $Ctx.ExecuteQuery()
         $item.DeleteObject()
        $Ctx.ExecuteQuery()
	
$date = Get-Date -Year 2023 -Month 1 -Day 1

 foreach($itemM in $DataSort)
{
    Write-Host $itemM.IdF
  $item = $List.GetItemById($itemM.IdF)
  $Ctx.Load($item)
  $Ctx.ExecuteQuery()
  $item.DeleteObject()
  $Ctx.ExecuteQuery()     
}

