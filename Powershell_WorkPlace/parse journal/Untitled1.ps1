#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$SiteURL = "https://smartholdingcom.sharepoint.com/sites/msteams_f48069"
$ListName = "Documents"
$CSVPath = "C:\Temp\DocumentLibrary040924.csv"
$BatchSize = 500

$ExcelObj = New-Object -comobject Excel.Application
$currDate = Get-Date -Format "ddMMyyy HHmm"
$ExcelWorkBook = $ExcelObj.Workbooks.Open("C:\Temp\R2021.xlsx")#"https://smartholdingcom.sharepoint.com/sites/sbs_hr/Kpi/Files/Example2024_Q3.xlsx")#"C:\Temp\Example2023Q3.xlsx")
#$ExcelWorkBook | fl Name, Path, Author

#$ExcelWorkBook.Close($false)
#$ExcelObj.Quit()

#region init class  
class DocumentInRegister {
    [string]$Title
    [string]$Date
    [string]$Url
}

#endregion

try
{
    $ExcelWorkSheet = $ExcelWorkBook.Sheets.Item("2021_Журнал регистрации") 
    $i =$ExcelWorkSheet.UsedRange.Table(
       $allDocum = @() 
    for ($var = 2; $var -le $countRow-1; $var++) {
        #$divis = New-Object -TypeName Division
       $oo= $ExcelWorkSheet.UsedRange.Cells(2,16).Text 
       $dateD=$ExcelWorkSheet.UsedRange.Cells(2,10).Text 
       $Text1 = [System.Web.HttpUtility]::UrlDecode($oo)

       $iii= $Text1 -split "/"
       $ioio = $iii.Count
       $fff= $iii[$ioio -1]
       
        $ExcelWorkSheet.UsedRange.Table(
        $divis.NameDivision = $ExcelWorkSheet.UsedRange.Cells(2,1).Text
      

        $divis | Add-Member -Name $ExcelWorkSheet.UsedRange.Cells(1,1).Text -Value $ExcelWorkSheet.UsedRange.Cells($var,1).Text -MemberType NoteProperty
        $divis | Add-Member -Name $ExcelWorkSheet.UsedRange.Cells(1,2).Text -Value $ExcelWorkSheet.UsedRange.Cells($var,2).Text -MemberType NoteProperty
        $divis | Add-Member -Name $ExcelWorkSheet.UsedRange.Cells(1,3).Text -Value $ExcelWorkSheet.UsedRange.Cells($var,3).Text -MemberType NoteProperty
        $allDiv += $divis#>
    }
     $allDiv

}
Catch {
    write-host -f Red "Create folder block Quarter and set permission" $_.Exception.Message
}