<#
    .SYNOPSIS
    Permets de renommer plusieurs fichiers d'un dossier

    .DESCRIPTION
    Permets de renommer plusieurs fichiers d'un dossier en pr�cisant les noms avant et apr�s

    .PARAMETER DirPath
    Le chemin du dossier

    .PARAMETER Files
    Prends une chaine de caract�re ou un tableau de chaine de caract�re, fichiers � renommer

    .PARAMETER NewNames
    Prends une chaine de caract�re ou un tableau de chaine de caract�re, nouveau nom des fichiers

    .INPUTS
    Ne prend rien de la pipeline

    .OUTPUTS
    Output de console les �l�ments qui ont eu un probl�me

    .EXAMPLE
    PS> rename-ItemsFolder -DirPath "C:\FontToInstall\" -Files "Fichier.txt" -NewNames "Fichier_old.txt"

    .EXAMPLE
    PS> rename-ItemsFolder -DirPath "C:\FontToInstall\" -Files "fichier1.txt","fichier2.txt" -NewNames "fichier1.log","fichier2.log"

#>

function Rename-ItemsFolder {
    <#
    Fonction qui permet de renomer plusieurs fichier d'un même dossier sans avoir a faire de boucle
    #>
    [CmdletBinding()]
    param(
        [string]$DirPath,
        [string[]]$Files,
        [string[]]$NewNames
    )
    # Verifie que le nombre de File est identique au nombre de NewName
    if ($Files.Length -ne $NewNames.Length) {
        throw "le nombre de fichiers à renommer est diff�rent du nombre des nouveaux noms"
    }
    $fichierProbleme = @{}
    $msgNotFound = "Le fichier n'a pas été trouvé"
    $msgError = "Le fichier n'a pas pu être renommé"
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