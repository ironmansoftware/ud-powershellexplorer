New-UDPage -Name "Providers" -Icon hdd_o -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon hdd_o 
            "   PowerShell Providers"
        }         
        New-UDHeading -Text "Navigate providers and their drives in a tree view." -Size 5 
    }

    New-UDRow -Columns {
        New-UDColumn -Size 3 -Content {

            New-UDCard -Title "Providers" -Content {
                Get-PSProvider | ForEach-Object {
                    $Root = New-UDTreeNode -Name $_.Name -Id "PSProvider:$($_.Name)" -Icon list
                    New-UDTreeView -ActiveBackgroundColor '#DFE8E4' -Node $Root -OnNodeClicked {
                        param($Body)
        
                        $Obj = $Body | ConvertFrom-Json
        
                        if ($Obj.NodeId.StartsWith("PSProvider")) {
                            $Provider = $Obj.NodeId.Split(':')[1]
        
                            $Drives = Get-PSDrive -PSProvider $Provider
                            if ($Drives -ne $null) {
                                $Drives | ForEach-Object {
                                    New-UDTreeNode -Name $_.Name -Id "Drive:$($_.Name)" -Icon hdd_o
                                } 
                            }
                            return
                        }
        
                        $NodeId = $Obj.NodeId
                        if ($NodeId.StartsWith("Drive")) {
                            $NodeId = $Obj.NodeId.Split(':')[1] + ":\"
                        }
        
                        Get-ChildItem -Path $NodeId | ForEach-Object {
                            if ($NodeId -eq $_.FullName) {
                                return
                            }
        
                            if ($_.PSIsContainer) {
                                New-UDTreeNode -Name $_.Name -Id $_.FullName -Icon folder
                            } else {
                                New-UDTreeNode -Name $_.Name -Id $_.FullName -Icon file_text
                            }
                        } | ConvertTo-JsonEx
        
                        Set-UDElement -Id "properties" -Content {
                            New-UDGrid -Title $NodeId -Headers @("Name", "Value") -Properties @("Name", "Value") -Endpoint {
                                $id = $ArgumentList[0]
    
                                try {
                                    (Get-ItemProperty -Path $id -ErrorAction Stop).PSObject.Properties | ForEach-Object {
                                        [PSCustomObject]@{
                                            Name = $_.Name
                                            Value = if ( $_.Value -eq $null) { "" } else { $_.Value.ToString() }
                            
                                        } | Out-UDGridData
                                    } 
                                }
                                catch {
                                    Get-ChildItem -Path $id | ForEach-Object {
                                        [PSCustomObject]@{
                                            Name = $_.Name
                                            Value = if ( $_.Value -eq $null) { "" } else { $_.Value.ToString() }
                            
                                    } | Out-UDGridData
                                }
                            }
                        } -ArgumentList $NodeId
                    } 
                }
            }
        }
    } 
    New-UDColumn -Size 9 -Content {
        New-UDElement -Tag "div" -Id "properties" -Content {}
    }
    }
}