<#
    .SYNOPSIS
    Permets de renommer plusieurs fichiers d'un dossier

    .DESCRIPTION
    Permets de renommer plusieurs fichiers d'un dossier en précisant les noms avant et après

    .PARAMETER DirPath
    Le chemin du dossier

    .PARAMETER Files
    Prends une chaine de caractère ou un tableau de chaine de caractère, fichiers à renommer

    .PARAMETER NewNames
    Prends une chaine de caractère ou un tableau de chaine de caractère, nouveau nom des fichiers

    .INPUTS
    Ne prend rien de la pipeline

    .OUTPUTS
    Output de console les éléments qui ont eu un problème

    .EXAMPLE
    PS> rename-ItemsFolder -DirPath "C:\FontToInstall\" -Files "Fichier.txt" -NewNames "Fichier_old.txt"

    .EXAMPLE
    PS> rename-ItemsFolder -DirPath "C:\FontToInstall\" -Files "fichier1.txt","fichier2.txt" -NewNames "fichier1.log","fichier2.log"

#>

function Rename-ItemsFolder {
    <#
    Fonction qui permet de renomer plusieurs fichier d'un mÃªme dossier sans avoir a faire de boucle
    #>
    [CmdletBinding()]
    param(
        [string]$DirPath,
        [string[]]$Files,
        [string[]]$NewNames
    )
    # Verifie que le nombre de File est identique au nombre de NewName
    if ($Files.Length -ne $NewNames.Length) {
        throw "le nombre de fichiers Ã  renommer est différent du nombre des nouveaux noms"
    }
    $fichierProbleme = @{}
    $msgNotFound = "Le fichier n'a pas Ã©tÃ© trouvÃ©"
    $msgError = "Le fichier n'a pas pu Ãªtre renommÃ©"
    for ($i=0;$i -le ($Files.Length -1) ;$i++) {
        $path = Join-Path -Path $DirPath -ChildPath $Files[$i]
        $newPath = Join-Path -Path $DirPath -ChildPath $NewNames[$i]
        if(Test-Path -Path $path) {
            Rename-Item -Path $path -NewName $newPath -ErrorAction SilentlyContinue
            if (-not($?)) {
                $fichierProbleme.Add($Files[$i], $msgError)
            }
        } else {
            $fichierProbleme.Add($Files[$i], $msgNotFound)
        }
    }
    return $fichierProbleme
}