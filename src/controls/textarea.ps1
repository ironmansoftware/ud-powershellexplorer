function New-UDTextarea {
    param(
        [Parameter()]
        [string]$Id,
        [Parameter()]
        [string]$Label,
        [Parameter()]
        [string]$Value
    )

    New-UDElement -Tag "div" -Attributes @{ className = "input-field"} -Content {
        New-UDElement -Tag "textarea" -Attributes @{ className = "materialize-textarea"; value = $value} -Id $id 
        New-UDElement -Tag "label" -Attributes @{ "for" = $id } -Content { $Label }
    }
}