<#
    .SYNOPSIS
    Crée une clef de registre avec une valeur

    .DESCRIPTION
    Permet de crée une clef de registre et de lui attribuer une valeur directement

    .PARAMETER RegistryPath
    Le chemin vers le registre cible

    .PARAMETER Name
    Permet de mettre un nom sur la clé de registre

    .PARAMETER Type
    associe un type pour la clé de registre (utilise l'enum de registre)
    
    .PARAMETER DefaultValue
    Indique la valeur par défaut

    .PARAMETER Force
    Permet de forcer l'action

    .INPUTS
    Ne prend rien de la pipeline

    .OUTPUTS
    Aucun output.
    
    .EXAMPLE
    PS> New-RegistryAndProperty -RegistryPath "HKLM:\SOFTWARE\ElmtACree" -Name Version -Type String -DefaultValue "v.1.0.0"

    .EXAMPLE
    PS> New-RegistryAndProperty -RegistryPath "HKLM:\SOFTWARE\ElmtACree" -Name Version -Type String -DefaultValue "v.2.0.0" -Force

#>

function New-RegistryAndProperty {
    param(
        [Parameter(Mandatory)]
        [string] $RegistryPath,
        [Parameter(Mandatory)]
        [String] $Name,
        [Parameter(Mandatory)]
        [Microsoft.Win32.RegistryValueKind] $Type,
        [Parameter(Mandatory)]
        $DefaultValue,
        [System.Diagnostics.Switch] $Force
    )
    <#
    Fonction permettant de crÃ©e une clÃ© de registre et de lui affecter une valeur aussitÃ´t
    #>
    if ($Force) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Set-ItemProperty -Path $RegistryPath -Name $Name -Value $DefaultValue -Type $Type -Force
    } else {
        New-Item -Path $RegistryPath | Out-Null
        Set-ItemProperty -Path $RegistryPath -Name $Name -Value $DefaultValue -Type $Type
    }
}