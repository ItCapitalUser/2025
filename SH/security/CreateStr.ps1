#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/SH_SEC_024"
$LoginName ="spsitecoladm@smart-holding.com"
$LoginPassword ="uZ#RJpSS2%U9!PR"

#region
$arrayGroupBuss=@(
        [pscustomobject]@{Url='SHUaGr';Eng='SMART HOLDING Group'}
        [pscustomobject]@{Url='SEUaGr';Eng='SMART ENERGY GROUP'}
        [pscustomobject]@{Url='VeresGr';Eng='VERES GROUP'}
        [pscustomobject]@{Url='REGr';Eng='REAL ESTATE Group'}
        [pscustomobject]@{Url='NavSmgGr';Eng='NAVAL_SMG Groups'}
        [pscustomobject]@{Url='IfSGr';Eng='IF SMART GROUP'}

)

$arrayGroupFolder=@(
        [pscustomobject]@{idBlock='1'; Ukr='ФІЗИЧНА БЕЗПЕКА';Eng='PHYSICAL SECURITY'; arrayFolder='arrayPhysSec'}
        [pscustomobject]@{idBlock='2';Ukr='ЕКОНОМІЧНА БЕЗПЕКА';Eng='ECONOMIC SECURITY'; arrayFolder='arrayEconSec'}
        [pscustomobject]@{idBlock='3';Ukr='ВЗАЄМОДІЯ З ПРАВООХОРОНИМИ ТА КОНТРОЛЮЧИМИ ОРГАНАМИ';Eng='GR'; arrayFolder='arrayGR'}
        [pscustomobject]@{idBlock='4';Ukr='КОРПОРАТИВНІ РОЗСЛІДУВАННЯ';Eng='CORPORATE INVESTIGATIONS'; arrayFolder='arrayCorpInv'}
        [pscustomobject]@{idBlock='5';Ukr='АНАЛІТИКА ТА ЗВІТИ';Eng='ANALYTICS AND REPORTS'; arrayFolder='arrayAR'}
        [pscustomobject]@{idBlock='6';Ukr='ПРОЕКТНА ДІЯЛЬНІСТЬ';Eng='PROJECT ACTIVITIES'; arrayFolder='arrayPrjAct' }
        [pscustomobject]@{idBlock='7';Ukr='АНТИКРИЗОВА ДІЯЛЬНІСТЬ';Eng='ANTI-CRISIS ACTIVITY'; arrayFolder='arrayACrsAct'}

)

$arrayPhysSec=@(
        [pscustomobject]@{idF='1';Ukr='ДОГОВОРИ ТА БЮДЖЕТИ ВИТРАТ';Eng='CONTRACTS AND COST BUDGETS'}
        [pscustomobject]@{idF='2';Ukr='УПРАВЛІННЯ РИЗИКАМИ';Eng='RISK MANAGEMENT'}
        [pscustomobject]@{idF='3';Ukr='ІНЦИДЕНТИ';Eng='INCIDENTS'}
        [pscustomobject]@{idF='4';Ukr='МАТЕРІАЛИ ПЕРЕВІРОК';Eng='CONTROLLING'}
        [pscustomobject]@{idF='5';Ukr='РЕГЛАМЕНТУЮЧІ ТА НОРМАТИВНІ ДОКУМЕНТИ';Eng='REGULATORY AND NORMATIVE DOCUMENTS'}
        [pscustomobject]@{idF='6';Ukr='ІНШЕ';Eng='OTHER'}

)

$arrayEconSec=@(
        [pscustomobject]@{idF='1';Ukr='ДОГОВОРИ';Eng='CONTRACTS'}
        [pscustomobject]@{idF='2';Ukr='БЮДЖЕТИ ВИТРАТ';Eng='SPENDING BUDGETS'}
        [pscustomobject]@{idF='3';Ukr='ЗАКУПІВЛІ ТА ПРОДАЖІ';Eng='PROCUREMENT AND SALES'}
        [pscustomobject]@{idF='4';Ukr='РОБОТА З ОСНОВНИМИ ЗАСОБАМИ';Eng='WORK WITH MAIN ASSETS'}
        [pscustomobject]@{idF='5';Ukr='КОНТРАГЕНТИ';Eng='COUNTERPARTIES'}
        [pscustomobject]@{idF='6';Ukr='КАНДИДАТИ';Eng='CANDIDATES'}
        [pscustomobject]@{idF='7';Ukr='СПІВРОБІТНИКИ';Eng='EMPLOYEES'}
        [pscustomobject]@{idF='8';Ukr='УПРАВЛІННЯ РИЗИКАМИ';Eng='RISK MANAGEMENT'}
        [pscustomobject]@{idF='9';Ukr='РЕГЛАМЕНТУЮЧІ ТА НОРМАТИВНІ ДОКУМЕНТИ';Eng='REGULATORY AND NORMATIVE DOCUMENTS'}
        [pscustomobject]@{idF='10';Ukr='МАТЕРІАЛИ ПЕРЕВІРОК';Eng='CONTROLLING'}
        [pscustomobject]@{idF='11';Ukr='ІНШЕ';Eng='OTHER'}

)

$arrayGR=@(
        [pscustomobject]@{idF='1';Ukr='ЗАПИТИ ТА ЗВЕРНЕННЯ';Eng='REQUESTS AND APPEALS'}        
        [pscustomobject]@{idF='2';Ukr='РЕГЛАМЕНТУЮЧІ ТА НОРМАТИВНІ ДОКУМЕНТИ';Eng='REGULATORY AND NORMATIVE DOCUMENTS'}
        [pscustomobject]@{idF='3';Ukr='ІНШЕ';Eng='OTHER'}

)

$arrayCorpInv=@(
        [pscustomobject]@{idF='1';Ukr='МАТЕРІАЛИ КОРПОРАТИВНИХ РОЗСЛІДУВАНЬ';Eng='MATERIALS OF CORPORATE INVESTIGATIONS'}
        [pscustomobject]@{idF='2';Ukr='ПРИЙНЯТІ ЗАХОДИ ТА ЗАХОДИ РЕАГУВАННЯ';Eng='MEASURES TAKEN AND RESPONSES'}
        [pscustomobject]@{idF='3';Ukr='РЕГЛАМЕНТУЮЧІ ТА НОРМАТИВНІ ДОКУМЕНТИ';Eng='REGULATORY AND NORMATIVE DOCUMENTS'}
        [pscustomobject]@{idF='4';Ukr='ІНШЕ';Eng='OTHER'}
)

$arrayAR=@(
        [pscustomobject]@{idF='1';Ukr='АНАЛІТИЧНІ МАТЕРІАЛИ ТА ДОВІДКИ';Eng='ANALYTICAL MATERIALS AND REFERENCES'}
        [pscustomobject]@{idF='2';Ukr='ЗВІТИ';Eng='REPORTS'}
        [pscustomobject]@{idF='3';Ukr='ІНШЕ';Eng='OTHER'}
)

$arrayPrjAct=@(
        [pscustomobject]@{idF='1';Ukr='КРІ';Eng='KPI'}
        [pscustomobject]@{idF='2';Ukr='ПРОЕКТНА ДІЯЛЬНІСТЬ';Eng='PROJECT ACTIVITIES'}
        [pscustomobject]@{idF='3';Ukr='ДОВІДКОВА ІНФОРМАЦІЯ';Eng='BACKGROUND INFORMATION'}
        [pscustomobject]@{idF='4';Ukr='ІНШЕ';Eng='OTHER'}
)

$arrayACrsAct=@(
        [pscustomobject]@{idF='1';Ukr='ЗАХОДИ ДЛЯ ВПРОВАДЖЕННЯ';Eng='MEASURES FOR IMPLEMENTATION '}
        [pscustomobject]@{idF='2';Ukr='УПРАВЛІННЯ РИЗИКАМИ';Eng='RISK MANAGEMENT'}
        [pscustomobject]@{idF='3';Ukr='РЕГЛАМЕНТУЮЧІ ТА НОРМАТИВНІ ДОКУМЕНТИ';Eng='REGULATORY AND NORMATIVE DOCUMENTS'}
        [pscustomobject]@{idF='4';Ukr='ІНШЕ';Eng='OTHER'}
)

#endregion

 
#Get the Client Context
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
 
#supply Login Credentials
$SecurePWD = ConvertTo-SecureString $LoginPassword -asplaintext -force 
$Credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($LoginName,$SecurePWD)
$Context.Credentials = $Credential


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

try{

     foreach($DocLib in $arrayGroupBuss)
    {
        Write-Host "Start create Doc. lib " $DocLib.Eng

        Create-DocumentLibrary  -DocLibraryName $DocLib.Eng -DocLibraryUrl $DocLib.Url -Ctx $Context
    }

     foreach($DocLib in $arrayGroupBuss)
    {
        foreach($FolderFirst in $arrayGroupFolder)
        {
            $urlFolder = $DocLib.Url+"/" + $FolderFirst.Ukr
            Write-Host "Start create Folder  " $urlFolder
            $Folder=$Context.Web.Folders.Add($urlFolder)
            $Context.ExecuteQuery()

            $arrSecondF= Get-Variable $FolderFirst.arrayFolder

            foreach($FolderSecond in $arrSecondF.Value)
            {
           
                $urlFolderSecond = $urlFolder +"/"+ $FolderSecond.Ukr
                Write-Host $urlFolderSecond  -f Magenta
                $Folder=$Context.Web.Folders.Add($urlFolderSecond)
                $Context.ExecuteQuery()
            }
        }
    }

  

}
catch
{
    Write-Host -f Red "Exception in main block"  $_.Exception.Message
}

