Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
$SiteURL="https://smartholdingcom.sharepoint.com/sites/sbs_fs"
 
#Setup Credentials to connect
$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
 
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Credentials

$Web= $Ctx.Web
$Lists = $Ctx.Web.Lists
        $Ctx.Load($Lists)
        $Ctx.ExecuteQuery()

$countItemsInArr =$Lists.Count

$i=0
$j=10

Do
{
    Write-Host "i: $($i) j: $($j)"

    foreach($List in $Lists[$i..$j])
    {
       Write-Host  $List.Title -f Green
    }

    $i=$j+1
    $j=$j+10

} Until ($j -gt $countItemsInArr)




Function Get-SPOList()
{
    Param
    (
        [Parameter(Mandatory=$false)] [Microsoft.SharePoint.Client.Web] $Web,
        [Parameter(Mandatory=$false)] [string] $ListName
    )
    #Get the Context
    #$Ctx = $Web.Context
     

        #sharepoint online get list powershell
        $List = $Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()

$ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
$Ctx.Load($ListItems)
$Ctx.ExecuteQuery()
Write-host "Total Number of Items Found in the List:"$ListItems.Count




}
$uu ="Аудит"
Start-Job -ScriptBlock {Get-SPOList -ListName "Аудит"} -Name PShellJob 
Receive-Job -Name PShellJob -Keep

$jobWRM = Invoke-Command -ComputerName (Get-Content -Path C:\Servers.txt) -ScriptBlock {
   Get-Service -Name WinRM } -JobName WinRM -ThrottleLimit 16 -AsJob

   $block = {
   $ListName= "Аудит"
        $List = $Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()

        $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery()
        Write-host "Total Number of Items Found in the List:"$ListItems.Count
}

$functions = {
    Function GetItems {
        param ([string]$name)#,
        #[Parameter(Mandatory=$true)] [Microsoft.SharePoint.Client.ClientRuntimeContext]$Ctx)
        $List = $Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()

        $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery()
        Write-host "Total Number of Items Found in the List:"$ListItems.Count
    }
}

   $ListName= "Аудит"
   $job = Start-Job -InitializationScript $functions -ScriptBlock {
        GetItems  
    } -Name MyJob1 -Credential $Credentials

    wait-job $job

receive-job $job

 $job = Start-Job -InitializationScript $functions -ScriptBlock {
         $web = $ctx.Web
         $ctx.Load($web);
         $ctx.ExecuteQuery();
         Write-Host $web.Title 
    } -Name MyJob1 -Credential $Cred

$functions = {
    Function GetItems {
       # param ([string]$name)#,
        Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
        Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

        $SiteURL="https://smartholdingcom.sharepoint.com/sites/sbs_fs"

         $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) 
        $Cred= Get-Credential
        $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
        

       <# $Web= $Ctx.Web
        $List = $Web.Lists.GetByTitle($name)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()

        $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery()
        Write-host "Total Number of Items Found in the List:"$ListItems.Count#>
    }
}

$r= Get-Credential -Credential $env:USERNAME

 $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) 
 $Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
 $ctx.Credentials = $Credentials;
 $web = $ctx.Web
 $ctx.Load($web);
 $ctx.ExecuteQuery();

 #Remove all jobs created.
Get-Job | Remove-Job  #!!!!!

 <#$block = {
    Param([string] $file)
    "[Do something]"
}
#Remove all jobs
Get-Job | Remove-Job
$MaxThreads = 4
#Start the jobs. Max 4 jobs running simultaneously.
foreach($file in $files){
    While ($(Get-Job -state running).count -ge $MaxThreads){
        Start-Sleep -Milliseconds 3
    }
    Start-Job -Scriptblock $Block -ArgumentList $file
}
#Wait for all jobs to finish.
While ($(Get-Job -State Running).count -gt 0){
    start-sleep 1
}
#Get information from each job.
foreach($job in Get-Job){
    $info= Receive-Job -Id ($job.Id)
}#>


