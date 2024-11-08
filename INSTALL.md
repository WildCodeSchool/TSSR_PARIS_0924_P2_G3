# Guide Administrateur : Projet de Scripts de Gestion à Distance

## Sommaire 

1. [Introduction](#introduction)
2. [Préparation de l'environnement](#preparation-de-lenvironnement)
   - [VM Server Windows 2022](#vm-server-windows-2022)
      - [Installation Windows Server 2022](#installation-windows-server-2022)
      - [Création d'un utilisateur Windows](#creation-dun-utilisateur-windows)
      - [Configuration de l'adresse l'IP statique](#configuration-de-ladress-ip-statique)
   - [VM client Ubuntu](#vm-client-ubuntu)
      - [Installation Ubuntu 22.04](#installation-ubuntu-2204)
      - [Configuration de l'adressse IP](#configuration-de-ladresse-ip)
   - [Verification de la connexion entre les deux machines](#verification-de-la-connexion-entre-les-deux-machines)
3. [Telechargement des outils](#telechargement-des-outils)
   - [Installation de john the ripper](#installation-de-john-the-ripper)
   - [Installation 7zip](#installation-7zip)
   - [Téléchargement d'une wordlist](#telechargement-dune-wordlist)
4. [Création du dossier partagé](#creation-du-dossier-partage)
   - [Création dans VM Server Windows 2022](#creation-dans-windows)
   - [Montage dans Ubuntu](#montage-dans-ubuntu)
5. [Test en local](#test-en-local)


### 1. **Serveurs Debian/Ubuntu (via SSH)**

#### A. Installer et configurer SSH
1. **Installation de SSH** :
   Sur chaque machine Debian/Ubuntu, vous devez vous assurer que le service SSH est installé et actif.
   ```bash
   sudo apt update
   sudo apt install openssh-server
   sudo systemctl enable ssh
   sudo systemctl start ssh
   ```
   
2. **Vérifier le statut du service SSH** :
   Vérifiez si SSH fonctionne correctement en exécutant :
   ```bash
   sudo systemctl status ssh
   ```


3. **Vérification de la connectivité SSH** :
   Assurez-vous que vous pouvez vous connecter à chaque machine via SSH depuis une autre machine :
   ```bash
   ssh user@adresse_ip
   ```

#### B. Permissions Utilisateur
L'utilisateur distant doit avoir les permissions nécessaires pour exécuter les commandes que vous souhaitez. 
Pour des actions administratives, il est recommandé d'avoir des privilèges `sudo`.

