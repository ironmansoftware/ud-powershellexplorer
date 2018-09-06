Import-Module "$PSScriptRoot\..\controls\textarea.ps1"

New-UDPage -Name "AST Explorer" -Icon tree -Content {

    New-UDLayout -Columns 1 {
        New-UDHeading -Size 3 -Content {
            New-UDIcon -Icon tree 
            "   Abstract Syntax Tree Explorer"
        } 
        New-UDHeading -Text "Enter a script in the below textbox to explore its abstract syntax tree." -Size 5 
    }

    New-UDRow -Columns {
        New-UDColumn -Size 12 -Content {
            New-UDTextarea -Id "txtScript" -Label "Enter PowerShell Script"
        }
    }

    New-UDRow -Columns {
        New-UDColumn -Size 12 -Content {
            New-UDButton -Text "Parse" -OnClick {
                $Element = Get-UDElement -Id "txtScript" 
                $ScriptBlock = [ScriptBlock]::Create($Element.Attributes["value"])
                Set-UDElement -Id "astexplorer" -Content {
                    $Session:Object = $ScriptBlock.Ast
                    
                    $Root = New-UDTreeNode -Name 'AST' -Id '$Session:Object'
                    New-UDTreeView -ActiveBackgroundColor '#DFE8E4' -Node $Root -OnNodeClicked {
                        param($Body)

                        $Obj = $Body | ConvertFrom-Json

                        $Object = Invoke-Expression $Obj.NodeId

                        $Object | Get-Member -MemberType Properties | ForEach-Object {
                            $Name = $_.Name 
                            New-UDTreeNode -Name "$Name" -Id "$($Obj.NodeId).$Name"
                        } | ConvertTo-JsonEx

                        Set-UDElement -Id "astproperties" -Content {
                            New-UDGrid -Title "Properties" -Headers @("Name", "Value", "Type") -Properties @("Name", "Value", "Type") -Endpoint {
                                if ($ArgumentList -eq $null) {
                                    return
                                }

                                $Items = $ArgumentList[0] | Get-Member -MemberType Properties | ForEach-Object {
                                    $Name = $_.Name
                                    $Value = $ArgumentList[0].$Name

                                    $ValueType = $null
                                    $ValueString = $null 

                                    if ($Value -ne $null) {
                                        $ValueType = $Value.GetType().Name
                                        $ValueString = $Value.ToString()
                                    }

                                    [PSCustomObject]@{
                                        Name = $Name
                                        Value = $Value
                                        Type = $ValueType
                                    }
                                } 

                                @{
                                    data = $Items
                                    recordsTotal = $Items.Length
                                    recordsFiltered = $Items.Length
                                    draw = $drawId
                                } | ConvertTo-JsonEx -Depth 2

                            } -ArgumentList $Object
                        }
                    }
                }
            }
        }
    }
        
        
    New-UDRow -Columns {
        New-UDColumn -Size 3 -Content {
            New-UDCard -Title "AST Nodes" -Content {
                New-UDElement -Tag "div" -Id "astexplorer" -Content {}
            }
        }
        New-UDColumn -Size 9 -Content {
            New-UDElement -Tag "div" -Id "astproperties" -Content {}
        }
    }
    
}