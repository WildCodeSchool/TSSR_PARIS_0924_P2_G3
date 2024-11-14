
## Sommaire
1. [Introduction](#introduction)
2. [Prérequis](#prérequis)
3. [Installation et Configuration](#installation-et-configuration)
4. [Fonctionnalités des scripts](#fonctionnalités-des-scripts)
   - [Structure des scripts](#structure-des-scripts)
   - [Fonctions communes à chaque script](#fonctions-communes-à-chaque-script) 
   - [Commandes préconfigurées](#commandes-préconfigurées)
1. [Utilisation de Base](#utilisation-de-base)
   - [Exécution du Script Debian/Ubuntu via SSH](#exécution-du-script-debianubuntu-via-ssh)
   - [Exécution du Script Windows via PowerShell](#exécution-du-script-windows-via-powershell)

2. [Problèmes courants et solutions](#problèmes-courants-et-solutions)
3. [Conclusion](#conclusion)


## Introduction

L'utilisateur a accès à deux scripts permettant d'interagir avec des machines distantes via SSH pour un serveur Debian et via PowerShell pour un serveur Windows. 
Les scripts sont conçus pour automatiser des actions et des requêtes d'informations sur des machines distantes, tout en journalisant chaque action dans un fichier `log.event` situé dans le dossier personnel de l'utilisateur.

L'objectif est de permettre à un utilisateur d'exécuter des commandes sur des machines distantes (Ubuntu/Debian via SSH, Windows via PowerShell), de choisir dynamiquement la machine et l'utilisateur pour chaque action, et de consulter un fichier de log des actions réalisées.

## Prérequis 

Avant d'utiliser ce script assurez vous des éléments suivants : 

 1. **Serveurs à Distance**
Toutes les machines doivent etre sur le même réseau. 

2. **Accès Utilisateur**
L'utilisateur doit disposer des informations d'identification pour se connecter aux machines distantes. Cela inclut :
- Le nom d'utilisateur et le mot de passe pour Debian/Ubuntu.
- Le nom d'utilisateur et le mot de passe pour les sessions PowerShell sur Windows.

 3. **Permissions**
Les utilisateurs doivent disposer des permissions nécessaires pour exécuter des actions à distance et accéder aux ressources qu'ils manipulent.

## Installation et Configuration

Récupérez le script en le téléchargeant depuis le dépôt git@github.com:WildCodeSchool/TSSR_PARIS_0924_P2_G3.git ou en clonant le dépôt avec git clone.


## Fonctionnalités des scripts

#### Structure des scripts 

Les scripts principaux sont divisés en quatre sous-scripts distincts, chacun étant responsable d'une tâche spécifique. 
Ces sous-scripts sont appelés et exécutés depuis le script principal :

- **`action_user`** : Gère les interactions sur les utilisateurs locaux
- **`action_computer`** : Exécute les actions à distance sur la machine cible 
- **`info_user`** : Affiche les informations concernant les utilisateurs locaux 
- **`info_computer`** : Affiche les informations concernant la machine distante 

Cette approche de diviser chaque action principale en quatre parties permet de créer un script plus modulaire, plus lisible et plus facile à maintenir. Cela rend également le script plus flexible, car chaque partie peut être réutilisée et modifiée indépendamment . Ce découpage améliore l'évolutivité et la gestion des erreurs.

Le principal risque est que la modularité crée des dépendances entre les sous-scripts. Si l'un d'eux est supprimé, déplacé ou modifié sans mise à jour des références, cela peut casser l'ensemble du système. Une bonne gestion des chemins d'accès, des tests et des contrôles d'intégrité entre les scripts est nécessaire pour éviter ces problèmes.


#### Fonctions communes à chaque script 

- **Fonction de journalisation**

Chaque script dispose d'une fonction "log" qui permet de créer un fichier de log avec une date spécifique au format `log_evt_YYYY-MM-DD.log`.
Chaque jour, elle génère un fichier de log distinct dans le répertoire `/home/wilder/Documents/`. 

- **Connexion à distance**

Les fonctions "get_connection_info" et "$credential"  récupèrent les informations de connexion à distance.
Il vous sera demander d'entrer l'adresse IP de la machine, le nom de l'utilisateur avec lequel vous souhaitez vous connecter sur la machine distante puis de saisir son mot de passe.

Sur Debian , la fonction `ssh_exe` exécute la commande sur la machine distante via SSH, en utilisant les informations fournies par l'utilisateur dans la fonction get_connection_info.
Il vous sera demander de fournir les informations de connexions avant chaque nouvelle action.
Ce qui offre la possibilité gérer plusieurs clients depuis le même script.

Sur Windows Server, la session est ouverte une seule fois au début du script avec `New-PSSession`. Lorsque l'utilisateur choisit une action, le script exécute la commande correspondante via la session persistante en utilisant `Invoke-Command` sur cette session.
Pour changer de client il faut sortir du script et relancer une nouvelle session.

- **Poursuite du script**

 Sur Debian, à la fin de chaque action la fonction "ask_user" demande à l'utilisateur s'il souhaite continuer avec une autre action ou quitter le script. 
 Sur Windows Server le menu se réaffiche automatiquement , l'utilisateur peut choisir de quitter le script à ce moment la.

#### Commandes préconfigurées 
 
| Tâche                                                                    | Bash                                                         | Powershell                                                                                                                                                                              |
| ------------------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Création de compte utilisateur local                                     | useradd                                                      | New-LocalUser "" -Password (ConvertTo-SecureString "" -AsPlainText -Force) -FullName "Nom " -Description ""                                                                             |
| Changement de mot de passe                                               | echo "nom_utilisateur:nouveau_mot_de_passe" \| sudo chpasswd | Set-LocalUser -Name "" -Password (ConvertTo-SecureString "" -AsPlainText -Force)                                                                                                        |
| Suppression de compte utilisateur local                                  | userdel -r -f                                                | Remove-LocalUser -Name ""                                                                                                                                                               |
| Désactivation de compte utilisateur local                                | usermod -L                                                   | Disable-LocalUser -Name ""                                                                                                                                                              |
| Ajout à un groupe local                                                  | usermod -aG                                                  | Add-LocalGroupMember -Group "" -Member ""                                                                                                                                               |
| Sortie d’un groupe local                                                 | gpasswd                                                      | Remove-LocalGroupMember -Group "" -Member ""                                                                                                                                            |
| Arrêt                                                                    | shutdown now                                                 | Stop-Computer -Force                                                                                                                                                                    |
| Redémarrage                                                              | reboot                                                       | Restart-Computer                                                                                                                                                                        |
| Verrouillage                                                             | vlock                                                        | rundll32.exe user32.dll,LockWorkStation                                                                                                                                                 |
| Mise-à-jour du système                                                   | apt update && apt upgrade -y                                 | Install-WindowsUpdate -AcceptAll -AutoReboot                                                                                                                                            |
| Création de répertoire                                                   | mkdir -p                                                     | New-Item -ItemType Directory -Path                                                                                                                                                      |
| Modification de répertoire                                               | mv                                                           | Move-Item -Path "" -Destination ""                                                                                                                                                      |
| Suppression de répertoire                                                | rmdir                                                        | Remove-Item -Path "" -Recurse                                                                                                                                                           |
| Prise de main à distance (CLI)                                           | ssh user@client                                              | Enter-PSSession -ComputerName client -Credential (Get-Credential)                                                                                                                       |
| Définition de règles de pare-feu                                         | uwf "action" from "ip" to any port "num_du_port"             | New-NetFirewallRule -DisplayName "Nom de la règle" -Direction Inbound -Protocol TCP -Action Allow -RemoteAddress "ip_address" -LocalPort "numéro_du_port"                               |
| Activation du pare-feu                                                   | ufw enable                                                   | Set-NetFirewallProfile -Enabled True                                                                                                                                                    |
| Désactivation du pare-feu                                                | ufw disable                                                  | Set-NetFirewallProfile -Enabled False                                                                                                                                                   |
| Installation de logiciel                                                 | apt-get install -y                                           | Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient) |
| Désinstallation de logiciel                                              | apt-get remove --purge -y                                    | Get-WmiObject -Class Win32_Product -Filter "Name = 'Nom_du_logiciel'" \| ForEach-Object { $_.Uninstall() }                                                                              |
| Exécution de script sur la machine distante                              | ssh user@client "bash -s" <"chemin_du_script"                | Invoke-Command -ComputerName client -ScriptBlock {  } -Credential ()                                                                                                                    |
| Date de dernière connexion d’un utilisateur                              | last -n 1                                                    | Get-EventLog -LogName Security -InstanceId 528                                                                                                                                          |
| Date de dernière modification du mot de passe                            | chage -l \| grep "Dernière modification du mot de passe"     | Get-LocalUser -Name "" \| Select-Object Name, PasswordLastSet                                                                                                                           |
| Liste des sessions ouvertes par l'utilisateur                            | who \| grep "nom_utilisateur"                                | quser                                                                                                                                                                                   |
| Groupe d’appartenance d’un utilisateur                                   | groups                                                       | Get-LocalUser -Name "nom_utilisateur"                                                                                                                                                   |
| Historique des commandes exécutées par l'utilisateur                     | tail -n                                                      | Get-WinEvent -LogName "Windows PowerShell"                                                                                                                                              |
| Droits/permissions de l’utilisateur sur un dossier                       | ls -ld                                                       | Get-Acl "chemindudossier"                                                                                                                                                               |
| Droits/permissions de l’utilisateur sur un fichier                       | ls -l                                                        | Get-Acl "chemindufichier"                                                                                                                                                               |
| Version de l'OS                                                          | lsb_release -a                                               | Get-ComputerInfo                                                                                                                                                                        |
| Nombre de disque                                                         | fdisk -l                                                     | Get-Disk                                                                                                                                                                                |
| Partition (nombre, nom, FS, taille) par disque                           | lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT                         | Get-Partition                                                                                                                                                                           |
| Liste des applications/paquets installées                                | dpkg -l                                                      | Get-WmiObject -Class Win32_Product                                                                                                                                                      |
| Liste des services en cours d'execution                                  | systemctl list-units --type=service --state=running          | Get-Service                                                                                                                                                                             |
| Liste des utilisateurs locaux                                            | cut -d: -f1 /etc/passwd                                      | Get-LocalUser                                                                                                                                                                           |
| Type de CPU, nombre de coeurs, etc.                                      | lscpu                                                        | Get-WmiObject -Class Win32_Processor                                                                                                                                                    |
| Mémoire RAM totale                                                       | free -h -t                                                   | Get-WmiObject -Class Win32_OperatingSystem                                                                                                                                              |
| Utilisation de la RAM                                                    | free -h \| grep "Mem" \| awk {"print $3"]                    | (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory                                                                                                                         |
| Utilisation du disque                                                    | df -h                                                        | Get-PSDrive -PSProvider FileSystem                                                                                                                                                      |
| Utilisation du processeur                                                | top -b -n1 \| grep "CPU(s)"                                  | Get-WmiObject -Class Win32_Processor                                                                                                                                                    |
| Recherche des evenements dans le fichier log_evt.log pour un utilisateur | cat fichier_log \| grep nom_utilisateur                      | Select-String -Path "" -Pattern ""                                                                                                                                                      |
| Recherche des evenements dans le fichier log_evt.log pour un ordinateur  | cat fichier_log \| grep ip                                   | Select-String -Path "" -Pattern ""                                                                                                                                                      |

## Utilisation de Base

### Exécution du Script Debian/Ubuntu via SSH

 1. Ouvrir un terminal sur la machine locale.
2. Exécuter le script en utilisant la commande suivante :
   ```bash
   ./script_debian.sh
   ```
3. Le script affiche un menu avec les options disponibles, les commandes sont déjà configurés pour s'exécuter à distance. 
![menushell](https://github.com/user-attachments/assets/63c7b618-c95f-4ff1-8f70-a9947d7fe8b0)
Suivez les instructions pour naviguer dans le menu.

4. Le script demandera à l'utilisateur de spécifier les informations suivantes :
   - **Nom de l'utilisateur distant** : Entrez l'utilisateur sous lequel vous souhaitez vous connecter à la machine distante.(ex: wilder)
   - **Adresse IP ou nom de la machine distante** : Entrez l'IP ou le nom d'hôte de la machine distante (ex : 172.16.10.30).
   - Dans certains script le nom de l'utilisateur sur lequel l'action doit être effectué
5. Le résultat de l'exécution sera affiché à l'écran et enregistré dans le fichier `log.event`

 ### Exécution du Script Windows via PowerShell

1. Ouvrir PowerShell en tant qu'administrateur sur la machine locale.
2. Exécuter le script PowerShell avec la commande suivante :
   ```powershell
   .\script_windows.ps1
   ```
3. Le script affiche un menu avec les options disponibles, les commandes sont déjà configuré pour s'exécuter à distance.
![menushell](https://github.com/user-attachments/assets/7796cf1b-fe82-46b8-8926-035d7223f011)
Suivez les instructions pour naviguer dans les options. 

6. Le script demandera à l'utilisateur de spécifier les informations suivantes :
- **Adresse IP ou nom de la machine distante** : Entrez l'IP de la machine distante (ex : `172.16.10.20`).
- **Nom de l'utilisateur distant** : Entrez l'utilisateur sous lequel vous souhaitez vous connecter à la machine distante.(ex: wilder)
   - Dans certains script le nom de l'utilisateur sur lequel l'action doit être effectué
5. Le résultat de l'exécution sera affiché à l'écran et enregistré dans le fichier `log.event`


## Problèmes courants et solutions

 1. **Problème de Connexion SSH (Debian/Ubuntu)**
- **Erreur de connexion** : Vérifiez que le service SSH est actif sur la machine distante. Assurez vous que l'adresse IP et les informations d'identification sont correctes.

 2. **Problème de Connexion PowerShell (Windows)**
- **Erreur de connexion** : Vérifiez que PowerShell Remoting est activé sur la machine distante (`Enable-PSRemoting`).
- **Droits d'accès** : L'utilisateur distant doit être membre du groupe "Remote Management Users" ou avoir des droits d'administrateur.

 3. **Problèmes de Journalisation**
- **Accès au fichier log.event** : Vérifiez que l'utilisateur dispose des droits en écriture sur son dossier personnel pour enregistrer le fichier de log.

4. **Problèmes de droit d'exécution des commandes**
- **Droits d'accès** : L'utilisateur distant doit avoir des permissions suffisantes pour exécuter les commandes demandées.
Si nécessaire exécutez la partie du script avec l'utilisateur root.

## Conclusion

Ces scripts offrent une méthode flexible pour exécuter des actions distantes sur des serveurs Debian/Ubuntu et Windows, tout en garantissant la sécurité et la traçabilité des opérations .
Ils permettent aux utilisateurs de gérer plusieurs machines sur le même réseau à partir d'un même terminal, en toute simplicité.
