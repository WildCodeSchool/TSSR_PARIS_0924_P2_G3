# Guide Administrateur : Projet de Scripts de Gestion à Distance

## Sommaire 

1. [Introduction](#introduction)
2. [Prérequis Techniques](#prerequis)
   - [Server Debian et Ubuntu](#server-debian-et-ubuntu)
      - [Permissions utilisateurs](#IPermissions-Utilisateurs)
      - [Connexion à distance via SSH](#Connexion-à-distance-via-SSH)
      - [Gestion des pare-feu : UFW](#pare-feus)   
   - [ Server Windows]
      - [Permissions utilisateurs](#IPermissions-Utilisateurs)
      - [Connexion à distance via PowerShell Remoting](#Connexion-à-distance-via-Powershell-Remoting)
      - [Gestion des pare-feu : ](#pare-feus)  
3. [Téléchargement et configuration des scripts](#intallation-et-configuration-des-scripts)
4. [Fonctionnalités des scripts](#fonctionnalites-des-scripts)
   - [Fonctions commune à chaque script](#Fonctions-commune-a-chaque-script)
   - [Liste des commandes préconfigurées](#Liste-des-commandes-preconfigurees)
5. [Exécution des scripts](#execution-des-scripts)
6. [Axe d'amélioration possible](#axe-damelioration-possible)
   

## Introduction

## Prérequis Techniques

### 2.1. Serveurs Debian et Ubuntu

#### 2.1.1. Permissions utilisateurs
L'utilisateur distant doit avoir les permissions nécessaires pour exécuter les commandes que vous souhaitez. Pour des actions administratives, il est recommandé d'avoir des privilèges `sudo`.
Certains script devront s'exécuter avec le root.

#### 2.1.2. Connexion à distance via SSH
1.**Installation de SSH :**
   Sur chaque machine Debian/Ubuntu, vous devez vous assurer que le service SSH est installé et actif.
   ```bash
   sudo apt update
   sudo apt install openssh-server
   sudo systemctl enable ssh
   sudo systemctl start ssh
   ```
   
2. **Vérifier le statut du service SSH :**
   Vérifiez si SSH fonctionne correctement en exécutant :
   ```bash
   sudo systemctl status ssh
   ```


3. **Vérification de la connectivité SSH** :
   Assurez-vous que vous pouvez vous connecter à chaque machine via SSH depuis une autre machine :
   ```bash
   ssh user@adresse_ip
   ```
#### 2.1.3. Gestion des pare-feu : UFW

Pour la gestion du pare-feu le script utilise la commande **UFW** qui n'est pas installer par défaut sur Debian et Ubuntu voici comment l'installer 

1. **Installer UFW**

`sudo apt update sudo apt install ufw`

2. **Activer UFW et autoriser SSH**

- Activer UFW** :
       
    `sudo ufw enable`
    
- Autoriser SSH :
   
    `sudo ufw allow ssh``
    
3. **Vérifier le statut de UFW** :
    
    Après l'avoir activé, tu peux vérifier que les règles sont bien appliquées avec :
    
    `sudo ufw status`



### 2.2 Windows Server et Windows 

#### 2.2.1 Permissions utilisateurs :
   L'utilisateur doit disposer de privilèges d'administrateur sur la machine distante sur Windows.

#### 2.2.2 Connexion à distance via PowerShell Remoting

1 **Activer le remoting** :
   Ouvrir une session PowerShell en tant qu'administrateur et exécutez la commande suivante sur chaque machine Windows :
   ```powershell
   Enable-PSRemoting -Force
   ```

2. **Configurer la politique d'exécution** :
   Si nécessaire, ajustez la politique d'exécution des scripts PowerShell pour autoriser l'exécution à distance :
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
   ```

3. **Vérifier la connectivité à distance** :
   Testez la connexion PowerShell Remoting en exécutant :
   ```powershell
   Test-WsMan machine_ip
   ```


   
#### 2.2.3 Pare-feu ??


## Téléchargement et configuration des scripts

1. **Téléchargement sur la machine** : 

Clonez le projet "git@github.com:WildCodeSchoo/TSSR_PARIS_0924_P2_G3.git"

   - Pour Debian/Ubuntu :  `script_debian.sh`
   - Pour Windows : `script_windows.ps1`

2. **Attribution des permissions nécessaires** :
   
   2.1 Pour Ubuntu
   Pour exécuter le script sur les machines distantes, vous devrez vous assurer que l'utilisateur a les droits d'exécution :
   ```bash
   chmod +x script_debian.sh
   ```

   2.2 Pour Windows
   Assurez vous que le script a l'extension `.ps1` et que les politiques d'exécution permettent son exécution.

## Fonctionnalités des scripts

#### Fonctions communes à chaque script : 

**Fonction de journalisation**

La fonction log permet créer un fichier de log avec une date spécifique au format `log_evt_YYYY-MM-DD.log`. Chaque jour, elle génère un fichier de log distinct dans le répertoire `/home/wilder/Documents/`. 

**Connexion à distance**

La fonction "get_connection_info" demande des informations de connexion via SSH.
Apres avoir choisi l'option il vous sera demander d'entrer le nom de l'utilisateur avec lequel se connecter sur la machine distante et l'adresse IP de la machine.
Certains script demanderont également d'"entrer le nom d'utilisateur" , l'action a réaliser ou consulté ne sera pas spécifié 

La fonction `ssh_exe` exécute une commande à distance sur la machine distante via SSH, en utilisant les informations fournies par l'utilisateur (utilisateur et IP) dans la fonction get_connection_info

**Poursuite du script**

 A la fin de chaque action la fonction "ask_user" demande à l'utilisateur s'il souhaite continuer avec une autre action ou quitter le script. 

 #### Commandes Préconfigurées

|                                                                          |                                                          |            |
| ------------------------------------------------------------------------ | -------------------------------------------------------- | ---------- |
| Tâche                                                                    | Bash                                                     | Powershell |
| Création de compte utilisateur local                                     | useradd                                                  |            |
| Changement de mot de passe                                               | passwd                                                   |            |
| Suppression de compte utilisateur local                                  | userdel -r -f                                            |            |
| Désactivation de compte utilisateur local                                | usermod -L                                               |            |
| Ajout à un groupe local                                                  | usermod -aG                                              |            |
| Sortie d’un groupe local                                                 | gpasswd                                                  |            |
| Arrêt                                                                    | shutdown now                                             |            |
| Redémarrage                                                              | reboot                                                   |            |
| Verrouillage                                                             | vlock                                                    |            |
| Mise-à-jour du système                                                   | apt update && apt upgrade -y                             |            |
| Création de répertoire                                                   | mkdir -p                                                 |            |
| Modification de répertoire                                               | mv                                                       |            |
| Suppression de répertoire                                                | rmdir                                                    |            |
| Prise de main à distance (CLI)                                           | ssh user@client                                          |            |
| Définition de règles de pare-feu                                         | uwf "action" from "ip" to any port "num_du_port"         |            |
| Activation du pare-feu                                                   | ufw enable                                               |            |
| Désactivation du pare-feu                                                | ufw disable                                              |            |
| Installation de logiciel                                                 | apt-get install -y                                       |            |
| Désinstallation de logiciel                                              | apt-get remove --purge -y                                |            |
| Exécution de script sur la machine distante                              | ssh user@client "bash -s" <"chemin_du_script"            |            |
| Date de dernière connexion d’un utilisateur                              | last -n 1                                                |            |
| Date de dernière modification du mot de passe                            | chage -l \| grep "Dernière modification du mot de passe" |            |
| Liste des sessions ouvertes par l'utilisateur                            | who \| grep "nom_utilisateur"                            |            |
| Groupe d’appartenance d’un utilisateur                                   | groups                                                   |            |
| Historique des commandes exécutées par l'utilisateur                     | tail -n                                                  |            |
| Droits/permissions de l’utilisateur sur un dossier                       | ls -ld                                                   |            |
| Droits/permissions de l’utilisateur sur un fichier                       | ls -l                                                    |            |
| Version de l'OS                                                          | lsb_release -a                                           |            |
| Nombre de disque                                                         | df -h                                                    |            |
| Partition (nombre, nom, FS, taille) par disque                           | lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT                     |            |
| Liste des applications/paquets installées                                | dpkg -l                                                  |            |
| Liste des services en cours d'execution                                  | systemctl list-units --type=service --state=running      |            |
| Liste des utilisateurs locaux                                            | cut -d: -f1 /etc/passwd                                  |            |
| Type de CPU, nombre de coeurs, etc.                                      | lscpu                                                    |            |
| Mémoire RAM totale                                                       | free -h -t                                               |            |
| Utilisation de la RAM                                                    | free -h \| grep "Mem" \| awk {"print $3"]                |            |
| Utilisation du disque                                                    | df -h                                                    |            |
| Utilisation du processeur                                                | top -b -n1 \| grep "CPU(s)"                              |            |
| Recherche des evenements dans le fichier log_evt.log pour un utilisateur | cat fichier_log \| grep nom_utilisateur                  |            |
| Recherche des evenements dans le fichier log_evt.log pour un ordinateur  | cat fichier_log \| grep ip                               |            |


 ## Exécution des scripts
 
1. **Lancement des scripts** :
   
	Depuis Debian : Ouvrez un terminal et exécutez le script :
   ```bash
   ./script_debian.sh
   ```

	Depuis Windows Server : Ouvrez PowerShell en mode administrateur et exécutez :
   ```powershell
   .\script_windows.ps1
   ```

2. **Authentification** :
   Le script demandera à l'utilisateur de saisir :
   - **Nom d'utilisateur distant** : L'utilisateur avec lequel vous souhaitez vous connecter.
   - **Adresse IP ou nom de la machine distante** : L'IP ou le nom d'hôte de la machine cible.

3. **Exécution des commandes** :
   L'utilisateur peut choisir une option qui exécutera la commande préconfigurée sur la machine distante.

4. **Vérification des logs** :
   Les actions sont automatiquement journalisées dans un fichier `log.evt` situé dans le répertoire personnel de l'utilisateur.

   ## Axe d'amélioration possible

   ## Conclusion

Ce guide a pour objectif de vous fournir les informations nécessaires pour configurer, exécuter et maintenir les scripts de gestion à distance, tout en assurant la sécurité, la journalisation et le bon fonctionnement des actions exécutées.
En suivant les bonnes pratiques et en vérifiant régulièrement les logs, vous serez en mesure de superviser efficacement l'interaction avec vos machines distantes.

