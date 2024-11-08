# Définition des couleurs
$RED = "`e[31m"
$BLUE = "`e[34m"
$GREEN = "`e[32m"
$NC = "`e[0m"  # Aucune couleur

# Fichier de log
$LOG_FILE = "C:\Users\$env:USERNAME\Documents\log_event.log"
# Fonction de journalisation
function Log-Message {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $LOG_FILE -Append
}
# Appel de la fonction de log pour indiquer que le script est lancé
Log-Message "Le script a été lancé par l'utilisateur $env:USERNAME."
# Fonction pour afficher un sous-menu utilisateur
function Menu-GestionUser {
    while ($true) {
        Clear-Host
        Write-Host -ForegroundColor Red "----- Menu de l'utilisateur -----" $NC
        Write-Host ""
        Write-Host "1) Action sur l'utilisateur"
        Write-Host "2) Information sur l'utilisateur"
        Write-Host "3) Revenir au menu principal"
        Write-Host "4) Quitter"
        $choice = Read-Host "Choisissez une option"
        switch ($choice) {
            1 { .\script_action_user.ps1 }
            2 { .\script_info_user.ps1 }
            3 { break }
            4 { exit }
            Default { Write-Host "Option incorrecte" -ForegroundColor Red }
        }
    }
}
# Fonction pour afficher un sous-menu gestion ordinateur
function Menu-GestionComputer {
    while ($true) {
        Clear-Host
        Write-Host -ForegroundColor Red "----- Menu de l'ordinateur -----" $NC
        Write-Host ""
        Write-Host "1) Action sur l'ordinateur"
        Write-Host "2) Information sur l'ordinateur"
        Write-Host "3) Revenir au menu principal"
        Write-Host "4) Quitter"
        $choice = Read-Host "Choisissez une option"
        switch ($choice) {
            1 { .\script_action_computer.ps1 }
            2 { .\script_info_computer.ps1 }
            3 { break }
            4 { exit }
            Default { Write-Host "Option incorrecte" -ForegroundColor Red }
        }
    }
}
# Fonction pour afficher le menu des journaux
function Journal {
    while ($true) {
        Clear-Host
        Write-Host -ForegroundColor Red "------- Menu Journal ---------" $NC
        Write-Host ""
        Write-Host "1) Événements sur l'utilisateur"
        Write-Host "2) Événements sur l'ordinateur"
        $choice = Read-Host "Choisissez une option"
        switch ($choice) {
            1 { Write-Host "Ligne de commande log user" }
            2 { Write-Host "Ligne de commande log ordinateur" }
            Default { Write-Host "Option incorrecte" -ForegroundColor Red }
        }
    }
}
# Menu principal
while ($true) {
    Clear-Host
    Write-Host -ForegroundColor Red "--- Menu Principal ---" $NC
    Write-Host ""
    Write-Host "1) Gestion de l'utilisateur"
    Write-Host "2) Gestion des ordinateurs clients"
    Write-Host "3) Consultation des journaux"
    Write-Host "4) Sortir"
    $choice = Read-Host "Choisissez une option"
    switch ($choice) {
        1 { Menu-GestionUser }
        2 { Menu-GestionComputer }
        3 { Journal }
        4 { exit }
        Default { Write-Host "Option incorrecte" -ForegroundColor Red }
    }
}
