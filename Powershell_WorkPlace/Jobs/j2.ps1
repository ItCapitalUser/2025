
#Accepts a Job as a parameter and writes the latest progress of it
function WriteJobProgress
{
    param($Job)
 
    #Make sure the first child job exists
    if($Job.ChildJobs[0].Progress -ne $null)
    {
        #Extracts the latest progress of the job and writes the progress
        $jobProgressHistory = $Job.ChildJobs[0].Progress;
        $latestProgress = $jobProgressHistory[$jobProgressHistory.Count - 1];
        $latestPercentComplete = $latestProgress | Select -expand PercentComplete;
        $latestActivity = $latestProgress | Select -expand Activity;
        $latestStatus = $latestProgress | Select -expand StatusDescription;
    
        #When adding multiple progress bars, a unique ID must be provided. Here I am providing the JobID as this
        Write-Progress -Id $Job.Id -Activity $latestActivity -Status $latestStatus -PercentComplete $latestPercentComplete;
    }
}
 
#Test Async Job 1. Iterates through 10 integers and sleeps 1 second in between
$job1 = Start-Job –Name Sleep1 –Scriptblock {
    
    for($i=0;$i -lt 10;$i++)
    {
        $percentComplete = ($i + 1) * 10;
        $status = $percentComplete.ToString() + "% Complete ";
        $activity = "Job 1 - Processing Iteration " + ($i + 1);
 
        Write-Progress -Activity $activity -Status $status -PercentComplete $percentComplete;
 
        Start-Sleep -Seconds 1;
    }
}
 
#Test Async Job 2. Iterates through 10 integers and sleeps 2 second in between
$job2 = Start-Job –Name Sleep2 –Scriptblock {
    
    for($i=0;$i -lt 10;$i++)
    {
        $percentComplete = ($i + 1) * 10;
        $status = $percentComplete.ToString() + "% Complete ";
        $activity = "Job 2 - Processing Iteration " + ($i + 1);
 
        Write-Progress -Activity $activity -Status $status -PercentComplete $percentComplete;
 
        Start-Sleep -Seconds 2;
    }
}
 
#Monitor all running jobs in the current sessions until they are complete
#Call our custom WriteJobProgress function for each job to show progress. Sleep 1 second and check again
while((Get-Job | Where-Object {$_.State -ne "Completed"}).Count -gt 0)
{    
    WriteJobProgress($job1);
    WriteJobProgress($job2);
 
    Start-Sleep -Seconds 1
}