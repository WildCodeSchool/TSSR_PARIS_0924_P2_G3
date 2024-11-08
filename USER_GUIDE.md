## Sommaire
1. [Introduction](#introduction)
2. [Prérequis](#prérequis)
3. [Installation et Configuration](#installation-et-configuration)
4. [Utilisation de Base](#utilisation-de-base)
   - [Exécution du Script Debian/Ubuntu via SSH](#Exécution-du-Script-Debian/Ubuntu-via-SSH)
   - [Exécution du Script Windows via PowerShell](#Exécution-du-Script-Windows-via-PowerShell)
5. [Problèmes courants et solutions)](#Problèmes-courants-et-solutions)
6. [Conclusion](#conclusion)
7. [Ressources supplémentaires](#ressources-supplementaires)

## Introduction

L'utilisateur a accès à deux scripts permettant d'interagir avec des machines distantes via SSH pour un serveur Debian et via PowerShell pour un serveur Windows. 
Les scripts sont conçus pour automatiser des actions et des requêtes d'informations sur des machines distantes, tout en journalisant chaque action dans un fichier `log.event` situé dans le dossier personnel de l'utilisateur.

## Objectif

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

## Utilisation 

1. **Exécution du Script Debian/Ubuntu via SSH**

 1. Ouvrir un terminal sur la machine locale.
2. Exécuter le script en utilisant la commande suivante :
   ```bash
   ./script_debian.sh
   ```
3. Le script affiche un menu avec les options disponibles, les commandes sont déjà configurés pour s'exécuter à distance.
   Suivez les instructions pour naviguer dans les options.
4. Le script demandera à l'utilisateur de spécifier les informations suivantes :
   - **Nom de l'utilisateur distant** : Entrez l'utilisateur sous lequel vous souhaitez vous connecter à la machine distante.(ex: wilder)
   - **Adresse IP ou nom de la machine distante** : Entrez l'IP ou le nom d'hôte de la machine distante (ex : `192.168.1.10`).
   - Dans certains script le nom de l'utilisateur sur lequel l'action doit être effectué
5. Le résultat de l'exécution sera affiché à l'écran et enregistré dans le fichier `log.event`

 2. **Exécution du Script Windows via PowerShell**

1. Ouvrir PowerShell en tant qu'administrateur sur la machine locale.
2. Exécuter le script PowerShell avec la commande suivante :
   ```powershell
   .\script_windows.ps1
   ```
3. Le script affiche un menu avec les options disponibles, les commandes sont déjà configuré pour s'exécuter à distance. Suivez les instructions pour naviguer dans les options.
4. Le script demandera à l'utilisateur de spécifier les informations suivantes :
   - **Nom de l'utilisateur distant** : Entrez l'utilisateur sous lequel vous souhaitez vous connecter à la machine distante.(ex: wilder)
   - **Adresse IP ou nom de la machine distante** : Entrez l'IP ou le nom d'hôte de la machine distante (ex : `192.168.1.10`).
   - Dans certains script le nom de l'utilisateur sur lequel l'action doit être effectué
5. Le résultat de l'exécution sera affiché à l'écran et enregistré dans le fichier `log.event`

##Utilisation Avancée
Execution croisé

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
Si nécessaire executez la partie du script avec l'utilisateur root.

## Conclusion

Ces scripts offrent une méthode flexible pour exécuter des actions distantes sur des serveurs Debian/Ubuntu et Windows, tout en garantissant la sécurité et la traçabilité des opérations .
Ils permettent aux administrateurs de gérer plusieurs machines sur le même réseau à partir d'un même terminal, en toute simplicité.



