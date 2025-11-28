#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/sh_ua_hr"
$LoginName ="spsitecoladm@smart-holding.com"
$LoginPassword ="uZ#RJpSS2%U9!PR"
 
#Get the Client Context
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
 
#supply Login Credentials
$SecurePWD = ConvertTo-SecureString $LoginPassword -asplaintext -force 
$Credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($LoginName,$SecurePWD)
$Context.Credentials = $Credential

#region 
$arrayDocLib=@(
        [pscustomobject]@{Ua='Орг структури та чисельність';Eng='Orgstr'}
        [pscustomobject]@{Ua='HR Бюджети';Eng='Budget'}
        [pscustomobject]@{Ua='Заробітна плата';Eng='Wage'}
        [pscustomobject]@{Ua='Преміювання';Eng='Bonus'}
        [pscustomobject]@{Ua='Соціальна Політика';Eng='SocPolicy'}
        [pscustomobject]@{Ua='Матеріали HR Комітету';Eng='HrCmte'}

        [pscustomobject]@{Ua='Навчання та розвиток персоналу';Eng='TrgPers'}
        [pscustomobject]@{Ua='Звільнення персоналу';Eng='DisPers'}
        [pscustomobject]@{Ua='Звіти за запитами';Eng='RepReq'}
        [pscustomobject]@{Ua='Інше';Eng='Other'}
        [pscustomobject]@{Ua='Матеріали по проєктам';Eng='Projects'}
        [pscustomobject]@{Ua='Колективні договори';Eng='CLA'}
        [pscustomobject]@{Ua='Бронювання';Eng='MilBooking'}

)



$arrayGroupBuss=@(
        [pscustomobject]@{Eng='SMART HOLDING Group'}
        [pscustomobject]@{Eng='SMART ENERGY Group'}
        [pscustomobject]@{Eng='VERES Group'}
        [pscustomobject]@{Eng='REAL ESTATE Group'}
        [pscustomobject]@{Eng='SMART MARITIME Group'}
        [pscustomobject]@{Eng='INDUSTRIAL PARK Group'}
        [pscustomobject]@{Eng='IF SMART Group'}
       
)

$arrayFOrgStr=@(
        [pscustomobject]@{NameF='Орг структури'}
        [pscustomobject]@{NameF='Звіти з чисельності'}

)

$arrayFBudg=@(
        [pscustomobject]@{NameF='Бюджети'}
        [pscustomobject]@{NameF='Матеріали на аудиторський Комітет'}

)

$arrayFWage=@(
        [pscustomobject]@{NameF='Перегляд зп, точкові підвищення'}
        [pscustomobject]@{NameF='Матеріали на аудиторський Комітет'}
        [pscustomobject]@{NameF='Штатний розпис'}

)

$arrayFWageBusn=@(
        [pscustomobject]@{NameF='Перегляд зп, точкові підвищення'}
        [pscustomobject]@{NameF='Регламенти з оплати праці'}
        

)

$arrayFBonus=@(
        [pscustomobject]@{NameF='KPI'}
        [pscustomobject]@{NameF='Системи преміювання. Регламенти'}
        [pscustomobject]@{NameF='Річні бонуси'}

)

$arrayFSocPolicy=@(
        [pscustomobject]@{NameF='Регламенти з надання допомоги'}


)
#endregion

#region 04.07.25
$arrayDocLib=@(
        [pscustomobject]@{Ua='SMART HOLDING Group';Eng='SHUa'}
        [pscustomobject]@{Ua='SMART ENERGY Group';Eng='SE'}
        [pscustomobject]@{Ua='VERES Group';Eng='Veres'}
        [pscustomobject]@{Ua='REAL ESTATE Group';Eng='RE'}
        [pscustomobject]@{Ua='SMART MARITIME Group';Eng='SMG'}
        [pscustomobject]@{Ua='INDUSTRIAL PARK Group';Eng='IP'}
        [pscustomobject]@{Ua='IF SMART Group';Eng='IFS'}

)

$arrayFFirst=@(
    [pscustomobject]@{nameF='Орг структури'}
    [pscustomobject]@{nameF='Звіти з чисельності'}
    [pscustomobject]@{nameF='HR Бюджети'}
    [pscustomobject]@{nameF='Матеріали на аудиторський Комітет'}
    #[pscustomobject]@{nameF='Управління корпоративною культурою'}
    [pscustomobject]@{nameF='Колективні договори'}
    <#[pscustomobject]@{nameF='Бронювання'}
    [pscustomobject]@{nameF='Базова винагорода'}
    [pscustomobject]@{nameF='Змінна винагорода'}
    [pscustomobject]@{nameF='Контракти'}
    [pscustomobject]@{nameF='Управління пільгами'}
    [pscustomobject]@{nameF='Звільнення персоналу'}
    [pscustomobject]@{nameF='Звіти за запитами'}#>
    
)

$arrayFWage=@(
        [pscustomobject]@{NameF='Перегляд зп, точкові підвищення'}
        [pscustomobject]@{NameF='Матеріали на аудиторський Комітет'}
        [pscustomobject]@{NameF='Штатний розпис'}

)

$arrayFBonus=@(
        [pscustomobject]@{NameF='KPI'}
        [pscustomobject]@{NameF='Системи преміювання  Регламенти'}
        [pscustomobject]@{NameF='Річні бонуси'}


)

$arrayFContracts=@(
        [pscustomobject]@{NameF='База HR контрактів'}
        [pscustomobject]@{NameF='Контракти директорів'}
)

$arrayFBenefits=@(
        [pscustomobject]@{NameF='Регламенти з надання допомоги'}
        [pscustomobject]@{NameF='Ліміти та види допомоги по Холдингу'}
        [pscustomobject]@{NameF='Медичне страхування'}
        [pscustomobject]@{NameF='Заяви на матеріальну допомогу'}

)

$arrayFBenefitsBusn=@(
        [pscustomobject]@{NameF='Регламенти з надання допомоги'}
        

)

$arrayFDismissal=@(
        [pscustomobject]@{NameF='Анкети exit-інтервю'}
        [pscustomobject]@{NameF='Угоди про припинення трудових відносин'}
        [pscustomobject]@{NameF='Передача справ від звільнених'}
        

)

#endregion

#region

#endregion

Function Create-DocumentLibrary()
{
    param
    (
        #[Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $DocLibraryName,
        [Parameter(Mandatory=$true)] [string] $DocLibraryUrl,
        [Parameter(Mandatory=$true)] [Microsoft.SharePoint.Client.ClientRuntimeContext]$Ctx

    )    
    Try {

    #Set up the context
    <#$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL) 
    $Ctx.Credentials = $Credential#>
 
    #Get All Lists from the web
    $Lists = $Ctx.Web.Lists
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()
  
    #Check if Library name doesn't exists already and create document library
    if(!($Lists.Title -contains $DocLibraryName))
    { 
        #create document library in sharepoint online powershell
        $ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
        $ListInfo.Title = $DocLibraryName
        $ListInfo.Url=$DocLibraryUrl
        $ListInfo.TemplateType = 101 #Document Library
        $List = $Ctx.Web.Lists.Add($ListInfo)
        $List.Update()
        $Ctx.ExecuteQuery()

        $List =  $Ctx.Web.Lists.GetByTitle($DocLibraryName);
        $List.OnQuickLaunch = 1;
        $List.Update()
        $Ctx.ExecuteQuery()
    
        write-host  -f Green "New Document Library  $DocLibraryName  has been created!"
    }
    else
    {
        Write-Host -f Yellow "List or Library '$DocLibraryName' already exist!"
    }
}
Catch {
    write-host -f Red "Error Creating Document Library!" $_.Exception.Message
}
}


Try
{

    foreach($DocLib in $arrayDocLib)
    {
        Write-Host "Start create Doc. lib " $DocLib.Ua

        Create-DocumentLibrary  -DocLibraryName "Trusts Property-УОУЕД" -DocLibraryUrl "TrustsPr" -Ctx $Context
    }

    $urlFolder = "SHUa"+"/"+ "SMART HOLDING"
    Write-Host "Start create Folder  " $urlFolder
    $Folder=$Context.Web.Folders.Add($urlFolder)
    $Context.ExecuteQuery()

    $urlFolder = "SHUa"+"/"+ "SMART BUSINESS SERVICE"
    Write-Host "Start create Folder  " $urlFolder
    $Folder=$Context.Web.Folders.Add($urlFolder)
    $Context.ExecuteQuery()

    $web=$Context.Web;
    $Context.Load($web)
    $Context.ExecuteQuery()

    $NameB= "TrustsPr"

    foreach($folderFirstL in $arrayFFirst)
    {
        $urlFolder = $NameB +"/"+ $folderFirstL.NameF #"SHUa/SMART BUSINESS SERVICE"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.Load($Folder)
        $Context.ExecuteQuery()
    }

    

    foreach($folderF in $arrayFWageBusn)
    {
        $urlFolder = $NameB +"/Базова винагорода/"+ $folderF.NameF #"SHUa/SMART BUSINESS SERVICE"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()
    }

    foreach($folderF in $arrayFBonus)
    {
        $urlFolder = $NameB +"/Змінна винагорода/"+ $folderF.NameF #"SHUa/SMART BUSINESS SERVICE"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()
    }

    foreach($folderF in $arrayFContracts)
    {
        $urlFolder = $NameB +"/Контракти/"+ $folderF.NameF #"SHUa/SMART BUSINESS SERVICE"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()
    }

    foreach($folderF in $arrayFBenefitsBusn)
    {
        $urlFolder = $NameB +"/Управління пільгами/"+ $folderF.NameF #"SHUa/SMART BUSINESS SERVICE"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()
    }

    foreach($folderF in $arrayFDismissal)
    {
        $urlFolder = $NameB +"/Звільнення персоналу/"+ $folderF.NameF #"SHUa/SMART BUSINESS SERVICE"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()
    }

    foreach($folderOrgStr in $arrayGroupBuss)
    {

        $urlFolder = "SHUa"+"/"+ "SMART HOLDING"
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()


      <# foreach($folder in $arrayFSocPolicy)
        {
            $urlFolderSecondL = $urlFolder+"/"+ $folder.NameF
            Write-Host "Start create Folder " $urlFolderSecondL -f Yellow

            $Folder1=$Context.Web.Folders.Add($urlFolderSecondL)
            $Context.ExecuteQuery()

        }#>
    }

}
catch
{
    Write-Host -f Red "Exception in main block"  $_.Exception.Message
}