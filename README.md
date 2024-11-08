# TSSR_PARIS_0924_P2_G3

## Objectif 

Ce projet a pour objectif de concevoir deux scripts permettant l'exécution de tâches sur des machines distantes, toutes situées sur un même réseau. 
Les scripts, adaptés aux systèmes Windows et Linux, réaliseront des actions ou récupéreront des informations.<br>
L'objectif principal est d'exécuter des scripts PowerShell depuis un serveur Windows pour gérer des ordinateurs Windows, et des scripts Bash depuis un serveur Debian pour gérer des machines Ubuntu.<br>
Un objectif secondaire, consiste à étendre cette gestion à des machines clientes ayant un système d’exploitation différent de celui de la machine serveur.<br>
À travers ce projet, l’équipe sera amenée à mettre en pratique des compétences techniques et collaboratives, tout en documentant chaque étape et en présentant le résultat final de manière structurée.


## Membre de l'équipe et organisation

|MEMBRES		| |SEMAINE 1 |SEMAINE2	|SEMAINE 3|	SEMAINE 4 |
|:----------:|:-----------:|:-----------:|:---------------:|:------------------:|:------------------:|
|RAYA	| ROLE	|SM |	PO	| SM |	PO |
|	| ACTION	| Mise en place de l'environnement <br> S'assurer que les tâches soient réalisées dans les délais impartis |	Planification des tâches de la semaine <br> Modification du menu du script principal <br> Création des scripts sur Bash	| Test bash |	Finition des scrips Powershell et rédaction technique | 
|CHRISTIAN	| ROLE	|PO |	SM	| PO |	SM |
|	| ACTION	| Planification des tâches de la semaine <br> Création du menu du script principal <br> Création des pseudo script sur Bash |	Création des scripts sur Bash	| Menu Powershell  |	Finition des scripts Powershell et rédaction technique |

## Prérequis

- 2 clients sont mis en place :

**Client Windows 10 :** 
Nom : CLIWIN01
Compte utilisateur : wilder (dans le groupe des admins locaux)
Mot de passe : Azerty1*
Adresse IP fixe : 172.16.10.20/24

**Client Ubuntu 22.04/24.04 LTS :**
Nom : CLILIN01
Compte utilisateur : wilder (dans le groupe sudo)
Mot de passe : Azerty1*
Adresse IP fixe : 172.16.10.30/24

- 2 serveurs sont mis en place :

**Serveur Windows Server 2022 :**
Nom : SRVWIN01
Compte : Administrator (dans le groupe des admins locaux)
Mot de passe : Azerty1*
Adresse IP fixe : 172.16.10.5/24

**Serveur Debian 12 :**
Nom : SRVLX01
Compte : root
Mot de passe : Azerty1*
Adresse IP fixe : 172.16.10.10/24

## Étapes du projet

* Définition du menu principal
* Recherche des commandes à executer
* Création du menu principal 
* Création des scripts
* Teste en local 
* Ajout des commandes d'execution à distance sur chaque scripts 
* Test à distance

## Choix Technique


connexion via ssh 
connection via PowerShell Remoting
1 session de connexion par action ==> sécurité / fléxibilité
division des scripts par menu ==> faciliter la gestion des taches
appel via source ==> vigilance ++ que tout les scripts soit dans le meme dossier



## Difficultés rencontrées et Solutions trouvées

pseudo terminal ==> utilisation root
message de bienvenue ==> desactiver le message d'acceuil : sudo chmod -x /etc/update-motd.d/*

## Axe d'amélioration

## Conclusion



_**Recommandations**_
