# Guide Administrateur : Projet de Scripts de Gestion à Distance

## Sommaire 


1. [Prérequis Techniques](#prerequis)
   - [Server Debian et Ubuntu](#server-debian-et-ubuntu)
      - [Permissions utilisateurs](#permissions-utilisateurs)
      - [Connexion à distance via SSH](#Connexion-a-distance-via-SSH)
      - [Gestion des pare-feus : UFW](#gestion-des-pare-feus-:-UFW)   
   - [Windows Server et Windows](#Windows-Server-et-Windows)
      - [Permissions utilisateurs](#Permissions-utilisateurs)
      - [Connexion à distance via PowerShell Remoting](#Connexion-à-distance-via-Powershell-Remoting)
      - [Configurer la politique d'exécution](#Configurer-la-politique-dexécution)
      - [Gestion des pare-feus](#Gestion-des-pare-feus)  
2. [Etapes d'installation et configuration des scripts](#Etapes-dinstallation-et-configuration-des-scripts)
   - [Téléchargement sur la machine](#Téléchargement-sur-la-machine)
   - [*Attribution des permissions nécessaires](#*Attribution-des-permissions-nécessaires)
3. [Exécution des scripts](#execution-des-scripts)
4. [FAQ]

   

## Prérequis Techniques

### 1. Serveurs Debian et Ubuntu

#### 1.1 Permissions utilisateurs
L'utilisateur distant doit avoir les permissions nécessaires pour exécuter les commandes que vous souhaitez. Pour des actions administratives, il est recommandé d'avoir des privilèges `sudo`.
Certains script devront s'exécuter avec le root.

#### 1.2 Connexion à distance via SSH
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
#### 1.3 Gestion des pare-feus : UFW

Pour la gestion du pare-feu le script utilise la commande **UFW** qui n'est pas installer par défaut sur Debian et Ubuntu voici comment l'installer 

1. **Installer UFW**

`sudo apt update sudo apt install ufw`

2. **Activer UFW et autoriser SSH**

- Activer UFW :
       
    `sudo ufw enable`
    
- Autoriser SSH :
   
    `sudo ufw allow ssh``
    
3. **Vérifier le statut de UFW** :
    
    Après l'avoir activé, tu peux vérifier que les règles sont bien appliquées avec :
    
    `sudo ufw status`



### 2. Windows Server et Windows 

#### 2.1 Permissions utilisateurs

   L'utilisateur doit disposer de privilèges d'administrateur sur la machine distante  Windows.

#### 2.2 Connexion à distance via PowerShell Remoting

1. **Activer le remoting** :
   Ouvrir une session PowerShell en tant qu'administrateur et exécutez la commande suivante sur chaque machine Windows :
   
   Enable-PSRemoting -Force


Cette commande va :

- Activer le service WinRM.
- Configurer le service WinRM pour qu'il démarre automatiquement.
- Ouvrir les ports nécessaires dans le pare-feu.

2. Vérifier l'état du service WinRM
Get-Service WinRM

Si le service n'est pas en cours d'exécution, vous pouvez le démarrer avec :
Start-Service WinRM

3. Tester la connexion à distance : 
Enter-PSSession -ComputerName "<IPdeLOrdinateurDistant>" -Credential ""


#### 2.3 Configurer la politique d'exécution
   Si nécessaire, ajustez la politique d'exécution des scripts PowerShell pour autoriser l'exécution à distance :
   
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
   ```

   
### 2.4 Gestion des pare-feus 

Pour ce projet les pare-feu ont été désactivé donc aucune gestion n'est requise


## Etapes d'installation et configuration des scripts

1. **Téléchargement sur la machine** : 

a ) Installer git 

Sur **Debian/Ubuntu** :
	sudo apt update && sudo apt install git


Sur **Windows**
1. Téléchargez l'installateur depuis [git-scm.com](https://git-scm.com/).
2. Suivez l'assistant d'installation.
	
b ) générer et configurer une clé ssh

- Générez une clé SSH (si vous n'en avez pas) :
        
    `ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"`
    
- Ajoutez la clé SSH à votre agent SSH :
    
    `eval "$(ssh-agent -s)" ssh-add ~/.ssh/id_rsa`
    
- Ajoutez la clé publique (`~/.ssh/id_rsa.pub`) à votre compte GitHub, GitLab, ou autre service Git.

c)  Clonez le projet 

git clone "git@github.com:WildCodeSchoo/TSSR_PARIS_0924_P2_G3.git"

   - Pour Debian/Ubuntu :  `script_debian.sh`
   - Pour Windows : `script_windows.ps1`

2. **Attribution des permissions nécessaires** :
   
   2.1 Pour Ubuntu
   Pour exécuter le script sur les machines distantes, vous devrez vous assurer que l'utilisateur a les droits d'exécution :
   ```bash
   chmod +x script_debian.sh
   ```

   2.2 Pour Windows
   Assurez vous que le script possède l'extension `.ps1` et que les politiques d'exécution permettent son exécution.


#### Exécution des scripts : 
 
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
   L'utilisateur peut choisir une option en écrivant le numéro qui lui correspond  dans le menu ce qui exécutera la commande préconfigurée sur la machine distante.

4. **Vérification des logs** :
   Les actions sont automatiquement journalisées dans un fichier `log.evt` situé dans le répertoire personnel de l'utilisateur.

## FAQ 

**Q : Comment configurer une adresse IP statique sur les systèmes Linux et Windows ?**

**R :** Sur Ubuntu, vous pouvez configurer une adresse IP statique en utilisant **netplan** ou en modifiant directement les fichiers dans `/etc/network/interfaces`. Sur Windows, il suffit d'aller dans les paramètres du **Centre Réseau et partage**, de cliquer sur **Modifier les paramètres de la carte**, puis de configurer les propriétés **IPv4** de l'adaptateur réseau.

**Q : Comment vérifier si OpenSSH est correctement installé et actif sur ma machine ?** 

**R** : Sur Debian et Ubuntu, utilisez la commande `sudo systemctl status ssh` pour vérifier l'état du service. Sur Windows, ouvrez PowerShell en tant qu'administrateur et exécutez `Get-Service WinRM` pour voir si le service est actif.

## Conclusion

Ce guide a pour objectif de vous fournir les informations nécessaires pour installer et configurer  les scripts de gestion à distance
En suivant les bonnes pratiques et en vérifiant régulièrement les logs, vous serez en mesure de superviser efficacement l'interaction avec vos machines distantes.
