#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Variables for Processing
$SiteURL = "https://smartholdingcom.sharepoint.com/sites/testEmptySite"
$ListNameCopy="Study290224_1"
$ListNameSource="exampleCol"
 
#Setup Credentials to connect
$Cred = Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)

#region Add-SingleLineTextColumnToList
Function Add-SingleLineTextColumnToList()
{ 
    param
    (
        #[Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $ListName,
        [Parameter(Mandatory=$true)] [string] $Name,
        [Parameter(Mandatory=$true)] [string] $DisplayName,
        [Parameter(Mandatory=$false)] [string] $Description=[string]::Empty,
        [Parameter(Mandatory=$false)] [string] $IsRequired= "FALSE",        
        [Parameter(Mandatory=$false)] [string] $EnforceUniqueValues= "FALSE",
        [Parameter(Mandatory=$false)] [string] $MaxLength="255",
        [Parameter(Mandatory=$true)] [Microsoft.SharePoint.Client.ClientRuntimeContext]$Ctx
    )
 
    #Generate new GUID for Field ID
    $FieldID = New-Guid
 
    Try {
        
        #Setup the context
       <# $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials#>
         
        #Get the List
        $List = $Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()

        Write-host $ListName -ForegroundColor DarkMagenta

        #Check if the column exists in list already
        $Fields = $List.Fields
        $Ctx.Load($Fields)
        $Ctx.executeQuery()
        $NewField = $Fields | where { ($_.Internalname -eq $Name) -or ($_.Title -eq $DisplayName) }
        if($NewField -ne $NULL)  
        {
            Write-host "Column $Name already exists in the List!" -f Yellow
        }
        else
        {
            #Define XML for Field Schema
            $ui="False"
            $FieldSchema = "<Field Type='Text' ID='{$FieldID}' Name='$Name' StaticName='$Name' DisplayName='$DisplayName' Description='$Description' Required='$IsRequired'
             EnforceUniqueValues='$EnforceUniqueValues' MaxLength='$MaxLength'  Viewable='$EnforceUniqueValues'/>"
            $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
            $Ctx.ExecuteQuery()    
 
            Write-host "New Column Added to the List Successfully!" -ForegroundColor Green  
        }
    }
    Catch {
        write-host -f Red "Error Adding Column to List!" $_.Exception.Message
    }
} 
#endregion

#region Add-NumberColumnToList 
Function Add-NumberColumnToList()
{ 
    param
    (
        #[Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $ListName,
        [Parameter(Mandatory=$true)] [string] $Name,
        [Parameter(Mandatory=$true)] [string] $DisplayName,
        [Parameter(Mandatory=$false)] [string] $Description=[string]::Empty,
        [Parameter(Mandatory=$false)] [string] $IsRequired = "FALSE",
        [Parameter(Mandatory=$false)] [string] $EnforceUniqueValues = "FALSE",
        [Parameter(Mandatory=$false)] [string] $MinValue,
        [Parameter(Mandatory=$false)] [string] $MaxValue,
        [Parameter(Mandatory=$false)] [string] $DecimalsValue,
        [Parameter(Mandatory=$false)] [string] $PercentageValue,
        [Parameter(Mandatory=$true)] [Microsoft.SharePoint.Client.ClientRuntimeContext]$Ctx
    )
 
    #Generate new GUID for Field ID
    $FieldID = New-Guid
 
    Try {
        #Setup the context
        <#$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials#>
         
        #Get the List
        $List = $Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()

        Write-host "max $($MaxValue)"
        $xmlMax = ""
        if (!([string]::IsNullOrEmpty($MaxValue)))
        {
          Write-Host "Not Empty Max"
          $xmlMax = "Max='$($MaxValue)'"
        }

        Write-host "min $($MinValue)"
        $xmlMin = ""
        if (!([string]::IsNullOrEmpty($MinValue)))
        {
          Write-Host "Not Empty Min"
          $xmlMin = "Min='$($MinValue)'"
        }

        Write-host "Decimals $($DecimalsValue)"
        $xmlDecimals = ""
        if (!([string]::IsNullOrEmpty($DecimalsValue)))
        {
          Write-Host "Not Empty Decimals"
          $xmlDecimals = "Decimals='$($DecimalsValue)'"
        }

         Write-host "Percentage $($PercentageValue)"
        $xmlPercentage = ""
        if (!([string]::IsNullOrEmpty($PercentageValue)))
        {
          Write-Host "Not Empty Percentage"
          $xmlPercentage = "Percentage='$($PercentageValue)'"
        }
 
        #Check if the column exists in list already
        $Fields = $List.Fields
        $Ctx.Load($Fields)
        $Ctx.executeQuery()
        $NewField = $Fields | where { ($_.Internalname -eq $Name) -or ($_.Title -eq $DisplayName) }
        if($NewField -ne $NULL)  
        {
            Write-host "Column $Name already exists in the List!" -f Yellow
        }
        else
        {
            $FieldSchema = "<Field Type='Number' ID='{$FieldID}' DisplayName='$DisplayName' Name='$Name' Description='$Description' Required='$IsRequired' EnforceUniqueValues='$EnforceUniqueValues' $($xmlMax) $($xmlMin) $($xmlDecimals) $($xmlPercentage) />"
            $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
            $Ctx.ExecuteQuery()    
 
            Write-host "New Column Added to the List Successfully!" -ForegroundColor Green  
        }
        }
    Catch {
        write-host -f Red "Error Adding Column to List!" $_.Exception.Message
    }
}
#endregion 

#region Add-MultilineTextColumnToList
Function Add-MultilineTextColumnToList()
{ 
    param
    (
        #[Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $ListName,
        [Parameter(Mandatory=$true)] [string] $Name,
        [Parameter(Mandatory=$true)] [string] $DisplayName,
        [Parameter(Mandatory=$false)] [string] $Description=[string]::Empty,
        [Parameter(Mandatory=$false)] [string] $IsRequired = "FALSE",
        [Parameter(Mandatory=$false)] [string] $EnforceUniqueValues = "FALSE",
        [Parameter(Mandatory=$false)] [string] $IsRichText="FALSE",
        [Parameter(Mandatory=$false)] [string] $NumLines = "6",
        [Parameter(Mandatory=$false)] [string] $AppendOnly,
        [Parameter(Mandatory=$false)] [string] $RichTextMode,
        [Parameter(Mandatory=$true)] [Microsoft.SharePoint.Client.ClientRuntimeContext]$Ctx

    )
 
    #Generate new GUID for Field ID
    $FieldID = New-Guid
 
    Try {
        #region example
        <#$Cred= Get-Credential
        $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials#>
        #endregion
         
        #Get the List
        $List = $Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()
 
        #Check if the column exists in list already
        $Fields = $List.Fields
        $Ctx.Load($Fields)
        $Ctx.executeQuery()
        $NewField = $Fields | where { ($_.Internalname -eq $Name) -or ($_.Title -eq $DisplayName) }
        if($NewField -ne $NULL)  
        {
            Write-host "Column $Name already exists in the List!" -f Yellow
        }
        else
        {
            #Define XML for Field Schema
            if($EnhancedRichText -eq "TRUE") #Enhanced Rich Text Mode
            {
                $FieldSchema = "<Field Type='Note' ID='{$FieldID}' DisplayName='$DisplayName' Name='$Name' Description='$Description' Required='$IsRequired' NumLines='$NumLines' RichText='TRUE' RichTextMode='FullHtml' IsolateStyles='TRUE' />"
            }
            else  #Plain Text or Rich Text
            {
                $FieldSchema = "<Field Type='Note' ID='{$FieldID}' DisplayName='$DisplayName' Name='$Name' Description='$Description' Required='$IsRequired' NumLines='$NumLines' RichText='$IsRichText' />"
            }
             
            $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
            $Ctx.ExecuteQuery()    
 
            Write-host "New Column Added to the List Successfully!" -ForegroundColor Green  
        }
    }
    Catch {
        write-host -f Red "Error Adding Column to List!" $_.Exception.Message
    }
} 
#endregion

#region GetNumberFor Internal name
Function GetNumberForNameCol{
    Param (
    [string]$TempName
    #[Object[]]$FieldsList
    )
     Write-Host "Read fields new lists" 
     $ListNew = $Ctx.Web.Lists.GetByTitle($ListNameCopy)
     $Ctx.Load($ListNew)

     $Ctx.Load($ListNew.Fields)
     $Ctx.ExecuteQuery()

     Write-Host "Check fields"

     $number=0
     $selectFieldsMatch = $ListNew.Fields |Where-Object {($_.InternalName -match "$TempName*")} |Sort-Object InternalName -Descending

     Write-Host $selectFieldsMatch.InternalName -ForegroundColor Green
    
     if($selectFieldsMatch -ne $null)
        {
            Write-Host $selectFieldsMatch[0].InternalName 
            [int]$number = $selectFieldsMatch[0].InternalName -replace '\D'
            
        }
     $number++
     return $number
}
#endregion 
    #$ppp = GetNumberForNameCol -TempName "Number" -FieldsList $FieldDataSource
#region Add-ColumnToList
Function Add-ColumnToList()
{
    param
    (
        [Parameter(Mandatory=$true)] [string] $ListName,
        [Parameter(Mandatory=$true)] [string] $NameColumn,
        [Parameter(Mandatory=$true)] [string] $DisplayName,
        [Parameter(Mandatory=$true)] [string] $FieldSchema
    )

    
    Try
    {
        $CtxAdd_ColumnToList = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $CtxAdd_ColumnToList.Credentials = $Credentials
        Write-Host "1" 
        #Get the List
        $List = $CtxAdd_ColumnToList.Web.Lists.GetByTitle($ListName)
        $CtxAdd_ColumnToList.Load($List)
        $CtxAdd_ColumnToList.ExecuteQuery()
        Write-Host "2"

        #Check if the column exists in list already
        $Fields = $List.Fields
        $CtxAdd_ColumnToList.Load($Fields)
        $CtxAdd_ColumnToList.executeQuery()
        Write-Host "3"
        $NewField = $Fields | where { ($_.Internalname -eq $NameColumn) -or ($_.Title -eq $DisplayName) }
        if($NewField -ne $NULL)  
        {
            Write-host "Column $Name already exists in the List!" -f Yellow
        }
        else
        {
            Write-Host "4"
            $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
            $CtxAdd_ColumnToList.ExecuteQuery()    
 
            Write-host "New Column Added to the List Successfully!" -ForegroundColor Green  
        }
    }
    Catch{
        write-host -f Red "Error Adding Column to List!" $_.Exception.Message
    }
    Finally {
    # Disconnect SharePoint Online
    $CtxAdd_ColumnToList.Dispose()
    }
}
#endregion

 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
     
    #Get All Lists 
    $Lists = $Ctx.Web.Lists
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()

    $Lists | Select -Property Title
   
    $ListSource = $Ctx.Web.Lists.GetByTitle($ListNameSource)
    $Ctx.Load($ListSource)
    $Ctx.ExecuteQuery()

     $List = $Ctx.Web.Lists.GetByTitle($ListNameCopy)
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()
    
    $DateCurr=Get-Date -Format "ddMMyyyy"  
     
    #region Create List
    #Check if List doesn't exists already
    if(!($Lists.Title -contains $ListNameCopy))
    { 
        #sharepoint online powershell create list
        $ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
        $ListInfo.Title = $ListNameCopy
        $ListInfo.Url = $ListNameCopy
        $ListInfo.TemplateType = 100 #Custom List
        $List = $Ctx.Web.Lists.Add($ListInfo)
        $List.Description = "Copy list "+ $ListSource.Title+ $DateCurr
        $List.Update()
        $Ctx.ExecuteQuery()
  
        write-host  -f Green "New List '$ListNameCopy' has been created!"
    }
    else
    {
        Write-Host -f Yellow "List '$ListNameCopy' already exists!"
    }
    #endregion

    #region Read fields
    $Ctx.Load($ListSource.Fields)
    $Ctx.ExecuteQuery()
         
    #Array to hold result
    $FieldDataSource = @()
    #Iterate through each field in the list
    Foreach ($Field in $ListSource.Fields)
        {   
            [xml]$xmlAttr= $Field.SchemaXml 
            #Write-Host  $Field.Title  -ForegroundColor Magenta
            #$xmlAttr.Field.SourceID
            #Write-Host $xmlAttr.Field.SourceID -ForegroundColor Magenta

           <# if($xmlAttr.Field.SourceID -ne "http://schemas.microsoft.com/sharepoint/v3")
            {
                Write-Host $Field.Title  `t "Cust" -ForegroundColor Red
             }#>
           
            #Write-Host $Field.Title `t $Field.Description `t $Field.InternalName `t $Field.Id `t $Field.TypeDisplayName
             if((($Field.ReadOnlyField -eq $False) -or ($xmlAttr.Field.Type -like "Calculated") ) -and ($Field.Hidden -eq $False) -and ($xmlAttr.Field.SourceID -ne "http://schemas.microsoft.com/sharepoint/v3")) 
                {
                    Write-Host $Field.Title -ForegroundColor Yellow  #`t $Field.TypeAsString`t $Field.SchemaXml
                    
                    #Send Data to object array
                    $FieldDataSource += New-Object PSObject -Property @{
                            'FieldTitle' = $Field.Title
                            'FieldDescription' = $Field.Description
                            'FieldID' = $Field.Id 
                            'InternalName' = $Field.InternalName
                            'Type' = $Field.TypeDisplayName
                            'TypeString'= $Field.TypeAsString
                            'Schema' = $Field.SchemaXML
                            'SchemaXML' = [xml]$Field.SchemaXML
                            'Required' = $Field.Required 
                            'EnforceUniqueValues' = $Field.EnforceUniqueValues
                            }
                    }
    }
    #endregion

    <#$v="Number"   
    $FieldDataSource |Where-Object {($_.InternalName -match "$v*")} -Or ($_.FieldTitle -eq "Number2")}
    $number = $string -replace '\D'#>
    
    #region Create columm in new list
    Foreach($FieldSource in $FieldDataSource)
    {
        Write-Host $FieldSource.TypeString -ForegroundColor Red
        [xml]$xmlAttr= $FieldSource.SchemaXml

        #region Type Text
        if($FieldSource.TypeString -eq "Text")
        {
          $maxLengthS = $xmlAttr.Field.MaxLength
         
          #Write-Host "Internal: $($FieldSource.InternalName) Title: $($FieldSource.FieldTitle) Description: $($FieldSource.FieldDescription) Max: $($maxLength)"  -ForegroundColor DarkCyan

        <#  if ($FieldSource.InternalName -match "_x0")
           {
                 Write-Host "Go Create new name!" -ForegroundColor Red
                 $numberForColl = GetNumberForNameCol -TempName "Text" -FieldsList $FieldDataSource
                 $NameInternalNew="Text"+ $numberForColl
                 #Write-Host $numberForColl -ForegroundColor Yellow
                 
                Add-SingleLineTextColumnToList -ListName $ListNameCopy -Name $NameInternalNew -DisplayName $FieldSource.FieldTitle -Description  $FieldSource.FieldDescription -IsRequired  $FieldSource.Required -EnforceUniqueValues $FieldSource.EnforceUniqueValues -MaxLength $maxLengthS -Ctx  $Ctx
           }
           else 
           {
                 Add-SingleLineTextColumnToList -ListName $ListNameCopy -Name $FieldSource.InternalName  -DisplayName $FieldSource.FieldTitle -Description  $FieldSource.FieldDescription -IsRequired  $FieldSource.Required -EnforceUniqueValues $FieldSource.EnforceUniqueValues -MaxLength $maxLengthS -Ctx  $Ctx

           }  #>       
      
        }
        #endregion
        #region Type Number
        if($FieldSource.TypeString -eq "Number")
        {
           $MinS=$xmlAttr.Field.Min
           $MaxS=$xmlAttr.Field.Max
           $DecimalsS=$xmlAttr.Field.Decimals
           $PercentageS=$xmlAttr.Field.Percentage

           #$FieldSource.Schema
           #Write-Host "Internal: $($FieldSource.InternalName) Title: $($FieldSource.FieldTitle) Min: $($MinN) Max: $($MaxN) Decimals: $($DecimalsN)"  -BackgroundColor Gray

           <#if ($FieldSource.InternalName -match "_x0")
           {
               Write-Host "Go Create new name!" -ForegroundColor Red
               $numberForColl = GetNumberForNameCol -TempName "Number"
               $NameInternalNew="Number"+ $numberForColl
                 
               Add-NumberColumnToList -ListName $ListNameCopy -Name $NameInternalNew -DisplayName $FieldSource.FieldTitle -Description  $FieldSource.FieldDescription -IsRequired  $FieldSource.Required -EnforceUniqueValues $FieldSource.EnforceUniqueValues -MaxValue $MaxS -MinValue $MinS -DecimalsValue $DecimalsS -PercentageValue $PercentageS  -Ctx  $Ctx
           }
           else 
           {
               Add-NumberColumnToList -ListName $ListNameCopy -Name $FieldSource.InternalName  -DisplayName $FieldSource.FieldTitle -Description  $FieldSource.FieldDescription -IsRequired  $FieldSource.Required -EnforceUniqueValues $FieldSource.EnforceUniqueValues -MaxValue $MaxS -MinValue $MinS -DecimalsValue $DecimalsS -PercentageValue $PercentageS -Ctx  $Ctx

           }#>
        }
        #endregion 
        #region Type Note
        if($FieldSource.TypeString -eq "Note")
        {
            $NumLinesV=$xmlAttr.Field.NumLines
            $RichTextV=$xmlAttr.Field.RichText
            $AppendOnlyV=$xmlAttr.Field.AppendOnly
            $RichTextModeV=$xmlAttr.Field.RichTextMode
            Write-Host "Internal: $($FieldSource.InternalName) Title: $($FieldSource.FieldTitle) RichText $($RichTextV) AppendOnly $($AppendOnlyV) RichTextMode $($RichTextModeV)"  -ForegroundColor Yellow

            $xmlAttr

            $node = $xmlAttr.selectSingleNode('//Field')
            $node.RemoveAttribute('StaticName')
            $node.RemoveAttribute('SourceID')
            $node.RemoveAttribute('ID')
            Write-Host $xmlAttr.OuterXml -ForegroundColor Blue
           
            #Add-MultilineTextColumnToList -ListName $ListName -Name $FieldSource.InternalName -DisplayName $FieldSource.FieldTitle -Description $FieldSource.FieldTitle -Description  $FieldSource.FieldDescription -IsRequired  $FieldSource.Required -EnforceUniqueValues $FieldSource.EnforceUniqueValues -NumLines $NumLinesV -IsRichText $RichTextV -Ctx  $Ctx
        }
        #endregion
        <# if($FieldSource.TypeString -eq "URL")
        {
           Write-Host "Internal: $($FieldSource.InternalName) Title: $($FieldSource.FieldTitle)"  -ForegroundColor DarkYellow
        }
        if($FieldSource.TypeString -eq "Currency")
        {
           Write-Host "Internal: $($FieldSource.InternalName) Title: $($FieldSource.FieldTitle)"  -ForegroundColor Green
        }#>

    }
    #endregion

    #region Create column in new list v2
    Foreach($FieldSource in $FieldDataSource)
    {
        Write-Host $FieldSource.TypeString -ForegroundColor Red
        [xml]$xmlAttr= $FieldSource.SchemaXml
        # Write-Host $xmlAttr.OuterXml -ForegroundColor Magenta
        # Write-Host  $FieldSource.Schema -ForegroundColor white

        $nodeField = $xmlAttr.selectSingleNode('//Field')

        $NameInternal = $FieldSource.InternalName 

        if ($FieldSource.InternalName -match "_x0")
           {
               Write-Host "Go Create new name!" -ForegroundColor Red
               $numberForColl = GetNumberForNameCol -TempName $FieldSource.TypeString
               $NameInternalNew=$FieldSource.TypeString+ $numberForColl

               Write-host $NameInternalNew
               $nodeField.StaticName= $NameInternalNew
               $nodeField.Name= $NameInternalNew
               $NameInternal= $NameInternalNew
           }

        #Generate new GUID for Field ID
        $FieldID = New-Guid

        $nodeField.ID="{$FieldID}"

        if($FieldSource.TypeString -eq "URL")
        {
            Write-Host "Change type from URL to Note $($FieldSource.FieldTitle)"

            $FieldSchema = "<Field Type='Note' ID='{$FieldID}' DisplayName='$FieldSource.FieldTitle' Name='$NameInternalNew'  StaticName='$NameInternalNew' 
            Description='$FieldSource.FieldDescription' Required='$FieldSource.Required'  EnforceUniqueValues='$FieldSource.EnforceUniqueValues ' 
            NumLines='6' RichText='TRUE' RichTextMode='FullHtml' IsolateStyles='TRUE' />"


            Write-Host $

        }

        
         if(($FieldSource.TypeString -eq "Text") -or ($FieldSource.TypeString -eq "Note") -or ($FieldSource.TypeString -eq "Number") -or ($FieldSource.TypeString -eq "Choice") -or ($FieldSource.TypeString -eq "Currency") -or ($FieldSource.TypeString -eq "Boolean") -or ($FieldSource.TypeString -eq "DateTime") -or ($FieldSource.TypeString -eq "User") -or ($FieldSource.TypeString -eq "Calculated"))
        {
        

        $AtrrColName =$nodeField.Attributes | Where-Object {$_.LocalName  -like "ColName*" } | Select-Object $_.LocalName
        foreach($itemAtrrColName in $AtrrColName){
            $nodeField.RemoveAttribute($itemAtrrColName.Name)
        }
        

        $AtrrRowOrdinal =$nodeField.Attributes | Where-Object {$_.LocalName  -like "RowOrdinal*" } | Select-Object $_.LocalName
        foreach($itemAtrrRowOrdinal in $AtrrRowOrdinal){
            $nodeField.RemoveAttribute($itemAtrrRowOrdinal.Name)
        }

        #$nodeField.RemoveAttribute('ID')
        $nodeField.RemoveAttribute('SourceID')
        #$nodeField.RemoveAttribute('ColName')
        #$nodeField.RemoveAttribute('RowOrdinal')
        $nodeField.RemoveAttribute('Version')
        $nodeField.RemoveAttribute('Indexed')
        Write-Host $xmlAttr.OuterXml -ForegroundColor Green

        
        Write-Host $xmlAttr.OuterXml -ForegroundColor Yellow

        Add-ColumnToList -ListName $ListNameCopy -NameColumn $NameInternal -DisplayName $FieldSource.FieldTitle -FieldSchema $xmlAttr.OuterXml
        }

    }

    #endregion
}
Catch {
    write-host -f Red "Error Creating List!" $_.Exception.Message
}
Finally {
    # Disconnect SharePoint Online
    $Ctx.Dispose()
}


'ff-01' -match '[U+0400–U+04FF]'
    'ке-01' -match '[A-Z]'
    'ff-01_jjT'
     'ке-01t' -match '[а-яА-ЯіїєґІЇЄҐёЁыэЭъ]'
     '_x0442__x0435__x0441__x0442_'-match '\w''_\w\w\w\w_'

     $enc = "_x0442__x0435__x0441__x0442_"
   [System.Text.Encoding]::UTF8.GetString($enc)
   
   [System.Convert]::ToString( $enc)

   $ii= $enc.Replace("_x0", "")

   $enc -match "_x0"

   'col_x_x0430__x0430_' -match "_x0"

   $a = ""

   if ([string]::IsNullOrEmpty($a))
        {
          Write-Host "Empty Max"
        }
   $maxVV="8"
   $c="Min='$($maxVV)'"
   $d=""

$b= "<Field$($a) $($c)/>"
	
