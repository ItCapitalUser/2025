Connect-AzureAD -Credential $Credential

$UserAccount =  Get-AzureADUser -Filter "userPrincipalName eq 'oksana.bilohub@smartbs.com.ua'" -ErrorAction SilentlyContinue

#Checking if the user is active
If($UserAccount -eq $null) {
    Write-Host "'$email' doesn't in tenant" -ForegroundColor Yellow
    $UserStatus = "Not Exists"
}
Else {
    Write-Host "'$email' exists in tenant" -ForegroundColor Green
    $UserStatus = "Exists"
}