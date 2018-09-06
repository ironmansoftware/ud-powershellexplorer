New-UDPage -Name "Repositories" -Icon rss -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon rss 
            "   Repositories"
        }    
        New-UDHeading -Text "These are repositories registered with PowerShellGet." -Size 5 
    }

    New-UDTable -Title "Repositories" -Headers @("Name", "Installation Policy", "Source Location") -Endpoint {
        Get-PSRepository | Out-UDTableData -Property @(
            "Name",
            "InstallationPolicy", 
            "SourceLocation"
        )
    }
}