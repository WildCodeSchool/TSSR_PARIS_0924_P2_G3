<#
.SYNOPSIS
    Script de gestion des utilisateurs et des groupes en PowerShell.
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

# Demande le nom d'utilisateur
function Get-UserName {
    param (
        [string]$Prompt
    )
    Read-Host $Prompt
}

# Demande le nom de groupe
function Get-GroupName {
    Read-Host "Entrez le nom du groupe"
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
# Fonction de création d'utilisateur
function Create-User {
    Clear-Host
    $USERNAME = Get-UserName -Prompt "Entrez le nom d'utilisateur à créer"
    Log "Début de la création de l'utilisateur $USERNAME"
        if (Get-LocalUser -Name $USERNAME -ErrorAction SilentlyContinue) {
        Write-Host "$USERNAME existe déjà" -ForegroundColor Red
    } else {
        New-LocalUser -Name $USERNAME -NoPassword -FullName $USERNAME
        Write-Host "Utilisateur $USERNAME créé !" -ForegroundColor Green
    }

    Log "Fin de la création de l'utilisateur $USERNAME"
    Ask-Continue
}

# Fonction pour changer le mot de passe d'un utilisateur
function Change-Password {
    Clear-Host
    $USERNAME = Get-UserName -Prompt "Entrez le nom d'utilisateur pour changer le mot de passe"
    Log "Début du changement de mot de passe pour $USERNAME"

    if (Get-LocalUser -Name $USERNAME -ErrorAction SilentlyContinue) {
        $NewPassword = Read-Host "Entrez le nouveau mot de passe" -AsSecureString
        Set-LocalUser -Name $USERNAME -Password $NewPassword
        Write-Host "Mot de passe changé avec succès" -ForegroundColor Green
    } else {
        Write-Host "Utilisateur $USERNAME introuvable" -ForegroundColor Red
    }

    Log "Fin du changement de mot de passe pour $USERNAME"
    Ask-Continue
}

# Fonction de suppression d'utilisateur
function Delete-User {
    Clear-Host
    $USERNAME = Get-UserName -Prompt "Entrez le nom d'utilisateur à supprimer"
    Log "Début de la suppression de l'utilisateur $USERNAME"

    if (Get-LocalUser -Name $USERNAME -ErrorAction SilentlyContinue) {
        Remove-LocalUser -Name $USERNAME
        Write-Host "Utilisateur $USERNAME supprimé !" -ForegroundColor Green
    } else {
        Write-Host "Utilisateur $USERNAME introuvable" -ForegroundColor Red
    }

    Log "Fin de la suppression de l'utilisateur $USERNAME"
    Ask-Continue
}

# Fonction de désactivation d'utilisateur
function Disable-User {
    Clear-Host
    $USERNAME = Get-UserName -Prompt "Entrez le nom d'utilisateur à désactiver"
    Log "Début de la désactivation de l'utilisateur $USERNAME"

    if (Get-LocalUser -Name $USERNAME -ErrorAction SilentlyContinue) {
        Disable-LocalUser -Name $USERNAME
        Write-Host "Utilisateur $USERNAME désactivé !" -ForegroundColor Green
    } else {
        Write-Host "Utilisateur $USERNAME introuvable" -ForegroundColor Red
    }

    Log "Fin de la désactivation de l'utilisateur $USERNAME"
    Ask-Continue
}

# Fonction d'ajout d'un utilisateur à un groupe
function Add-ToGroup {
    Clear-Host
    $USERNAME = Get-UserName -Prompt "Entrez le nom d'utilisateur à ajouter au groupe"
    $GROUPNAME = Get-GroupName
    Log "Début de l'ajout de $USERNAME au groupe $GROUPNAME"

    if (Get-LocalUser -Name $USERNAME -ErrorAction SilentlyContinue -and Get-LocalGroup -Name $GROUPNAME -ErrorAction SilentlyContinue) {
        Add-LocalGroupMember -Group $GROUPNAME -Member $USERNAME
        Write-Host "$USERNAME ajouté au groupe $GROUPNAME !" -ForegroundColor Green
    } else {
        Write-Host "Utilisateur ou groupe introuvable" -ForegroundColor Red
    }

    Log "Fin de l'ajout de $USERNAME au groupe $GROUPNAME"
    Ask-Continue
}

# Fonction pour retirer un utilisateur d'un groupe
function Remove-FromGroup {
    Clear-Host
    $USERNAME = Get-UserName -Prompt "Entrez le nom d'utilisateur à retirer du groupe"
    $GROUPNAME = Get-GroupName
    Log "Début du retrait de $USERNAME du groupe $GROUPNAME"

    if (Get-LocalUser -Name $USERNAME -ErrorAction SilentlyContinue -and Get-LocalGroup -Name $GROUPNAME -ErrorAction SilentlyContinue) {
        Remove-LocalGroupMember -Group $GROUPNAME -Member $USERNAME
        Write-Host "$USERNAME retiré du groupe $GROUPNAME !" -ForegroundColor Green
    } else {
        Write-Host "Utilisateur ou groupe introuvable" -ForegroundColor Red
    }

    Log "Fin du retrait de $USERNAME du groupe $GROUPNAME"
    Ask-Continue
}

# Menu principal
do {
    Clear-Host
    Write-Host "${RED}------- Actions Disponibles -------${NC}"
    Write-Host "1) Création d'un utilisateur"
    Write-Host "2) Changement de mot de passe"
    Write-Host "3) Suppression d'un utilisateur"
    Write-Host "4) Désactivation d'un utilisateur"
    Write-Host "5) Ajout à un groupe"
    Write-Host "6) Retrait d'un groupe"
    Write-Host "7) Revenir au Menu principal"
    Write-Host "8) Quitter"

    $choice = Read-Host "Choisissez une option"

    switch ($choice) {
        1 { Create-User }
        2 { Change-Password }
        3 { Delete-User }
        4 { Disable-User }
        5 { Add-ToGroup }
        6 { Remove-FromGroup }
        7 { return  C:\Users\Administrator\Documents\TSSR_PARIS_0924_P2_G3\script_windows.ps1 }  # Retour au menu principal
        8 { exit }
    
        default {
            Write-Host "Option incorrecte, veuillez réessayer." -ForegroundColor Red
            Pause
        }
    }
} while ($true)

