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

# Demande les informations de connexion
function Get-RemoteConnectionInfo {
    $global:RemoteUser = Read-Host "Entrez le nom d'utilisateur distant"
    $global:RemoteHost = Read-Host "Entrez l'adresse IP ou le nom de la machine distante"
    $global:Creds = Get-Credential -UserName $RemoteUser -Message "Entrez les informations d'identification pour $RemoteUser@$RemoteHost"
}

# Fonction d'exécution de commandes à distance
function Execute-RemoteCommand {
    param (
        [string]$Command
    )
    Invoke-Command -ComputerName $RemoteHost -Credential $Creds -ScriptBlock {
        param ($Command) Invoke-Expression $Command
    } -ArgumentList $Command
}

# Fonction de création d'utilisateur
function Create-User {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à créer"
    Log "Début de la création de l'utilisateur $USERNAME sur $RemoteHost"

    Execute-RemoteCommand -Command "if (!(Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue)) { New-LocalUser -Name '$USERNAME' -NoPassword -FullName '$USERNAME'; 'Utilisateur $USERNAME créé !' } else { 'Utilisateur $USERNAME existe déjà.' }"

    Log "Fin de la création de l'utilisateur $USERNAME sur $RemoteHost"
    Ask-Continue
}

# Fonction pour changer le mot de passe d'un utilisateur
function Change-Password {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur pour changer le mot de passe"
    Log "Début du changement de mot de passe pour $USERNAME sur $RemoteHost"

    $NewPassword = Read-Host "Entrez le nouveau mot de passe" -AsSecureString
    $ScriptBlock = {
        param ($User, $Password)
        Set-LocalUser -Name $User -Password $Password
        "Mot de passe changé avec succès pour l'utilisateur $User."
    }

    Invoke-Command -ComputerName $RemoteHost -Credential $Creds -ScriptBlock $ScriptBlock -ArgumentList $USERNAME, $NewPassword

    Log "Fin du changement de mot de passe pour $USERNAME sur $RemoteHost"
    Ask-Continue
}

# Fonction de suppression d'utilisateur
function Delete-User {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à supprimer"
    Log "Début de la suppression de l'utilisateur $USERNAME sur $RemoteHost"

    Execute-RemoteCommand -Command "if (Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue) { Remove-LocalUser -Name '$USERNAME'; 'Utilisateur $USERNAME supprimé.' } else { 'Utilisateur $USERNAME introuvable.' }"

    Log "Fin de la suppression de l'utilisateur $USERNAME sur $RemoteHost"
    Ask-Continue
}

# Fonction d'ajout d'un utilisateur à un groupe
function Add-ToGroup {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à ajouter au groupe"
    $GROUPNAME = Read-Host "Entrez le nom du groupe"
    Log "Début de l'ajout de $USERNAME au groupe $GROUPNAME sur $RemoteHost"

    Execute-RemoteCommand -Command "if (Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue -and Get-LocalGroup -Name '$GROUPNAME' -ErrorAction SilentlyContinue) { Add-LocalGroupMember -Group '$GROUPNAME' -Member '$USERNAME'; 'Utilisateur $USERNAME ajouté au groupe $GROUPNAME.' } else { 'Utilisateur ou groupe introuvable.' }"

    Log "Fin de l'ajout de $USERNAME au groupe $GROUPNAME sur $RemoteHost"
    Ask-Continue
}

# Fonction pour retirer un utilisateur d'un groupe
function Remove-FromGroup {
    Clear-Host
    $USERNAME = Read-Host "Entrez le nom d'utilisateur à retirer du groupe"
    $GROUPNAME = Read-Host "Entrez le nom du groupe"
    Log "Début du retrait de $USERNAME du groupe $GROUPNAME sur $RemoteHost"

    Execute-RemoteCommand -Command "if (Get-LocalUser -Name '$USERNAME' -ErrorAction SilentlyContinue -and Get-LocalGroup -Name '$GROUPNAME' -ErrorAction SilentlyContinue) { Remove-LocalGroupMember -Group '$GROUPNAME' -Member '$USERNAME'; 'Utilisateur $USERNAME retiré du groupe $GROUPNAME.' } else { 'Utilisateur ou groupe introuvable.' }"

    Log "Fin du retrait de $USERNAME du groupe $GROUPNAME sur $RemoteHost"
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
    Write-Host "${RED}------- Actions Disponibles -------${NC}"
    Write-Host "1) Création d'un utilisateur"
    Write-Host "2) Changement de mot de passe"
    Write-Host "3) Suppression d'un utilisateur"
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
        6 { . "C:\Users\Administrator\Documents\TSSR_PARIS_0924_P2_G3\script_windows.ps1" }
        7 { exit }
        default {
            Write-Host "Option incorrecte, veuillez réessayer." -ForegroundColor Red
            Pause
        }
    }
} while ($true)
