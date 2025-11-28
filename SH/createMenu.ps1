

    $Title = "SMART HOLDING Group"
     $ParentNode  = $QuickLaunch | Where-Object {$_.Title -eq $Title}

     $Context.Load($ParentNode)
        $Context.Load($ParentNode.Children)
        $Context.ExecuteQuery()

            $TitleFistL = "Фізична безпека"
     $NodeSecond  = $ParentNode.Children | Where-Object {$_.Title -eq $TitleFistL}


     $NavigationNode = New-Object Microsoft.SharePoint.Client.NavigationNodeCreationInformation
$NavigationNode.Title = "Support Center1"
$NavigationNode.Url = "SmgGr/ПРОЕКТНА ДІЯЛЬНІСТЬ/КРІ"
$NavigationNode.AsLastNode = $True
$Context.Load($NodeSecond.Children.Add($NavigationNode))
$Context.ExecuteQuery() 

$yu= $NodeSecond.Children | Where-Object {$_.Title -eq $TitleFistL}

$Context.Load($ParentNode)
        $Context.Load($ParentNode.Children)
        $Context.ExecuteQuery()

$NavigationNode = New-Object Microsoft.SharePoint.Client.NavigationNodeCreationInformation
$NavigationNode.Title = "Support Center1"
$NavigationNode.Url = "https://support.crescent.com"
$NavigationNode.AsLastNode = $True
$Ctx.Load($QuickLaunch.Add($NavigationNode))
$Ctx.ExecuteQuery() 


$QuickLaunch = $Context.Web.Navigation.QuickLaunch
$Context.load($QuickLaunch)
$Context.ExecuteQuery()

 foreach($DocLib in $arrayGroupBuss)
{
   $Title = $DocLib.Eng
   $ParentNode  = $QuickLaunch | Where-Object {$_.Title -eq $Title}

   $Context.Load($ParentNode)
   $Context.Load($ParentNode.Children)
   $Context.ExecuteQuery()

    foreach($FolderFirst in $arrayGroupFolder)
    {
            $urlFolder = $DocLib.Url+"/" + $FolderFirst.Ukr
            Write-Host "Start node for Folder  " $urlFolder
            #$Folder=$Context.Web.Folders.Add($urlFolder)
            #$Context.ExecuteQuery()

            $NavigationNode = New-Object Microsoft.SharePoint.Client.NavigationNodeCreationInformation
            $NavigationNode.Title = $FolderFirst.Ukr
            $NavigationNode.Url = $urlFolder
            $NavigationNode.AsLastNode = $True
            $Context.Load($ParentNode.Children.Add($NavigationNode))
            $Context.ExecuteQuery()
            
            $NodeSecondLevel  = $ParentNode.Children | Where-Object {$_.Title -eq $FolderFirst.Ukr}
 

            $arrSecondF= Get-Variable $FolderFirst.arrayFolder

            foreach($FolderSecond in $arrSecondF.Value)
            {
           
                $urlFolderSecond = $urlFolder +"/"+ $FolderSecond.Ukr
                Write-Host $urlFolderSecond  -f Magenta
               # $Folder=$Context.Web.Folders.Add($urlFolderSecond)
               # $Context.ExecuteQuery()

                $NavigationNodeThirdL = New-Object Microsoft.SharePoint.Client.NavigationNodeCreationInformation
                $NavigationNodeThirdL.Title = $FolderSecond.Ukr
                $NavigationNodeThirdL.Url = $urlFolderSecond
                $NavigationNodeThirdL.AsLastNode = $True
                $Context.Load($NodeSecondLevel.Children.Add($NavigationNodeThirdL))
                $Context.ExecuteQuery() 
            }
        }
    }

  