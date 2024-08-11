<#
    .SYNOPSIS
    Permets de renommer plusieurs fichiers d'un dossier

    .DESCRIPTION
    Permets de renommer plusieurs fichiers d'un dossier en précisant un prefix, un suffix et même changer l'extension du fichier

    .PARAMETER Path
    Le chemin du dossier

    .PARAMETER Files
    Prends une chaine de caractère ou un tableau de chaine de caractère, fichiers à renommer

    .PARAMETER Prefixe
    Prefixe des éléments a renommer

    .PARAMETER Suffixe
    Suffixe des éléments a renommer

    .PARAMETER Extension
    Si rien n'est précisé, il ne change pas l'extension, si un élément est fourni alors ils aurons tous cette extension et enfin si il s'agit d'une Hashtable (tableau associatif) alors il change l'extension par l'extension désiré

    .INPUTS
    Aucun input, ne prend rien de la pipeline

    .OUTPUTS
    Aucun output, ne génère pas d'output

    .EXAMPLE
    PS> $Files = "File1.txt","File2.bat", "File3.jpg"
    PS> Rename-ItemsFolderAdvanced -Path 'C:\Folder' -Files $Files

    .EXAMPLE
    PS> $Files = "File1.txt","File2.bat", "File3.jpg"
    PS> Rename-ItemsFolderAdvanced -Path 'C:\Folder' -Files $Files -Prefixe "T_" -Suffixe "_S"

    .EXAMPLE
    PS> $Files = "File1.txt","File2.bat", "File3.jpg"
    PS> $Ext = @{".txt" = ".log"; ".jpg" = ".png"; ".bat" = ".txt"}
    PS> Rename-ItemsFolderAdvanced -Path 'C:\Folder' -Files $Files -Prefix "T_" -Suffix "_S" -Extension $Ext

#>

function Rename-ItemsFolderAdvanced {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String] $Path,

        [Parameter(Mandatory)]
        [string[]] $Files,
        [String] $Prefixe = "",
        [String] $Suffixe = "",
        [System.Object]$Extension
    )

    begin {
        if ($Extension -ne $null) {
            if ($Extension.GetType().Name -eq "String") { $type = "String" } 
            elseif ($Extension.GetType().Name -eq "Hashtable") { $type = "HashTable" } 
            else {
                $formatError = New-Object System.FormatException
                throw "L'extension n'est pas un String ou une Hashtable"
            }
        }
    }

    process {
        foreach ($File in $Files) {
            $FilePath = Join-Path -Path $Path -ChildPath $File
            $FileObject = Get-Item -Path $FilePath
            if (Test-Path -Path $FilePath) {
                $newNameBase = $Prefixe + $FileObject.BaseName + $Suffixe
                # Si le type est null
                if ($type -eq $null) { $NewNameComplete = $newNameBase + $FileObject.Extension }
                # Si le type est un string
                elseif ($type -eq "String") { $NewNameComplete = $newNameBase + $Extension }
                # Si le type est un Hashtable
                else {
                    if ($Extension.ContainsKey($FileObject.Extension)) {
                        $NewNameComplete = $newNameBase + $Extension[$FileObject.Extension]
                    }
                    else {
                        $NewNameComplete = $newNameBase + $FileObject.Extension
                    }
                }
                Rename-Item -Path $FilePath -NewName $NewNameComplete
            }
        }
    }

}

