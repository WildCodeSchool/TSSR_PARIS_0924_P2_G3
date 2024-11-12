# Activer PowerShell Remoting sur la machine distante
$remoteComputer = Read-Host "Veuillez entrer l'IP ou le nom de la machine distante"

# Fonction pour afficher le menu
function Show-Menu {
    Write-Host "===== Menu d'actions ====="
    Write-Host "1. Arrêt"
    Write-Host "2. Redémarrage"
    Write-Host "3. Verrouillage"
    Write-Host "4. Mise-à-jour du système"
    Write-Host "5. Création de répertoire"
    Write-Host "6. Modification de répertoire"
    Write-Host "7. Suppression de répertoire"
    Write-Host "8. Prise de main à distance (CLI)"
    Write-Host "9. Définition de règles de pare-feu"
    Write-Host "10. Activation du pare-feu"
    Write-Host "11. Désactivation du pare-feu"
    Write-Host "12. Installation de logiciel"
    Write-Host "13. Désinstallation de logiciel"
    Write-Host "14. Exécution de script"
    Write-Host "Q. Quitter"
    Write-Host "==========================="
}

# Fonction pour exécuter des commandes à distance
function Execute-RemoteCommand {
    param (
        [string]$remoteComputer,
        [scriptblock]$scriptBlock
    )

    try {
        Invoke-Command -ComputerName $remoteComputer -ScriptBlock $scriptBlock -Credential (Get-Credential) -ErrorAction Stop
    } catch {
        Write-Host "Erreur lors de l'exécution de la commande à distance : $_"
    }
}

# Lancer le menu dans une boucle
$exitScript = $false
while (-not $exitScript) {
    Show-Menu
    $choice = Read-Host "Sélectionnez une option"

    switch ($choice) {
        '1' {
            Write-Host "Arrêt demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Shutdown-Computer -Force }
        }
        '2' {
            Write-Host "Redémarrage demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Restart-Computer -Force }
        }
        '3' {
            Write-Host "Verrouillage demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { rundll32.exe user32.dll,LockWorkStation }
        }
        '4' {
            Write-Host "Mise à jour du système demandée sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                Start-Process -FilePath "powershell" -ArgumentList "-Command & {Install-WindowsUpdate -AcceptAll -AutoReboot}" -Wait
            }
        }
        '5' {
            $dirPath = Read-Host "Veuillez entrer le chemin du répertoire à créer"
            Write-Host "Création du répertoire $dirPath sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($dirPath)
                New-Item -Path $dirPath -ItemType Directory -Force
            } -ArgumentList $dirPath
        }
        '6' {
            $dirPath = Read-Host "Veuillez entrer le chemin du répertoire à modifier"
            $newName = Read-Host "Veuillez entrer le nouveau nom du répertoire"
            Write-Host "Modification du répertoire $dirPath -> $newName sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($dirPath, $newName)
                Rename-Item -Path $dirPath -NewName $newName
            } -ArgumentList $dirPath, $newName
        }
        '7' {
            $dirPath = Read-Host "Veuillez entrer le chemin du répertoire à supprimer"
            Write-Host "Suppression du répertoire $dirPath sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($dirPath)
                Remove-Item -Path $dirPath -Recurse -Force
            } -ArgumentList $dirPath
        }
        '8' {
            Write-Host "Prise de main à distance demandée sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { mstsc }
        }
        '9' {
            $ruleName = Read-Host "Veuillez entrer le nom de la règle de pare-feu"
            $port = Read-Host "Veuillez entrer le port à ouvrir"
            Write-Host "Définition de la règle de pare-feu $ruleName pour le port $port sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($ruleName, $port)
                New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow
            } -ArgumentList $ruleName, $port
        }
        '10' {
            Write-Host "Activation du pare-feu sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Set-NetFirewallProfile -All -Enabled True }
        }
        '11' {
            Write-Host "Désactivation du pare-feu sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Set-NetFirewallProfile -All -Enabled False }
        }
        '12' {
            $softwareName = Read-Host "Veuillez entrer le nom du logiciel à installer"
            Write-Host "Installation de $softwareName sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($softwareName)
                Start-Process -FilePath "msiexec" -ArgumentList "/i $softwareName"
            } -ArgumentList $softwareName
        }
        '13' {
            $softwareName = Read-Host "Veuillez entrer le nom du logiciel à désinstaller"
            Write-Host "Désinstallation de $softwareName sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($softwareName)
                Start-Process -FilePath "msiexec" -ArgumentList "/x $softwareName"
            } -ArgumentList $softwareName
        }
        '14' {
            $scriptPath = Read-Host "Veuillez entrer le chemin du script à exécuter"
            Write-Host "Exécution du script $scriptPath sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { 
                param($scriptPath)
                & $scriptPath
            } -ArgumentList $scriptPath
        }
        'Q' {
            $exitScript = $true
            Write-Host "Quitter le script."
        }
        default {
            Write-Host "Option invalide. Veuillez réessayer."
        }
    }
}
