# Activer PowerShell Remoting sur la machine distante
$remoteComputer = Read-Host "Veuillez entrer l'IP ou le nom de la machine distante"

# Demander les informations d'authentification une seule fois
$credential = Get-Credential

function Log {
    $LOG_DATE = Get-Date -Format "yyyy-MM-dd"
    $LOG_FILE = "C:\Users\Public\Documents\log_evt_$LOG_DATE.log"
    Add-Content -Path $LOG_FILE -Value "$(Get-Date -Format "yyyy-MM-dd HH:cocktail_tropical:ss") - $($args -join ' ')"

}
# Fonction pour exécuter des commandes à distance
function Execute-RemoteCommand {
    param (
        [string]$remoteComputer,
        [scriptblock]$scriptBlock
    )
    try {
        # Utilise les informations de connexion déjà saisies
        Invoke-Command -ComputerName $remoteComputer -ScriptBlock $scriptBlock -Credential $credential -ErrorAction Stop
    } catch {
        Write-Host "Erreur lors de l'exécution de la commande à distance : $_"
    }
}

# Fonction pour demander le nom d'utilisateur
function Get-UserName {
    Write-Host "$GREEN Entrez le nom de l'utilisateur ciblé :$NC"
    $Global:UserName = Read-Host
}

# Fonction pour demander si l'utilisateur veut continuer
function Ask-Continue {
    do {
        $Response = Read-Host "Souhaitez-vous effectuer une autre action ? (o/n)"
        switch ($Response) {
            "o" { return }
            "n" { exit }
            default { Write-Host "Veuillez entrer 'o' pour oui ou 'n' pour non." }
        }
    } while ($true)
}

# Fonction pour consulter la dernière connexion de l'utilisateur
function Last-Connexion {
    Clear-Host
    Get-UserName
#   Log "Consultation de la dernière connexion de $UserName sur $Client"
    Execute-RemoteCommand -Command "Get-EventLog -LogName Security | Where-Object { $_.EventID -eq 4624 -and $_.ReplacementStrings -like '*$UserName*' } | Select-Object -First 1"
#   Log "Fin consultation de la dernière connexion"
Ask-Continue
}
# Fonction pour consulter la date de dernière modification du mot de passe
function User-Details {
    Clear-Host
    Get-UserName
    Log "Consultation des détails du compte $UserName sur $Client"
    Execute-RemoteCommand -Command "net user $UserName"
    Log "Fin consultation des détails du compte"
    Ask-Continue
}
# Fonction pour lister les sessions ouvertes par l'utilisateur
function User-Open-Sessions {
    Clear-Host
    Get-UserName
    Log "Consultation des sessions ouvertes pour $UserName sur $Client"
    Execute-RemoteCommand -Command "query user | Select-String $UserName"
    Log "Fin de consultation des sessions ouvertes"
    Ask-Continue
}
# Fonction pour consulter les groupes d'appartenance de l'utilisateur
function User-Group {
    Clear-Host
    Get-UserName
    Log "Consultation des groupes d'appartenance pour $UserName sur $Client"
    Execute-RemoteCommand -Command "(Get-ADUser $UserName -Property MemberOf).MemberOf"
    Log "Fin de consultation des groupes d'appartenance"
    Ask-Continue
}
# Fonction pour consulter l'historique des commandes d'un utilisateur
function User-History {
    Clear-Host
    Get-UserName
    Write-Host "$GREEN Combien de lignes d'historique souhaitez-vous voir ?$NC"
    $Lines = Read-Host
    Log "Consultation de l'historique des $Lines dernières commandes pour $UserName sur $Client"
    Execute-RemoteCommand -Command "Get-Content -Path C:\Users\$UserName\AppData\Roaming\Microsoft\Windows\PowerShell\CommandHistory.xml | Select-Object -Last $Lines"
    Log "Fin de consultation de l'historique"
    Ask-Continue
}

# Fonction pour vérifier les permissions sur un fichier ou un dossier
function Check-Permissions {
    Clear-Host
    Get-UserName
    Write-Host "$GREEN Entrez le chemin du fichier ou dossier :$NC"
    $Path = Read-Host
    Log "Consultation des permissions sur $Path"
    RExecute-RemoteCommand -Command "Get-Acl $Path | Format-List"
    Log "Fin consultation des permissions"
    Ask-Continue
}

# Menu Principal

while ($true)  {
    Write-Host "===== Menu information des utilisateurs =====" -ForegroundColor Red
    Write-Host ""
    Write-Host "===== Suivi des utilisateurs =====" -ForegroundColor Blue
    Write-Host "1) Date de dernière connexion d'un utilisateur"
    Write-Host "2) Date de dernière modification du mot de passe"
    Write-Host "3) Liste des sessions ouvertes par l'utilisateur"
    Write-Host "4) Groupe d'appartenance d'un utilisateur"
    Write-Host "5) Historique des commandes exécutées par l'utilisateur"
    Write-Host ""
    Write-Host "===== Droits et permissions =====" -ForegroundColor Blue
    Write-Host "6) Droits d'accès sur un dossier"
    Write-Host "7) Droits d'accès sur un fichier"
    Write-Host ""
    Write-Host "8) Revenir au Menu Précédent"
    Write-Host "9) Quitter le script"
    Write-Host "==========================="

    $choice = Read-Host "Choisissez une option"
    switch ($choice) {
        1 { Last-Connexion }
        2 { User-Details }
        3 { User-Open-Sessions }
        4 { User-Group }
        5 { User-History}
        6 { Check-Permissions }
        7 { Check-Permissions }
        8 {return "C:\Users\Administrateur.WIN-CRQM0S4BP56\Documents\TSSR_PARIS_0924_P2_G3\Powershell_Script\script_windows.ps1"}
        9 { exit }
        default { Write-Host "Option incorrect" }
    }
}
