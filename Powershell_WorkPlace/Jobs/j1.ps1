Start-Job -name "y1" -ScriptBlock {For ($i=0; $i -le 10; $i++) {
Write-Output $i
}
}

$j = Get-Job -Name y1
Receive-Job -Job $j



For ($i=0; $i -le 10; $i++) {
Write-Output $i

 Start-Job -name "y$i" -ScriptBlock {For ($i=0; $i -le 10; $i++) {
Write-Output $i
}
}
}
