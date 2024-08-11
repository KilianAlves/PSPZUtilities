<#
    .SYNOPSIS
    La commande permet d'installer une police d'�criture du PC

    .DESCRIPTION
    La commande permet d'installer une police d'�criture du PC en pr�cisant l'utilisateur ou le syst�me

    .PARAMETER Path
    Le chemin est soit un chemin vers un fichier (ttf ou otf) ou un dossier

    .PARAMETER Scope
    Pr�cise si il faut l'installer sur l'utilisateur courant ou sur le syst�me, par d�faut la valeur est System

    .PARAMETER RecurseFolder
    Si pr�sent, il permet d'installer les polices d'�critures dans des dossiers du dossier en param�tre du Path

    .INPUTS
    Ne prend rien de la pipeline

    .OUTPUTS
    Output de console (Police install�e et erreur)
    
    .EXAMPLE
    PS> Install-Fonts -Path "C:\FontToInstall\font1.ttf" -Scope System

    .EXAMPLE
    PS> Install-Fonts -Path "C:\FontToInstall\" -Scope User

    .EXAMPLE
    PS> Install-Fonts -Path "C:\FontToInstall\" -RecurseFolder

#>

function Install-Fonts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,
        [ValidateSet('System','User')]
        [String] $Scope = 'System',
        [Switch] $RecurseFolder
    )
    if (-Not(Test-Path -Path $path)) {
        throw("Invalid path provided")
    }

    $FontsType = ("ttf","otf")
    $fontObj = (Get-Item $path)

    if ($fontObj -is [System.IO.DirectoryInfo]) {
        # Le chemin est un dossier 
        # L'attribut Recurse permet de r�cup�rer toutes les polices du dossier et des dossiers contenu dans ce dossier
        if ($RecurseFolder) {
            $Fonts = Get-ChildItem -Path $fontObj -Include ('*.ttf','*.otf') -Recurse
        } else {
            $Fonts = Get-ChildItem -Path $fontObj -Include ('*.ttf','*.otf')
        }

        # Verifie si il a trouver des police d'ecriture
        if (-not($Fonts)) { Write-Host "Aucune police d'�criture touv�" }

    } elseif ($fontObj -is [System.IO.FileInfo]){
        # Le chemin est un fichier
        # On verifie l'extension du fichier
        if (-Not($fontObj.Extension -in $FontsType)) {
            # Le ([system.String]::Join(", ",$tempFontsType)) permet de g�n�rer un string a partir d'un array
            throw('La police est pas de type {0} mais {1}' -f ([system.String]::Join(", ",$tempFontsType)), $fontObj.Extension)
        }

        # affectation de l'objet font pour l'installation plus bas
        $fonts = $fontObj

    } else {
        # Le dossier n'est pas un dossier ni un fichier
        # le double simple quote : '' est la car le premier escape l'autre
        throw('Le chemin fournit n''est pas un fichier ou un dossier, {0} a �t� envoy�' -f $Path.GetType().Name)
    }

    # Install et gestion du scope
    foreach ($font in $fonts) {
        # Le baseName repr�sente le nom du fichier sans l'extension
        # Fullname = chemin complet, Name = nom + extension, basename = juste le nom
        Write-Host "Instalation de la police $($font.BaseName)"
        
        # affecte les chemins et cl� de registre en fonction du Scope choisis
        if ($Scope -eq 'System') {
            $FontDestination = [Environment]::GetFolderPath('Fonts')
            $FontRegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        }
        if ($Scope -eq 'User') {
            # Permet d'avoir le chemin de destination des fonts sur le current user
            $FontDestination = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'Microsoft\Windows\Fonts'
            $FontRegKey = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        }
        # Essaye d'installer la font + gestion d'erreur a l'installation.
        try {
            Copy-Item -Path $font -Destination $FontDestination
            New-ItemProperty -Name $font.BaseName -Path $FontRegKey -PropertyType string -Value $font.name
        } catch {
            Write-Host "Erreur lors de l'installation de la police $($font.BaseName)"
        }
    }
}