$Servername = 'Server1'
Start-Job { "Target: " + $using:ServerName } | Receive-Job -Wait -AutoRemoveJob

$func = {function DoCleanup 
	{		(
			[parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$computerName
            )
			Write-Host "Starting to clean up space on $computerName"
}
}

$compute="dasdadsasd"
Start-Job -InitializationScript $func -ScriptBlock {DoCleanup $args[0]} -ArgumentList $compute -Name aaaaa
Receive-Job -Name aaaaa -Keep

$functions = {
    Function execute_vbs {
        param ([string]$path_VBScript, [int]$secs)
        Start-Sleep -Seconds $secs
        write-Host "filename = '$path_VBScript'"
        write-Host "secs = '$secs'"
    }
}

$filename = 'C:\Users\[USERNAME]\Desktop\hello_world.vbs'
$seconds = 2

$job = Start-Job -InitializationScript $functions -ScriptBlock {
        execute_vbs -path_VBScript $using:filename -secs $using:seconds
    } -Name MyJob

wait-job $job

receive-job $job
# output:
# filename = 'C:\Users\[USERNAME]\Desktop\hello_world.vbs'
# secs = '2
