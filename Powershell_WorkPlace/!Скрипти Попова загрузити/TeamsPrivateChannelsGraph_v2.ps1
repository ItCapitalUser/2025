$orgName = "smartholdingcom" 
 

# Tenant Site Collection URL

$tenantSiteURL = "https://$orgName-admin.sharepoint.com"
 

# Output Path

$outPath = "c:\temp"
 

# Tenant admin user Credentials

$UserName = "spsitecoladm@smart-holding.com"
$Password = ""
$SecurePassword= $Password | ConvertTo-SecureString -AsPlainText -Force
$credential=new-object -typename System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword



#create variables for output file

$date = Get-Date -format yyyy-MM-dd
$time = Get-Date -format HH-mm-ss

$outputfilename = "TeamsPrivateChannels" + $date + "_" + $time + ".csv"

$outputpath = $outPath + "\" + $outputfilename

$outputfilename_err = "TeamsPrivateChannelsErr" + $date + "_" + $time + ".csv"

$outputpath_err = $outPath + "\" + $outputfilename_err

#get-site list
Connect-PnPOnline -Url $tenantSiteURL -Credentials $credential

$sites = Get-PnPTenantSite -Detailed -Template "TEAMCHANNEL#0" 

$ChannelsSiteList=@()

foreach ($site in $sites){

        $conn = Connect-PnPOnline -Url $site.Url  -Credentials $credential -ReturnConnection
                
        $sitevar=Get-PnPSite -Includes RelatedGroupId  -Connection $conn

        Get-PnPProperty -ClientObject $sitevar -Property Url,RelatedGroupID  -Connection $conn
        
Write-Host $sitevar.RelatedGroupId, $sitevar.Url

        $ChannelsSiteList += [pscustomobject][ordered]@{
        Title=$site.Title;
        Url=$sitevar.Url;
        RelatedGroupID=$sitevar.RelatedGroupId;
        Template=$site.Template;
        StorageUsage=[string]([int][string]$site.StorageUsage/1024);
        StorageMaximumLevel=[string]([int]$site.StorageMaximumLevel/1024);
        SharingCapability=$site.SharingCapability;
        LastContentModifiedDate=$site.LastContentModifiedDate;
        Description=$site.Description;
        }

           }


Disconnect-PnPOnline


$errorcount=0
$workingcount=0
$errorsites=@()



try {
Connect-PnPOnline -Scopes "Group.Read.All", "User.Read.All" -Credentials $credential

$AccessToken = Get-PnPGraphAccessToken

$GetAllTeams = Invoke-RestMethod -Headers @{Authorization = "Bearer $AccessToken" } -Uri "https://graph.microsoft.com/beta/groups?`$filter=resourceProvisioningOptions/any(c:c+eq+`'Team`')&top=999"

Write-Host "There are:" $GetAllTeams.value.count " Teams present" -ForegroundColor Green

$ChannelsList=@()

foreach ($Team in $GetAllTeams.value) {

    $workingcount=$workingcount+1

    $channelname=""

    $ResponseTeamsChannels = Invoke-RestMethod -Headers @{Authorization = "Bearer $AccessToken" } -Uri ("https://graph.microsoft.com/beta/teams/{0}/channels?`$filter=membershipType eq `'private`'" -f $Team.id)
    
    
    $ResponseTeamsChannels.value.forEach( {
   

    $str="https://graph.microsoft.com/beta/teams('"+$Team.id+"')/channels('"+$_.id+"')/members/"

    $channelname=$_.displayName
             
        $owners=Invoke-RestMethod -Headers @{Authorization = "Bearer $AccessToken" } -Uri $str

        $owns=""

        foreach ($owner in $owners.value)
        {

        if ($owner.roles -eq "owner"){
         
           $owns=$owns+" "+$owner.email
                 
            }
        }
        
        $owns=$owns.TrimEnd();

        foreach ($channelsite in $ChannelsSiteList){

        $searchgroupid="*?groupId="+[string]$channelsite.RelatedGroupId+"&*" 
        
        write-host $searchgroupid

        if ($_.WebUrl -like $searchgroupid) {

        Write-Host $channelsite.Url " private channel was worked" -ForegroundColor Green

        $ChannelsList += [pscustomobject][ordered]@{

                        Title=$channelsite.Title;

                        Url=$channelsite.Url;

                        Template=$channelsite.Template;

                        Owner=$owns;

                        StorageUsage_GB=$channelsite.StorageUsage;

                        StorageMaximumLevel_GB=$channelsite.StorageMaximumLevel;

                        SharingCapability=$channelsite.SharingCapability;

                        LastContentModifiedDate=$channelsite.LastContentModifiedDate;

                        Description=$_.Description;
            
                     }
                     
                        break;

        }

        }
        
              
    } 
    )  
    } 
    
 }
 Catch [Exception] {

       write-host $Team.displayName $Error[0] -ForegroundColor Red

       $errorcount=$errorcount+1

       $errorsteams=$errorsteams+@([pscustomobject]@{

                        Team=$Team.displayName;
                        Channel=$channelname;
                        Reason=$Error[0];

                        })

       }
      

$ChannelsList | Export-Csv -Path $outputpath -Delimiter ";" -Encoding UTF8 


Write-Host "There are worked " $workingcount " teams" -ForegroundColor Green


if ($errorcount -gt 0) {

$errorsteams | export-csv $outputpath_err -Delimiter ";" -Encoding UTF8

Write-Host "There are connection errors " $errorcount " teams" -ForegroundColor Red

}

 

 





