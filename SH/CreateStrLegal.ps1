#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/SH_TOP_426"
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
        [pscustomobject]@{Ua='Загально-правова робота';Eng='GenLW'}
        [pscustomobject]@{Ua='Договірна робота';Eng='ContrW'}
        [pscustomobject]@{Ua='Корпоративна робота';Eng='CrpW'}
        [pscustomobject]@{Ua='Судова робота';Eng='JudW'}
        [pscustomobject]@{Ua='Кримінально-правова робота';Eng='CrimnW'}

)


$arrayGroupBuss=@(
        [pscustomobject]@{Eng='SMART HOLDING Group'; arrayFolder='arrayGrCompSH'}
       <# [pscustomobject]@{Eng='SMART ENERGY Group'; arrayFolder='arrayGrCompSE'}
        [pscustomobject]@{Eng='VERES Group'; arrayFolder='arrayGrCompVeres'}
        #[pscustomobject]@{Eng='REAL ESTATE Group (SH)'; arrayFolder='arrayGrCompREsh'}
        #[pscustomobject]@{Eng='REAL ESTATE Group (SI)'; arrayFolder='arrayGrCompREsi'}
        <#[pscustomobject]@{Eng='REAL ESTATE Group'; arrayFolder='arrayGrCompREsh'}

        [pscustomobject]@{Eng='SMART MARITIME Group'; arrayFolder='arrayGrCompSMG'}
        [pscustomobject]@{Eng='INDUSTRIAL PARK Group'; arrayFolder='arrayGrCompIndP'}#>
        [pscustomobject]@{Eng='IF SMART Group'; arrayFolder='arrayGrCompIFS'}
       <# [pscustomobject]@{Eng='SMART INVESTMENTS  Group'; arrayFolder='arrayGrCompSI'}
        [pscustomobject]@{Eng='TRUSTS PROPERTY'; arrayFolder='arrayGrCompSmTrast'}#>

)

$arrayGrCompSE=@(
        [pscustomobject]@{Eng='SMART ENERGY LLC  (UKR)'; EngN = 'SMART ENERGY LLC'; UrlG="No"}
        [pscustomobject]@{Eng='UKRGAZVYDOBUTOK  PRAT (UKR)'; EngN = 'UKRGAZVYDOBUTOK  PRAT'; UrlG="No"}
        [pscustomobject]@{Eng='REPRESENTATIVE REGAL PETROLEUM (UKR)'; EngN ='REPRESENTATIVE REGAL PETROLEUM'; UrlG="No"}
        [pscustomobject]@{Eng='REGAL PETROLEUM CORPORATION (UKR.) LIMITED  LLC (UKR)'; EngN = 'REGAL PETROLEUM CORPORATION (UKRAINE) LIMITED LLC'; UrlG="No"}
        [pscustomobject]@{Eng='PROM-ENERHO PRODUKT LLC (UKR)'; EngN = 'PROM-ENERHO PRODUKT LLC'; UrlG="No" }
        [pscustomobject]@{Eng='ARKONA GAS-ENERGY LLC (UKR)'; EngN = 'ARKONA GAS-ENERGY LLC'; UrlG="No"}
        [pscustomobject]@{Eng='WELL INVESTUM LLC (UKR)'; EngN = 'WELL INVESTUM LLC'; UrlG="No"}
)

$arrayGrCompSMG=@(
        [pscustomobject]@{Eng='SMART MARITIME ACTIVE LLC (UKR)'; EngN = 'SMART-MARITIME ACTIVE LLC'; UrlG="No"}
        [pscustomobject]@{Eng='SMART MARITIME GROUP LLC (UKR)'; EngN = 'SMART-MARITIME GROUP LLC'; UrlG="No"}
       
)

$arrayGrCompSH=@(
        [pscustomobject]@{Eng='SMART- HOLDING LLC (UKR)'; EngN = 'SMART-HOLDING LLC'; UrlG="No"}
        [pscustomobject]@{Eng='IT CAPITAL LLC (UKR)'; EngN = 'IT CAPITAL LLC'; UrlG="No"}
        [pscustomobject]@{Eng='SMART BUSINESS SERVICE LLC (UKR)'; EngN = 'SMART BUSINESS SERVICE LLC'; UrlG="No"}
        [pscustomobject]@{Eng='PODIL 2000 LLC (UKR)'; EngN = 'PODIL 2000 LLC'; UrlG="No"}
        #[pscustomobject]@{Eng='SMART CORPORATE SERVICE REPRESENTATIVE (UKR)'}
        [pscustomobject]@{Eng='MBF Na chest Pokrovy Presvatoi Bogorodytsi (UKR)'; EngN = 'MBF Na chest Pokrovy Presvatoi Bogorodytsi'; UrlG="No"}
)

$arrayGrCompSH=@(
        [pscustomobject]@{Eng='KHARKIVOBLENERGO JSC'; EngN = ''; UrlG=""}
        [pscustomobject]@{Eng='HARVEST HOLDING LLC'; EngN = ''; UrlG=""}
        [pscustomobject]@{Eng='PROM MINERALS LLC'; EngN = ''; UrlG=""}
        [pscustomobject]@{Eng='FINLINE LTD LLC'; EngN = ''; UrlG=""}
        
)

$arrayGrCompVeres=@(
        [pscustomobject]@{Eng='VG TRADE LLC (UKR)'; EngN = 'VG TRADE LLC'; UrlG="No"}
        [pscustomobject]@{Eng='VG FARMING LLC (UKR)'; EngN = 'VG FARMING LLC'; UrlG="No"}
        [pscustomobject]@{Eng='VG AGRO LLC (UKR)'; EngN = 'VG AGRO LLC'; UrlG="No"}
        [pscustomobject]@{Eng='VG PRODUCTION LLC (UKR)'; EngN = 'VG PRODUCTION LLC'; UrlG="No"}
        [pscustomobject]@{Eng='INVEST 2018  LLC (UKR)'; EngN = 'INVEST 2018 LLC'; UrlG="No" }
        [pscustomobject]@{Eng='KORSUN LOGISTICS LLC (UKR)'; EngN = 'KORSUN LOGISTICS LLC'; UrlG="No"}
        [pscustomobject]@{Eng='PONOMAR LLC (UKR)'; EngN = 'PONOMAR LLC'; UrlG="No"}
)

$arrayGrCompIFS=@(
        [pscustomobject]@{Eng='INVESTMENT FUND SMART LLC (UKR)'; EngN = 'INVESTMENT FUND SMART LLC'; UrlG="No"}
        [pscustomobject]@{Eng='SMART GRANITE LLC (UKR)'; EngN = 'SMART GRANITE LLC'; UrlG="No"}
        [pscustomobject]@{Eng='SOTON LLC (UKR)'; EngN = 'SOTON LLC'; UrlG="No"}
        [pscustomobject]@{Eng='SMART VYDOBUTOK LLC (UKR)'; EngN = 'SMART VYDOBUTOK LLC'; UrlG="No" }
        [pscustomobject]@{Eng='FESTLAND LLC (UKR)'; EngN = 'FESTLAND LLC'; UrlG="No"}
        [pscustomobject]@{Eng='MODUS CAPITAL LLC (UKR)'; EngN = 'MODUS CAPITAL LLC'; UrlG="No"}
        [pscustomobject]@{Eng='ACUS LLC (UKR)'; EngN = 'ACUS LLC'; UrlG="No"}
        [pscustomobject]@{Eng='MEZHREGIONALNAYA PELETNAYA COMPANY LLC (UKR)'; EngN = 'INTERREGIONAL PELLET COMPANY LLC'; UrlG="No"}
)

$arrayGrCompIFS=@(
        [pscustomobject]@{Eng='CHUMATSKY WAY LLC'; EngN = ''; UrlG="No"}
        [pscustomobject]@{Eng='INTER ACTIVE LLC'; EngN = ''; UrlG="No"}
        
)

$arrayGrCompIndP=@(
        [pscustomobject]@{Eng='NAVAL LOGISTIC LLC (UKR)'; EngN = 'NAVAL LOGISTIK LLC'; UrlG="No"}
        [pscustomobject]@{Eng='NAVAL PARK LLC (UKR)'; EngN = 'NAVAL PARK LLC'; UrlG="No"}
        [pscustomobject]@{Eng='OCHAKIV PARK LLC (UKR)'; EngN = 'OCHAKIV PARK LLC'; UrlG="No"}
        [pscustomobject]@{Eng='PORT OCHAKOV LLC (UKR)'; EngN = 'PORT OCHAKOV LLC'; UrlG="No"}

)

$arrayGrCompSI=@(
        [pscustomobject]@{Eng='SMART LEASING LLC (UKR)'; EngN = 'SMART-LEASING LLC'; UrlG="SMART HOLDING Group"}
        [pscustomobject]@{Eng='SMART-EXPERT UKRAINE  LLC (UKR)'; EngN = 'SMART-EXPERT UKRAINE LLC'; UrlG="SMART HOLDING Group"}
        [pscustomobject]@{Eng='NAVY LLC (UKR)'; EngN = 'NAVY LLC'; UrlG="IF SMART Group" }
        [pscustomobject]@{Eng='AZOV PETROLIUM LLC (UKR)'; EngN = 'AZOV PETROLEUM LLC'; UrlG="SMART ENERGY Group"}

)

$arrayGrCompREsh=@(
        [pscustomobject]@{Eng='SMART URBAN SOLUTIONS LLC (UKR)'; EngN = 'SMART URBAN SOLUTIONS LLC'; UrlG="No"}
        [pscustomobject]@{Eng='SEDVERS LLC (UKR)'; EngN = 'SEDVERS LLC'; UrlG="No"}
        [pscustomobject]@{Eng='TROITSKIY PLAZA LLC (UKR)'; EngN = 'TROITSKIY PLAZA LLC'; UrlG="No"}
        [pscustomobject]@{Eng='POWER BUILD  DEVELOPMENT LLC (UKR)'; EngN = 'POWER BUILD DEVELOPMENT LLC'; UrlG="No"}
        [pscustomobject]@{Eng='EUGENE LLC (UKR)'; EngN = 'EUGENE LLC'; UrlG="No"}
        [pscustomobject]@{Eng='PRODHIM-INDUSTRIYA LLC (UKR)'; EngN = 'PRODHIM-INDUSTRIYA LLC'; UrlG="No"}
        [pscustomobject]@{Eng='KOLUMBUS LLC (UKR)'; EngN = 'KOLUMBUS LLC'; UrlG="No"}
        [pscustomobject]@{Eng='BS PROPERTY LLC (UKR)'; EngN = 'BS PROPERTY LLC'; UrlG="No"}
        [pscustomobject]@{Eng='POLITRADE COMPANY LLC (UKR)'; EngN = 'POLITRADE COMPANY LLC'; UrlG="SMART HOLDING Group"}
        [pscustomobject]@{Eng='EAST SOLUTION GROUP LLC (UKR)'; EngN = 'EAST SOLUTION GROUP LLC'; UrlG="No"}
        [pscustomobject]@{Eng='URBAN ACTIVITY LLC (UKR)'; EngN = 'URBAN ACTIVITY LLC'; UrlG="No"}
        [pscustomobject]@{Eng='MADERA DEVELOPMENT LLC (UKR)'; EngN = 'MADERA DEVELOPMENT LLC'; UrlG="No"}
)

$arrayGrCompREsi=@(
        [pscustomobject]@{Eng='KOLUMBUS LLC (UKR)'; EngN = 'KOLUMBUS LLC'}
        [pscustomobject]@{Eng='BS PROPERTY LLC (UKR)'; EngN = 'BS PROPERTY LLC'}
        [pscustomobject]@{Eng='POLITRADE COMPANY LLC (UKR)'; EngN = 'POLITRADE COMPANY LLC'}
        [pscustomobject]@{Eng='EAST SOLUTION GROUP LLC (UKR)'; EngN = 'EAST SOLUTION GROUP LLC'}
        [pscustomobject]@{Eng='URBAN ACTIVITY LLC (UKR)'; EngN = ' URBAN ACTIVITY LLC'}
        [pscustomobject]@{Eng='MADERA DEVELOPMENT LLC (UKR)'; EngN = 'MADERA DEVELOPMENT LLC'}
)

$arrayGrCompSmTrast=@(
        [pscustomobject]@{Eng='KEY PROPERTY LLC'}
        [pscustomobject]@{Eng='TFF SANTIS LLC'}
        [pscustomobject]@{Eng='LS PROPERTY LLC'}
        [pscustomobject]@{Eng='CHARITY ORGANIZATION LELEKA-SVIT'}
        [pscustomobject]@{Eng='AIRCRAFT GROUP LLC'}
)

$arrayFGenLW=@(
        [pscustomobject]@{NameF='Консультування з юридичних питань Бізнеса'}

)

$arrayFContrW=@(
        [pscustomobject]@{NameF='Перевірка та аналіз договорів'}
        [pscustomobject]@{NameF='Типові форми'}

)

$arrayFCrpW=@(
        [pscustomobject]@{NameF='Питання корпоративного законодавства'}
        [pscustomobject]@{NameF='Антимонопольний комплаєнс'}

)

$arrayFJudW=@(
        [pscustomobject]@{NameF='Юридичний захист у судових спорах'}
        [pscustomobject]@{NameF='Взаємодія з контролюючими органами'}

)
$arrayFCrimnW=@(
        [pscustomobject]@{NameF='Юридичний захист у судових спорах'}
        [pscustomobject]@{NameF='Взаємодія з правоохоронними органами'}

)

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

        Create-DocumentLibrary  -DocLibraryName "Проектна діяльність" -DocLibraryUrl "PrjW" -Ctx $Context
    }   

    foreach($DocLib in $arrayDocLib)
    {
        Write-Host $DocLib.Eng -f Yellow
        foreach($FolderFirst in $arrayGroupBuss)
        {
            $urlFolder = $DocLib.Eng+"/" + $FolderFirst.Eng
            Write-Host "Start create Folder  " $urlFolder
            $Folder=$Context.Web.Folders.Add($urlFolder)
            $Context.ExecuteQuery()

            $arrSecondF= Get-Variable $FolderFirst.arrayFolder

            foreach($FolderSecond in $arrSecondF.Value)
            {
           
                $urlFolderSecond = $urlFolder +"/"+ $FolderSecond.Eng
                Write-Host $urlFolderSecond  -f Magenta
                $Folder=$Context.Web.Folders.Add($urlFolderSecond)
                $Context.ExecuteQuery()
                $folderThird = $null

                switch ( $DocLib.Eng  )
                {
                    "GenLW" { $folderThird = 'arrayFGenLW'    }
                    "ContrW" { $folderThird = 'arrayFContrW'    }
                    "CrpW" { $folderThird = 'arrayFCrpW'    }
                    "JudW" { $folderThird = 'arrayFJudW'    }
                    "CrimnW" { $folderThird = 'arrayFCrimnW'   }

                }

                $arrThirdF= Get-Variable $folderThird
                foreach($FolderThird in $arrThirdF.Value)
                {
                    $urlFolderThird = $urlFolderSecond +"/"+ $FolderThird.NameF
                    Write-Host $urlFolderThird  -f Green

                    $Folder=$Context.Web.Folders.Add($urlFolderThird)
                    $Context.ExecuteQuery()

                }
           
            }
        }
    }

     $urlFolderCompany = "CrpW/INDUSTRIAL PARK Group"

    foreach($folderFirstL in $arrayGrCompIndP)
    {
        $urlFolder =  $urlFolderCompany +"/" + $folderFirstL.Eng
        Write-Host "Start create Folder  " $urlFolder

        $Folder=$Context.Web.Folders.Add($urlFolder)
        $Context.ExecuteQuery()

          foreach($FolderThird in $arrayFCommon)
                {
                    $urlFolderThird = $urlFolder +"/"+ $FolderThird.NameF
                    Write-Host $urlFolderThird  -f Green

                    $Folder=$Context.Web.Folders.Add($urlFolderThird)
                    $Context.ExecuteQuery()

                }
    }

}
catch
{
    Write-Host -f Red "Exception in main block"  $_.Exception.Message
}

#set permission
try{
    

    $arrGroup = @("Головнй юрисконсульт", "Радник з кримінально-правового захисту", "Радники з юридичних питань", "Юрисконсульти")


    $PermissionToAdd="Contribute"


    $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Context.Credentials = $Credentials
    $Web = $Context.web

     foreach($FolderFirst in $arrayGroupBuss)
     {     
        $urlFolder = "/sites/SH_TOP_426/"+"CrimnW"+"/" + $FolderFirst.Eng
        Write-Host $urlFolder

        $Folder = $Web.GetFolderByServerRelativeUrl($urlFolder)
        $Context.Load($Folder)
        $Context.ExecuteQuery()

        #Break Permission inheritence of the folder - Keep all existing folder permissions & keep Item level permissions
        $Folder.ListItemAllFields.BreakRoleInheritance($True,$True)
        $Context.ExecuteQuery()
        Write-host -f Yellow "Folder's Permission inheritance broken..."

        Foreach($GroupName in $arrGroup)
        {
            Write-Host $GroupName

            $Group = $Context.Web.SiteGroups.GetByName($GroupName)
 
         #Get Permission Levels to add and remove
            $RoleDefToAdd = $Context.web.RoleDefinitions.GetByName($PermissionToAdd)
         
         #Get the Group's role assignment on the web
            $RoleAssignment =  $Folder.ListItemAllFields.RoleAssignments.GetByPrincipal($Group)

            $Folder.ListItemAllFields.RoleAssignments.GetByPrincipal($Group).DeleteObject()
            $Context.ExecuteQuery() 

            $Role = $web.RoleDefinitions.GetByName($PermissionToAdd)
            $RoleDB = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Context)
            $RoleDB.Add($Role)

            $Folder.ListItemAllFields.RoleAssignments.Add($Group,$RoleDB)
            $Context.ExecuteQuery()
            Write-Host "--------  End ---------"

        }

     }

     #region test set perm
         $FolderURL="/sites/SH_TOP_426/GenLW/IF%20SMART%20Group" #Or /sites/Marketing/Project Documents/Active - Server Relative URL of the Folder!
             $GroupName="Юрисконсульти"

    $Folder = $Web.GetFolderByServerRelativeUrl($FolderURL)
    $Context.Load($Folder)
    $Context.ExecuteQuery()
     
    #Break Permission inheritence of the folder - Keep all existing folder permissions & keep Item level permissions
    $Folder.ListItemAllFields.BreakRoleInheritance($True,$True)
    $Context.ExecuteQuery()
    Write-host -f Yellow "Folder's Permission inheritance broken..."


     #Get the Folder object by Server Relative URL
     $Folder = $Web.GetFolderByServerRelativeUrl($FolderURL)
     $Context.Load($Folder)
     $Context.ExecuteQuery()
    
     $Group = $Context.Web.SiteGroups.GetByName($GroupName)
 
     #Get Permission Levels to add and remove
     $RoleDefToAdd = $Context.web.RoleDefinitions.GetByName($PermissionToAdd)
     $RoleDefToRemove = $Context.web.RoleDefinitions.GetByName($PermissionToRemove)
         
     #Get the Group's role assignment on the web
     $RoleAssignment =  $Folder.ListItemAllFields.RoleAssignments.GetByPrincipal($Group)

     $Folder.ListItemAllFields.RoleAssignments.GetByPrincipal($Group).DeleteObject()
     $Context.ExecuteQuery() 

     $Role = $web.RoleDefinitions.GetByName($PermissionToAdd)
    $RoleDB = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Context)
    $RoleDB.Add($Role)

     $Folder.ListItemAllFields.RoleAssignments.Add($Group,$RoleDB)
     $Context.ExecuteQuery() 

         
     #Add/remove permission levels to the role assignment
     $RoleAssignment.RoleDefinitionBindings.Add($RoleDefToAdd)
     $RoleAssignment.RoleDefinitionBindings.Remove($RoleDefToRemove)
     $RoleAssignment.Update()
     $Context.ExecuteQuery() 
     #endregion
}
catch
{
}

#region Update name Folder 
$DocLibUrl = "CrimnW"
foreach($FolderFirst in $arrayGroupBuss)
{
    $urlFolderGroupBussOrg = $DocLibUrl+"/" + $FolderFirst.Eng
    Write-Host "Start create Folder  " $urlFolderGroupBuss
            
    $arrSecondF= Get-Variable $FolderFirst.arrayFolder

    foreach($FolderSecond in $arrSecondF.Value)
    {
        Write-Host $FolderSecond.UrlG  -f White
        $urlFolderCompanyOld = $urlFolderGroupBussOrg +"/"+ $FolderSecond.Eng

        if($FolderSecond.UrlG -like "No")
        {
            $urlFolderGroupBuss = $DocLibUrl+"/" + $FolderFirst.Eng

        }
        else
        {
            $urlFolderGroupBuss = $DocLibUrl+"/" + $FolderSecond.UrlG 
        }

        $urlFolderCompanyNew = $urlFolderGroupBuss+"/"+ $FolderSecond.EngN
        Write-Host $urlFolderCompanyOld "-> " $urlFolderCompanyNew  -f Magenta

       $Folder = $Context.Web.GetFolderByServerRelativeUrl($urlFolderCompanyOld)
        $Context.Load($Folder)
        $Context.ExecuteQuery()
     
        #Rename Folder
        $Folder.MoveTo($urlFolderCompanyNew)
        $Context.ExecuteQuery()
    }
}

#endregion