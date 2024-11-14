# Activer PowerShell Remoting sur la machine distante
$remoteComputer = Read-Host "Veuillez entrer l'IP ou le nom de la machine distante"

# Demander les informations d'authentification une seule fois
$credential = Get-Credential

function Log {
    $LOG_DATE = Get-Date -Format "yyyy-MM-dd"
    $LOG_FILE = "C:\Users\Public\Documents\log_evt_$LOG_DATE.log"
    Add-Content -Path $LOG_FILE -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $($args -join ' ')"
}

# Fonction pour afficher le menu
function Show-Menu {
    Write-Host "===== Menu Informations sur l'Ordinateur =====" -ForegroundColor Red
    Write-Host "----- Informations Système -----" -ForegroundColor Blue
    Write-Host "1. Version de l'OS"
    Write-Host "2. Nombre de disque"
    Write-Host "3. Partition (nombre, nom, FS, taille) par disque"
    Write-Host "----- Applications et Services -----" -ForegroundColor Blue
    Write-Host "4. Liste des applications/paquets installées"
    Write-Host "5. Liste des services en cours d'execution"
    Write-Host "6. Liste des utilisateurs locaux"
    Write-Host "----- Ressources Système -----" -ForegroundColor Blue
    Write-Host "7. Type de CPU, nombre de coeurs, etc."
    Write-Host "8. Mémoire RAM totale"
    Write-Host "9. Utilisation de la RAM"
    Write-Host "10. Utilisation du disque"
    Write-Host "11. Utilisation du processeur"
    Write-Host "12. Revenir au menu précedent"
    Write-Host "13. Quitter"
    Write-Host "==========================="
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

# Lancer le menu dans une boucle
$exitScript = $false
while (-not $exitScript) {
    Show-Menu
    $choice = Read-Host "Sélectionnez une option"

    switch ($choice) {
        '1' {
            Log "Début de la demande d'information sur la Version de l'OS de $remoteComputer"
            Write-Host "Version de l'OS de $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-ComputerInfo | Select-Object OsArchitecture, WindowsVersion, WindowsBuildLabEx }
            Log "Fin de la demande d'information sur la Version de l'OS de $remoteComputer"
        }
        '2' {
            Log "Début de la demande d'information sur le nombre de disque de $remoteComputer"
            Write-Host "Nombre de disque demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Disk | Select-Object Number, FriendlyName, SerialNumber, HealthStatus, OperationalStatus, @{Name="Total Size"; Expression={"{0} GB" -f [math]::round($_.Size / 1GB, 2)}}, PartitionStyle }
            Log "Fin de la demande d'information sur le nombre de disque de $remoteComputer"
        }
        '3' {
            Log "Début de la demande d'information sur le partitionnement du disque de $remoteComputer"
            Write-Host "Partition (nombre, nom, FS, taille) par disque demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Partition | Format-Table -Property DiskNumber, PartitionNumber, DriveLetter, FileSystem, @{Name="Size(GB)"; Expression={[math]::round($_.Size/1GB,2)}} }
            Log "Fin de la demande d'information sur le partitionnement du disque de $remoteComputer"
        }
        '4' {
            Log "Début de la demande d'information sur les applications/paquets installées de $remoteComputer" 
            Write-Host "Liste des applications/paquets installées sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Package | Select-Object Name, Version, Source, ProviderName }
            Log "Fin de la demande d'information sur les applications/paquets installées de $remoteComputer"
        }
        '5' {
            Log "Début de la demande d'information sur les services en cours d'execution de $remoteComputer"
            Write-Host "Liste des services en cours d'execution sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Service | Where-Object {$_.Status -eq "Running"} } 
            Log "Fin de la demande d'information sur les services en cours d'execution de $remoteComputer"
        }
        '6' {
            Log "Début de la demande d'information sur les utilisateurs locaux de $remoteComputer"
            Write-Host "Liste des utilisateurs locaux de $remoteComputer."  
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-LocalUser | Select-Object Name } 
            Log "Fin de la demande d'information sur les utilisateurs locaux de $remoteComputer"
        }
        '7' {
            Log "Début de la demande d'information sur le type de CPU de $remoteComputer"
            Write-Host "Type de CPU, nombre de coeurs de $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-WmiObject -Class Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors }
            Log "Fin de la demande d'information sur le type de CPU de $remoteComputer"
        }
        '8' {
            Log "Début de la demande d'information sur le total de la mémoire RAM de $remoteComputer"
            Write-Host "Mémoire RAM totale sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-WmiObject -Class Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory  }
            Log "Fin de la demande d'information sur le total de la mémoire RAM de $remoteComputer"
        }
        '9' {
            Log "Début de la demande d'information sur l'utilisation de la RAM de $remoteComputer"
            Write-Host "Utilisation de la RAM sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory }
            Log "Fin de la demande d'information sur l'utilisation de la RAM de $remoteComputer"
        }
        '10' {
            Log "Début de la demande d'information sur l'utilisation du disque de $remoteComputer"
            Write-Host "Utilisation du disque sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-PSDrive -PSProvider FileSystem }
            Log "Fin de la demande d'information sur l'utilisation du disque de $remoteComputer"
        }
        '11' {
            Log "Début de la demande d'information sur l'utilisation du processeur de $remoteComputer"
            Write-Host "Utilisation du processeur de $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage }
            Log "Fin de la demande d'information sur l'utilisation du processeur de $remoteComputer"
        }
        '12' {
            Write-Host "Revenir au menu précédent."
            return "C:\Users\Administrateur.WIN-CRQM0S4BP56\Documents\TSSR_PARIS_0924_P2_G3\Powershell_Script\script_windows.ps1" 
        }
        '13' {
            $exitScript = $true
            Write-Host "Quitter le script."
        }
        default {
            Write-Host "Option invalide. Veuillez réessayer."
        }
    }
}
