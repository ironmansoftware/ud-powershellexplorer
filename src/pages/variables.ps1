New-UDPage -Name "Variables" -Icon asterisk -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon asterisk 
            "   Variables"
        }
        New-UDHeading -Text "View variables currently defined in the runspace." -Size 5 
    }

    New-UDTable -Title "Variables" -Headers @("Name", "Value") -Endpoint {
        Get-Variable | ForEach-Object {

            $Value = '$null'
            if ($_.Value -ne $null) {
                $Value = $_.Value.ToString()
            }

            [PSCustomObject]@{
                Name = $_.Name
                Value = $Value
            }
        } | Out-UDTableData -Property @("Name", "Value")
    }
}