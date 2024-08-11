<#
    .SYNOPSIS
    Permet de d�senregistrer un ou plusieurs �l�ment du registre

    .DESCRIPTION
    Permet de d�senregistrer un ou plusieurs �l�ment du registre

    .PARAMETER Registry
    le ou les registres � d�senregistrer

    .INPUTS
    Aucun input, ne prend rien de la pipeline

    .OUTPUTS
    Aucun output, ne g�n�re pas d'output

    .EXAMPLE
    PS> Unregister-Registry -Registry "c:\uneDLL.dll"

    .EXAMPLE
    PS> Unregister-Registry -Registry "c:\uneDLL.dll","c:\uneAutreDLL.dll"

#>

function Unregister-Registry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String[]] $Registry
    )
    foreach ($registre in $Registry) {
        regsvr32.exe /s /u $registre /s
    }
}