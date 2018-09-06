New-UDPage -Name "Host Processes" -Icon terminal -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon terminal 
            "   Host Processes"
        } 
        New-UDHeading -Text "These are processes hosting the PowerShell engine." -Size 5 
    }

    New-UDTable -Title "PowerShell Host Processes" -Headers @("Process Name", "Process ID", "Main Window Title", "Parent Process") -Endpoint {
        Get-PSHostProcessInfo | ForEach-Object {
            $ParentProcessId = (Get-CimInstance -ClassName "win32_process" -Filter "ProcessId = $($_.ProcessId)").ParentProcessId
            $ParentProcess = Get-Process -Id $ParentProcessId

            [PSCustomObject]@{
                Name = ConvertTo-String $_.ProcessName 
                Id = ConvertTo-String $_.ProcessName 
                Title = ConvertTo-String $_.ProcessName 
                ParentProcess = (ConvertTo-String $ParentProcess.Name) + " ($($ParentProcessId))"
            } 
            
        } | Out-UDTableData -Property @(
            "Name",
            "Id", 
            "Title"
            "ParentProcess"
        )
    }
}