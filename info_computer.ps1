# Activer PowerShell Remoting sur la machine distante
$remoteComputer = Read-Host "Veuillez entrer l'IP ou le nom de la machine distante"

# Demander les informations d'authentification une seule fois
$credential = Get-Credential

# Fonction pour afficher le menu
function Show-Menu {
    Write-Host "===== Menu d'actions ====="
    Write-Host "1. Version de l'OS"
    Write-Host "2. Nombre de disque"
    Write-Host "3. Partition (nombre, nom, FS, taille) par disque"
    Write-Host "4. Liste des applications/paquets installées"
    Write-Host "5. Liste des services en cours d'execution"
    Write-Host "6. Liste des utilisateurs locaux"
    Write-Host "7. Type de CPU, nombre de coeurs, etc."
    Write-Host "8. Mémoire RAM totale"
    Write-Host "9. Utilisation de la RAM"
    Write-Host "10. Utilisation du disque"
    Write-Host "11. Utilisation du processeur"
    Write-Host "12. Revenir au menu précedent"
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
            Write-Host "Version de l'OS de $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-ComputerInfo | Select-Object OsArchitecture, WindowsVersion, WindowsBuildLabEx }
        }
        '2' {
            Write-Host "Nombre de disque demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Disk | Select-Object Number, FriendlyName, SerialNumber, HealthStatus, OperationalStatus, @{Name="Total Size"; Expression={"{0} GB" -f [math]::round($_.Size / 1GB, 2)}}, PartitionStyle }
        }
        '3' {
            Write-Host "Partition (nombre, nom, FS, taille) par disque demandé sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Partition | Format-Table -Property DiskNumber, PartitionNumber, DriveLetter, FileSystem, @{Name="Size(GB)"; Expression={[math]::round($_.Size/1GB,2)}} }
        }
        '4' {
            Write-Host "Liste des applications/paquets installées sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Package | Select-Object Name, Version, Source, ProviderName }
        }
        '5' {
            Write-Host "Liste des services en cours d'execution sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-Service | Where-Object {$_.Status -eq "Running"} } 
        }
        '6' {
            Write-Host "Liste des utilisateurs locaux de $remoteComputer."  
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-LocalUser | Select-Object Name } 
        }
        '7' {
            Write-Host "Type de CPU, nombre de coeurs, etc. de $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-WmiObject -Class Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors }
        }
        '8' {
            Write-Host "Mémoire RAM totale sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-WmiObject -Class Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory  }
        }
        '9' {
            Write-Host "Utilisation de la RAM sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory }
        }
        '10' {
            Write-Host "Utilisation du disque sur $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-PSDrive -PSProvider FileSystem }
        }
        '11' {
            Write-Host "Utilisation du processeur de $remoteComputer."
            Execute-RemoteCommand -remoteComputer $remoteComputer -scriptBlock { Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage }
        }
        '12' {
            Write-Host "Revenir au menu précédent."
            # Ici tu peux ajouter des actions spécifiques pour cette option si nécessaire.
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
