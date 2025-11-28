#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Set Parameters
$SiteURL="https://smartholdingcom-my.sharepoint.com/personal/o_kirichenko_veres_com_ua"
$LibraryName="Documents"
$ReportOutput = "C:\Temp\VersionHistory-Documents-o_kirichenko_veres_com_ua_120625.csv"
  
Try {
    #Setup Credentials to connect
    $Cred= Get-Credential
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
   
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
      
    #Get the web & Library
    $Web=$Ctx.Web
    $Ctx.Load($Web)
    $List = $Web.Lists.GetByTitle($LibraryName)
    $Ctx.ExecuteQuery()
          
    #Query to Batch process Items from the document library
    $Query =  New-Object Microsoft.SharePoint.Client.CamlQuery
    $Query.ViewXml = "<View Scope='RecursiveAll'><Query><OrderBy><FieldRef Name='ID' /></OrderBy></Query><RowLimit>2000</RowLimit></View>"

    
 
    Do {
        $ListItems=$List.GetItems($Query)
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery()
        $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
 
        $VersionHistoryData = @()
        #Iterate throgh each file - Excluding Folder Objects
        Foreach ($Item in $ListItems | Where { $_.FileSystemObjectType -eq "File"})
        {
            $File = $Web.GetFileByServerRelativeUrl($Item["FileRef"])
            $Ctx.Load($File)
            $Ctx.Load($File.ListItemAllFields)
            $Ctx.Load($File.Versions)
            
               
            $retries = 0
            $maxRetries = 5
            $delay = 2 # Initial delay in seconds

            while ($retries -lt $maxRetries) {
                try {
                     $Ctx.ExecuteQuery()
                     Write-Host "Request successful"
                     break # Exit loop if successful
                } catch {
                    if ($_.Exception.Response.StatusCode -eq 429) {
                        Write-Host "Rate limit exceeded. Retrying in $($delay) seconds..."
                        Start-Sleep -Seconds $delay
                        $retries++
                        $delay = $delay * 2 # Exponential backoff
                        } else {
                            Write-Host "An error occurred: $($_.Exception.Message)"
                            #throw # Re-throw the exception
                        }
                }
            }
          
            Write-host -f Yellow "Processing File:"$File.Name
            If($File.Versions.Count -ge 1)
            {
                #Calculate Version Size
                $VersionSize = $File.Versions | Measure-Object -Property Size -Sum | Select-Object -expand Sum
                If($Web.ServerRelativeUrl -eq "/")
                {
                    $FileURL = $("{0}{1}" -f $Web.Url, $File.ServerRelativeUrl)
                }
                Else
                {
                    $FileURL = $("{0}{1}" -f $Web.Url.Replace($Web.ServerRelativeUrl,''), $File.ServerRelativeUrl)
                }
  
                #Send Data to object array
                $VersionHistoryData += New-Object PSObject -Property @{
                'File Name' = $File.Name
                'Versions Count' = $File.Versions.count
                'File Size' = ($File.Length/1KB)
                'Version Size' = ($VersionSize/1KB)
                'URL' = $FileURL
                }
            }
        }
    } While ($Query.ListItemCollectionPosition -ne $null)
 
    #Export the data to CSV
    $VersionHistoryData | Export-Csv $ReportOutput -NoTypeInformation -Encoding UTF8

    $FilterD= $VersionHistoryData | Where  {$_."Versions Count" -gt 25}
    $FilterD| Export-Csv $ReportOutput -NoTypeInformation -Encoding UTF8

    for($i=0; $i -lt  $FilterD.Count; $i++)
    {
        Write-Host  $FilterD[$i].URL
        $FileURL= $FilterD[$i].URL


        $File = $Ctx.web.GetFileByUrl($FileURL)
        $Ctx.Load($File)
        $Ctx.ExecuteQuery()

        $Versions = $File.Versions
        $Ctx.Load($Versions)
        $Ctx.ExecuteQuery()

        $VersionsToKeep=25#$Versions.Count/2

        While($File.Versions.Count -gt $VersionsToKeep)
            {
                $Versions[0].DeleteObject()
                $Ctx.ExecuteQuery()
                Write-host -f Green "`tDeleted Version:" $Versions[0].VersionLabel
     
                #Reload versions
                $Ctx.Load($File.Versions)
                $Ctx.ExecuteQuery()
            }
    }
   


  
    Write-host -f Green "Versioning History Report has been Generated Successfully!"
}
Catch {
    write-host -f Red "Error Generating Version History Report!" $_.Exception.Message
}