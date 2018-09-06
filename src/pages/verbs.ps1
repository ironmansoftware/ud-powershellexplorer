New-UDPage -Name "Verbs" -Icon language -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon language 
            "   Verbs"
        }
        New-UDHeading -Text "View approved verbs" -Size 5 
    }

    New-UDTable -Title "Verbs" -Headers @("Verb", "Group") -Endpoint {
        Get-Verb | Out-UDTableData -Property @("Verb", "Group")
    }
}