New-UDPage -Name "Modules" -Icon mortar_board -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon mortar_board 
            "   Modules"
        } 
        New-UDHeading -Text "Check out the modules installed on this box and install modules from the PowerShell Gallery." -Size 5 
    }

    New-UDGrid -Title "Installed Modules" -Headers @("Name", "Version", "Path") -Properties @("Name", "Version", "Path") -Endpoint {
        # This cached variable is populated by a scheduled endpoint
        $Items =  $Cache:InstalledModules

        @{
            data = $Items
            recordsTotal = $Items.Length
            recordsFiltered = $Items.Length
            draw = $drawId
        } | ConvertTo-JsonEx -Depth 2
    }

    New-UDCard -Title "PowerShell Gallery" -Content {
        New-UDRow -Columns {
            New-UDColumn -Size 9 -Content {
                New-UDTextbox -Id "txtModuleName" -Label "Find Module" -Placeholder "Search text..."
            }
            New-UDColumn -Size 3 -Content {
                New-UDButton -Text "Find" -OnClick {
                    $Element = Get-UDElement -Id "txtModuleName" 

                    Set-UDElement -Id "findModuleOutput" -Content {
                        "Searching for $($Element.Attributes["value"])..."
                    }

                    $Modules = Find-Module -Filter $Element.Attributes["value"]
                    Set-UDElement -Id "findModuleOutput" -Content {
                        New-UDGrid -Title $Element.Attributes["value"] -Headers @("Name", "Version", "Install") -Properties @("Name", "Version", "Install") -Endpoint {

                            if ($ArgumentList -eq $null) { return }

                            $ArgumentList[0] | ForEach-Object {
                                $Item = $_
                                [PSCustomObject]@{
                                    Name = $_.Name
                                    Version = $_.Version
                                    Install = New-UDButton -Text "Install" -OnClick {

                                        Show-UDModal -Header { New-UDHeading -Text "Installing $($_.Name)" -Size 1 } -Content {
                                            New-UDRow {
                                                New-UDPreloader -Size large -Color green
                                            }
                                        } 

                                        try 
                                        {
                                            Install-Module -Name $Item.Name -Scope CurrentUser -Force
                                        }
                                        catch  
                                        {
                                            Show-UDToast -Message $_
                                        }
                                        
                                        Hide-UDModal

                                    }
                                }
                            } | Out-UDGridData 
                        } -ArgumentList $Modules
                    }
                }
            }
        }
        New-UDRow -Columns {
            New-UDColumn -Size 12 -Content {
                New-UDElement -Tag "div" -Id "findModuleOutput"
            }
        }
    }   
}