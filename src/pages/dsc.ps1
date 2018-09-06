New-UDPage -Name "DSC" -Icon superpowers -Content {
    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon superpowers 
            "   Desired State Configuration"
        } 
        New-UDHeading -Text "Desired state configuration resources and status." -Size 5 
    }

    New-UDGrid -Title "Local Configuration Manager" -Headers @("Name", "Value") -Properties @("Name", "Value") -Endpoint {
        (Get-DscLocalConfigurationManager).PSObject.Properties | ForEach-Object {
            [PSCustomObject]@{
                Name = ConvertTo-String $_.Name
                Value =  ConvertTo-String $_.Value
            }
        } | Out-UDGridData
    }

    New-UDGrid -Title "DSC Resources" -Headers @("Name", "Module", "Version") -Properties @("Name", "Module", "Version") -Endpoint {
        Get-DscResource | ForEach-Object {
            [PSCustomObject]@{
                Name = ConvertTo-String $_.Name
                Module =  ConvertTo-String $_.ModuleName
                Version =  ConvertTo-String  $_.Version
            }
        } | Out-UDGridData
    }
}