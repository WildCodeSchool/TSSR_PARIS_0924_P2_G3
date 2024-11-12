# Demander la machine d'intervention
Clear-Host
#$Client = Read-Host -Prompt "Entrez l'adresse IP ou le nom de la machine distante"
#$User = Read-Host -Prompt "Avec quel utilisateur souhaitez-vous vous connecter ?"

# Connexion SSH
#ssh "$User@$Client"

# Fonction pour gérer le Menu utilisateur
function Menu-GestionUser {
    while ($true) {
        Clear-Host
        Write-Output "--- Menu de l'utilisateur ---"
        Write-Output "1) Action sur l'utilisateur"
        Write-Output "2) Information sur l'utilisateur"
        Write-Output "3) Revenir au menu principal"
        Write-Output "4) Quitter"

        $choice = Read-Host -Prompt "Choisissez une option"

        switch ($choice) {
            1 { .\script_action_user.ps1 } # Remplacez par le bon chemin si nécessaire
            2 { .\script_info_user.ps1 }
            3 { return }
            4 { exit }
            default { Write-Output "Option incorrecte" }
        }
    }
}

# Fonction pour gérer le Menu Gestion de l'ordinateur
function Menu-GestionComputer {
    while ($true) {
        Clear-Host
        Write-Output "--- Menu de l'ordinateur ---"
        Write-Output "1) Action sur l'ordinateur"
        Write-Output "2) Information sur l'ordinateur"
        Write-Output "3) Revenir au menu principal"
        Write-Output "4) Quitter"

        $choice = Read-Host -Prompt "Choisissez une option"

        switch ($choice) {
            1 { .\script_action_computer.ps1 } # Remplacez par le bon chemin si nécessaire
            2 { .\script_info_computer.ps1 }
            3 { return }
            4 { exit }
            default { Write-Output "Option incorrecte" }
        }
    }
}

# Menu Journal
function Journal {
    while ($true) {
        Clear-Host
        Write-Output "------- Menu Journal ---------"
        Write-Output "1) Événements sur l'utilisateur"
        Write-Output "2) Événements sur l'ordinateur"
        Write-Output "3) Revenir au menu principal"
        
        $choice = Read-Host -Prompt "Choisissez une option"

        switch ($choice) {
            1 { Write-Output "Ligne de commande log utilisateur" } # Remplacez par la commande appropriée
            2 { Write-Output "Ligne de commande log ordinateur" } # Remplacez par la commande appropriée
            3 { return }
            default { Write-Output "Option incorrecte" }
        }
    }
}

# Menu principal
while ($true) {
    Clear-Host
    Write-Output "--- Menu Principal ---"
    Write-Output "1) Gestion de l'utilisateur"
    Write-Output "2) Gestion de la machine"
    Write-Output "3) Consultation des journaux"
    Write-Output "4) Sortir"

    $choice = Read-Host -Prompt "Choisissez une option"

    switch ($choice) {
        1 { Menu-GestionUser }
        2 { Menu-GestionComputer }
        3 { Journal }
        4 { exit }
        default { Write-Output "Option incorrecte" }
    }
}
