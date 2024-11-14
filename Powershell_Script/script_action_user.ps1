<#
.SYNOPSIS
    Script de gestion des utilisateurs et des groupes en PowerShell à distance.
#>

# Définition des couleurs
$RED = "`e[31m"
$BLUE = "`e[34m"
$GREEN = "`e[32m"
$NC = "`e[0m"  # Aucune couleur

# Fonction de journalisation
function Log {
    $LOG_DATE = Get-Date -Format "yyyy-MM-dd"
    $LOG_FILE = "C:\Users\Public\Documents\log_evt_$LOG_DATE.log"
    Add-Content -Path $LOG_FILE -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $($args -join ' ')"
}

# Demander l'IP ou le nom de la machine distante
$remoteComputer = Read-Host "Veuillez entrer l'IP ou le nom de la machine distante"

# Demander les informations d'identification une seule fois
$credential = Get-Credential


# Fonction d'exécution de commandes à distance
function Execute-RemoteCommand {
    param (
        [string]$Command
    )
    Invoke-Command -ComputerName $remoteComputer -Credential $credential -ScriptBlock {
        param ($Command) Invoke-Expression $Command
    } -ArgumentList $Command
}

# Fonction de création d'utilisateur
function Create-User {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à créer"
    Log "Début de la création de l'utilisateur $USERNAME sur $remoteComputer"

    Execute-RemoteCommand -Command "if (!(Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue)) { New-LocalUser -Name '$USERNAME' -NoPassword -FullName '$USERNAME'; 'Utilisateur $USERNAME créé !' } else { 'Utilisateur $USERNAME existe déjà.' }"

    Log "Fin de la création de l'utilisateur $USERNAME sur $remoteComputer"
    Ask-Continue
}

# Fonction pour changer le mot de passe d'un utilisateur
function Change-Password {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur pour changer le mot de passe"
    Log "Début du changement de mot de passe pour $USERNAME sur $remoteComputer"

    $NewPassword = Read-Host "Entrez le nouveau mot de passe" -AsSecureString
    $ScriptBlock = {
        param ($User, $Password)
        Set-LocalUser -Name $User -Password $Password
        "Mot de passe changé avec succès pour l'utilisateur $User."
    }

    Invoke-Command -ComputerName $remoteComputer -Credential $Creds -ScriptBlock $ScriptBlock -ArgumentList $USERNAME, $NewPassword

    Log "Fin du changement de mot de passe pour $USERNAME sur $remoteComputer"
    Ask-Continue
}

# Fonction de suppression d'utilisateur
function Delete-User {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à supprimer"
    Log "Début de la suppression de l'utilisateur $USERNAME sur $remoteComputer"

    Execute-RemoteCommand -Command "if (Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue) { Remove-LocalUser -Name '$USERNAME'; 'Utilisateur $USERNAME supprimé.' } else { 'Utilisateur $USERNAME introuvable.' }"

    Log "Fin de la suppression de l'utilisateur $USERNAME sur $remoteComputer"
    Ask-Continue
}

# Fonction d'ajout d'un utilisateur à un groupe
function Add-ToGroup {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à ajouter au groupe"
    $GROUPNAME = Read-Host "Entrez le nom du groupe"
    Log "Début de l'ajout de $USERNAME au groupe $GROUPNAME sur $remoteComputer"

    Execute-RemoteCommand -Command "if (Get-LocalUser -Name "$USERNAME" -ErrorAction SilentlyContinue -and Get-LocalGroup -Name "$GROUPNAME" -ErrorAction SilentlyContinue) { Add-LocalGroupMember -Group "$GROUPNAME" -Member "$USERNAME"; 'Utilisateur $USERNAME ajouté au groupe $GROUPNAME.' } else { 'Utilisateur ou groupe introuvable.' }"

    Log "Fin de l'ajout de $USERNAME au groupe $GROUPNAME sur $remoteComputer"
    Ask-Continue
}

# Fonction pour retirer un utilisateur d'un groupe
function Remove-FromGroup {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à retirer du groupe"
    $GROUPNAME = Read-Host "Entrez le nom du groupe"
    Log "Début du retrait de $USERNAME du groupe $GROUPNAME sur $remoteComputer"

    Execute-RemoteCommand -Command "if (Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue -and Get-LocalGroup -Name '$GROUPNAME' -ErrorAction SilentlyContinue) { Remove-LocalGroupMember -Group '$GROUPNAME' -Member '$USERNAME'; 'Utilisateur $USERNAME retiré du groupe $GROUPNAME.' } else { 'Utilisateur ou groupe introuvable.' }"

    Log "Fin du retrait de $USERNAME du groupe $GROUPNAME sur $remoteComputer"
    Ask-Continue
}

# Confirmation pour continuer ou quitter
function Ask-Continue {
    do {
        $response = Read-Host "Souhaitez-vous effectuer une autre action ? (o/n)"
    } while ($response -notin @('o', 'O', 'n', 'N'))

    if ($response -in @('n', 'N')) {
        exit
    }
}

# Menu principal
do {
    Clear-Host
    Write-Host "------- Actions Disponibles -------" -ForegroundColor Red
    Write-Host "----- Gestion des Utilisateurs -----" -ForegroundColor Blue
    Write-Host "1) Création d'un utilisateur"
    Write-Host "2) Changement de mot de passe"
    Write-Host "3) Suppression d'un utilisateur"
    Write-Host "----- Gestion des Groupes -----" -ForegroundColor Blue
    Write-Host "4) Ajout à un groupe"
    Write-Host "5) Retrait d'un groupe"
    Write-Host "6) Revenir au Menu principal"
    Write-Host "7) Quitter"

    $choice = Read-Host "Choisissez une option"

    switch ($choice) {
        1 { Create-User }
        2 { Change-Password }
        3 { Delete-User }
        4 { Add-ToGroup }
        5 { Remove-FromGroup }
        6 { . "C:\Users\Administrateur.WIN-CRQM0S4BP56\Documents\TSSR_PARIS_0924_P2_G3\Powershell_Script\script_windows.ps1" }
        7 { exit }
        default {
            Write-Host "Option incorrecte, veuillez réessayer." -ForegroundColor Red
            Pause
        }
    }
} while ($true)
