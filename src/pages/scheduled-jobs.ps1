New-UDPage -Name "Scheduled Jobs" -Icon "clock_o" -Content {
    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon "clock_o "
            "   Scheduled Jobs"
        } 
        New-UDHeading -Text "Scheduled job status." -Size 5 
    }

    New-UDGrid -Title "Scheduled Jobs" -Headers @("Name", "Command", "Enabled") -Properties @("Name", "Command", "Enabled") -Endpoint {
        Get-ScheduledJob | ForEach-Object {
            [PSCustomObject]@{
                Name = ConvertTo-String $_.Name
                Command =  ConvertTo-String $_.Command
                Enabled =  ConvertTo-String  $_.Enabled
            }
        } | Out-UDGridData
    }
}