function ConvertTo-String {
    param($Object) 

    if ($null -eq $Object) {
        return [String]::Empty
    }

    return $Object.ToString()
}

function Start-PowerShellExplorer {
    param($Port = 8080, [Switch]$NoBrowser)

    $Pages = @()


    $ModuleEndpointSchedule = New-UDEndpointSchedule -Every 5 -Minute
    $ModuleEndpoint = New-UDEndpoint -Schedule $ModuleEndpointSchedule -Endpoint {
        $Cache:InstalledModules = Get-Module -ListAvailable
    }

    $Pages += New-UDPage -Name "Home" -Icon home -Content {
        New-UDElement -Tag div -Attributes @{
            className = "center-align"
        } -Content {
            New-UDHeading -Size 1 -Text "PowerShell Explorer"
            New-UDHeading -Size 3 -Text "PowerShell environment dashboard"
        }

        New-UDLayout -Columns 3 -Content {
            New-UDCard -Title "Abstract Syntax Tree" -Content {
                "Navigate the abstract syntax tree of any script you enter"
            } -Links @(New-UDLink -Text "View" -Url "/AST-Explorer")
            
            New-UDCard -Title "Desired State Configuration" -Content {
                "Desired state configuration resources and status."
            } -Links @(New-UDLink -Text "View" -Url "/DSC")

            New-UDCard -Title "PowerShell Host Processes" -Content {
                "View processes hosting the PowerShell engine."
            } -Links @(New-UDLink -Text "View" -Url "/Host-Processes")

            New-UDCard -Title "PS Providers" -Content {
                "Navigate providers and their drives in a tree view."
            } -Links @(New-UDLink -Text "View" -Url "/Providers")

            New-UDCard -Title "Repositories" -Content {
                "View repositories registered with PowerShellGet"
            } -Links @(New-UDLink -Text "View" -Url "/Repositories")

            New-UDCard -Title "Scheduled Jobs" -Content {
                "View registered scheduled jobs"
            } -Links @(New-UDLink -Text "View" -Url "/Scheduled-Jobs")

            New-UDCard -Title "Variables" -Content {
                "View variables currently defined in the runspace."
            } -Links @(New-UDLink -Text "View" -Url "/Variables")

            New-UDCard -Title "Verbs" -Content {
                "View approved verbs."
            } -Links @(New-UDLink -Text "View" -Url "/Verbs")
        }
    }

    Get-ChildItem (Join-Path $PSScriptRoot "pages") | ForEach-Object {
        $Pages += . $_.FullName
    }

    $Initialization = New-UDEndpointInitialization -Module (Invoke-Expression "'$PSScriptRoot\controls\textarea.ps1'") -Function "ConvertTo-String"
    $Dashboard = New-UDDashboard -Title "PowerShell Explorer" -Pages $Pages -EndpointInitialization $Initialization
    Start-UDDashboard -Dashboard $Dashboard -Port $Port -Endpoint $ModuleEndpoint

    if (-not $NoBrowser) {
        Start-Process http://localhost:$Port
    }
}