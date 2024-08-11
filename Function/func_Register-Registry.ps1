<#
    .SYNOPSIS
    Permet de enregistrer un ou plusieurs élément du registre

    .DESCRIPTION
    Permet de enregistrer un ou plusieurs élément du registre

    .PARAMETER Registry
    le ou les registres à enregistrer

    .INPUTS
    Aucun input, ne prend rien de la pipeline

    .OUTPUTS
    Aucun output, ne génère pas d'output

    .EXAMPLE
    PS> Register-Registry -Registry "c:\uneDLL.dll"

    .EXAMPLE
    PS> Register-Registry -Registry "c:\uneDLL.dll","c:\uneAutreDLL.dll"

#>

function Register-Registry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String[]] $Registry
    )
    foreach ($registre in $Registry) {
        regsvr32.exe /s $registre /s
    }
}