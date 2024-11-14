# Demander l'IP ou le nom de la machine distante
$remoteComputer = Read-Host "Veuillez entrer l'IP ou le nom de la machine distante"

# Demander les informations d'identification une seule fois
$credential = Get-Credential

function Log {
    $LOG_DATE = Get-Date -Format "yyyy-MM-dd"
    $LOG_FILE = "C:\Users\Public\Documents\log_evt_$LOG_DATE.log"
    Add-Content -Path $LOG_FILE -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $($args -join ' ')"
}


# Fonction pour afficher le menu
function Show-Menu {
    Write-Host "===== Action Disponible =====" -ForegroundColor Red
    Write-Host "----- Gestion de la Machine -----" -ForegroundColor Blue
    Write-Host "1. Arrêt"
    Write-Host "2. Redémarrage"
    Write-Host "3. Verrouillage"
    Write-Host "4. Mise-à-jour du système"
    Write-Host "----- Gestion des Répertoires -----" -ForegroundColor Blue
    Write-Host "5. Création de répertoire"
    Write-Host "6. Modification de répertoire"
    Write-Host "7. Suppression de répertoire"
    Write-Host "----- Gestion du Pare-feu -----" -ForegroundColor Blue
    Write-Host "8. Définition de règles de pare-feu"
    Write-Host "9. Activation du pare-feu"
    Write-Host "10. Désactivation du pare-feu"
    Write-Host "----- Gestion des Logiciels -----" -ForegroundColor Blue
    Write-Host "11. Installation de logiciel"
    Write-Host "12. Désinstallation de logiciel"
     Write-Host "----- Contrôle à Distance -----" -ForegroundColor Blue
    Write-Host "13. Prise de main à distance (CLI)"
    Write-Host "14. Exécution de script"
    Write-Host "15. Revenir au Menu précedent"
    Write-Host "16. Quitter"
    Write-Host "==========================="
}

# Fonction pour exécuter des commandes à distance
function Execute-RemoteCommand {
    param (
        [string]$remoteComputer,
        [scriptblock]$scriptBlock,
        [pscredential]$credential
    )

    try {
        Invoke-Command -ComputerName $remoteComputer -ScriptBlock $scriptBlock -Credential $credential -ErrorAction Stop
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
            Log "Début d'Arrêt demandé sur $remoteComputer."
            Write-Host "Arrêt demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Shutdown-Computer -Force } -credential $credential
            Log "Fin d'Arrêt demandé sur $remoteComputer."
        }
        '2' {
           Log "Début de Redémarrage demandé sur $remoteComputer."
            Write-Host "Redémarrage demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Restart-Computer -Force } -credential $credential
            Log "Fin de Redémarrage demandé sur $remoteComputer."
        }
        '3' {
            Log "Début de Verrouillage demandé sur $remoteComputer."
            Write-Host "Verrouillage demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { rundll32.exe user32.dll,LockWorkStation } -credential $credential
             Log "Fin de Verrouillage demandé sur $remoteComputer."
        }
        '4' {
            Log "Début de Mise à jour du système demandée sur $remoteComputer"
            Write-Host "Mise à jour du système demandée sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                Start-Process -FilePath "powershell" -ArgumentList "-Command & {Install-WindowsUpdate -AcceptAll -AutoReboot}" -Wait
            } -credential $credential
            Log "Fin de Mise à jour du système demandée sur $remoteComputer"
        }
        '5' {
                $dirPath = Read-Host "Veuillez entrer le chemin du répertoire à créer"
                Log "Début de Création du répertoire $dirPath sur $remoteComputer."
                Write-Host "Création du répertoire $dirPath sur $remoteComputer."
            
                # Exécution de la commande à distance avec le paramètre correctement transmis
                Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                    param($dirPath)  # Paramètre attendu dans le scriptblock à distance
                    New-Item -Path $dirPath -ItemType Directory -Force  # Utilisation de ce paramètre
                } -ArgumentList $dirPath -credential $credential
                Log "Fin de Création du répertoire $dirPath sur $remoteComputer."
            }
        '6' {
            $dirPath = Read-Host "Veuillez entrer le chemin du répertoire à modifier"
            $newName = Read-Host "Veuillez entrer le nouveau nom du répertoire"
            Log "Début de Modification du répertoire $dirPath -> $newName sur $remoteComputer."
            Write-Host "Modification du répertoire $dirPath -> $newName sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($dirPath, $newName)
                Rename-Item -Path $dirPath -NewName $newName
            } -ArgumentList $dirPath, $newName -credential $credential
            Log "Fin de Modification du répertoire $dirPath -> $newName sur $remoteComputer."
        }
        '7' {
            $dirPath = Read-Host "Veuillez entrer le chemin du répertoire à supprimer"
            Log "Début de Suppression du répertoire $dirPath sur $remoteComputer."
            Write-Host "Suppression du répertoire $dirPath sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($dirPath)
                Remove-Item -Path $dirPath -Recurse -Force
            } -ArgumentList $dirPath -credential $credential
            Log "Fin de Suppression du répertoire $dirPath sur $remoteComputer."
        }
        '8' {
            $ruleName = Read-Host "Veuillez entrer le nom de la règle de pare-feu"
            $port = Read-Host "Veuillez entrer le port à ouvrir"
            Log "Début de Définition de la règle de pare-feu $ruleName pour le port $port sur $remoteComputer."
            Write-Host "Définition de la règle de pare-feu $ruleName pour le port $port sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($ruleName, $port)
                New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow
            } -ArgumentList $ruleName, $port -credential $credential
            Log "Fin de Définition de la règle de pare-feu $ruleName pour le port $port sur $remoteComputer."
        }
        '9' {
            Write-Host "Activation du pare-feu sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Set-NetFirewallProfile -All -Enabled True } -credential $credential
        }
        '10' {
            Log "Début de Désactivation du pare-feu sur $remoteComputer."
            Write-Host "Désactivation du pare-feu sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Set-NetFirewallProfile -All -Enabled False } -credential $credential
            Log "Fin de Désactivation du pare-feu sur $remoteComputer."
        }
        '11' {
            $softwareName = Read-Host "Veuillez entrer le nom du logiciel à installer"
            Log "Début d'Installation de $softwareName sur $remoteComputer."
            Write-Host "Installation de $softwareName sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($softwareName)
                Start-Process -FilePath "msiexec" -ArgumentList "/i $softwareName"
            } -ArgumentList $softwareName -credential $credential
            Log "Fin d'Installation de $softwareName sur $remoteComputer."
        }
        '12' {
            $softwareName = Read-Host "Veuillez entrer le nom du logiciel à désinstaller"
            Log "Début de Désinstallation de $softwareName sur $remoteComputer."
            Write-Host "Désinstallation de $softwareName sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock {
                param($softwareName)
                Start-Process -FilePath "msiexec" -ArgumentList "/x $softwareName"
            } -ArgumentList $softwareName -credential $credential
            Log "Fin de Désinstallation de $softwareName sur $remoteComputer."
        }
        '13' {
            Log "Début de Prise de main à distance demandée sur $remoteComputer."
            Write-Host "Prise de main à distance demandée sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { mstsc } -credential $credential
            Log "Fin de Prise de main à distance demandée sur $remoteComputer."
        }
        '14' {
            $scriptPath = Read-Host "Veuillez entrer le chemin du script à exécuter"
            Log "Début d'Exécution du script $scriptPath sur $remoteComputer."
            Write-Host "Exécution du script $scriptPath sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { 
                param($scriptPath)
                & $scriptPath
            } -ArgumentList $scriptPath -credential $credential
            Log "Fin d'Exécution du script $scriptPath sur $remoteComputer."
        }
        '15' {
            return "C:\Users\Administrateur.WIN-CRQM0S4BP56\Documents\TSSR_PARIS_0924_P2_G3\Powershell_Script\script_windows.ps1" 
        }
        '16' {
            $exitScript = $true
            Write-Host "Quitter le script."
        }
        default {
            Write-Host "Option invalide. Veuillez réessayer."
        }
    }
}
