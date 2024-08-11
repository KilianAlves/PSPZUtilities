<#
    .SYNOPSIS
    Permet de désenregistrer un ou plusieurs élément du registre

    .DESCRIPTION
    Permet de désenregistrer un ou plusieurs élément du registre

    .PARAMETER Registry
    le ou les registres à désenregistrer

    .INPUTS
    Aucun input, ne prend rien de la pipeline

    .OUTPUTS
    Aucun output, ne génère pas d'output

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