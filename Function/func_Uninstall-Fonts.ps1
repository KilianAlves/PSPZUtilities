<#
    .SYNOPSIS
    Permet de desinstaller une police d'�criture du PC

    .DESCRIPTION
    Permet de desinstaller une police d'�criture du PC en precisant l'utilisateur ou le systeme

    .PARAMETER FontName
    La police d'�criture a d�sinstaller

    .PARAMETER Scope
    Pr�cise si il faut la d�sinstaller sur l'utilisateur courant ou du systeme

    .INPUTS
    Ne prend rien de la pipeline

    .OUTPUTS
    Aucun output, ne g�n�re pas d'output (sauf erreur)

    .EXAMPLE
    PS> Uninstall-Fonts -FontName "NomDeLaPolice" -Scope System

#>

function Uninstall-Fonts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String] $FontName,
        [ValidateSet('System', 'User')]
        [String] $Scope = 'System'
    )
    # affecte les chemins et clef de registre en fonction du Scope choisis
    if ($Scope -eq 'System') {
        $FontDestination = [Environment]::GetFolderPath('Fonts')
        $FontRegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    }
    if ($Scope -eq 'User') {
        # Permet d'avoir le chemin de destination des fonts sur le current user
        $FontDestination = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'Microsoft\Windows\Fonts'
        $FontRegKey = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    }

    $fontRegistry = Get-Item -Path $FontRegKey

    if ($fontRegistry.Property -notcontains "Code 128 (TrueType)") {
        throw ("La police d'�criture n'a pas �t� trouv�")
    }

    # Suppression du fichier et dans le registre
    # $CheminFont = Join-Path -Path "" -ChildPath ""
    # Remove-Item -Path $CheminFont
    try {
        Remove-ItemProperty -Path $CheminFont -Name $FontName
    } catch {
        Write-Host ("La police $($FontName) n'a pas pu �tre d�sinstaller.")
    }
}