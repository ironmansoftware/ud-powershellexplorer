Import-Module UniversalDashboard.Community

function ConvertTo-String {
    param($Object) 

    if ($null -eq $Object) {
        return [String]::Empty
    }

    return $Object.ToString()
}

function Start-UDPowerShellExplorer {
    param($Port = 10001)

    $Pages = Get-ChildItem (Join-Path $PSScriptRoot "pages") | ForEach-Object {
        . $_.FullName
    }

    $ModuleEndpointSchedule = New-UDEndpointSchedule -Every 5 -Minute
    $ModuleEndpoint = New-UDEndpoint -Schedule $ModuleEndpointSchedule -Endpoint {
        $Cache:InstalledModules = Get-Module -ListAvailable
    }

    $Initialization = New-UDEndpointInitialization -Module (Invoke-Expression "'$PSScriptRoot\controls\textarea.ps1'") -Function "ConvertTo-String"
    $Dashboard = New-UDDashboard -Title "PowerShell Explorer" -Pages $Pages -EndpointInitialization $Initialization
    Start-UDDashboard -Dashboard $Dashboard -Port $Port -Endpoint $ModuleEndpoint
}