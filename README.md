# TSSR_PARIS_0924_P2_G3

## Présentation du projet et son contexte

Ce projet a pour objectif de concevoir deux scripts permettant l'exécution de tâches sur des machines distantes, toutes situées sur un même réseau. 
Les scripts, adaptés aux systèmes Windows et Linux, réaliseront des actions ou récupéreront des informations.<br>
L'objectif principal est d'exécuter des scripts PowerShell depuis un serveur Windows pour gérer des ordinateurs Windows, et des scripts Bash depuis un serveur Debian pour gérer des machines Ubuntu.<br>
Un objectif secondaire, consiste à étendre cette gestion à des machines clientes ayant un système d’exploitation différent de celui de la machine serveur.<br>
À travers ce projet, l’équipe sera amenée à mettre en pratique des compétences techniques et collaboratives, tout en documentant chaque étape et en présentant le résultat final de manière structurée.


## Membre de l'équipe et organisation

|  MEMBRES  |        |                                                         SEMAINE 1                                                         |                                                        SEMAINE2                                                         |    SEMAINE 3    |                       SEMAINE 4                        |     |
| :-------: | :----: | :-----------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------: | :-------------: | :----------------------------------------------------: | --- |
|  ELGHAIA  |  ROLE  |                                                            SM                                                             |                                                           PO                                                            |       SM        |                           PO                           |     |
|           | ACTION |         Mise en place de l'environnement <br> S'assurer que les tâches soient réalisées dans les délais impartis          | Planification des tâches de la semaine <br> Modification du menu du script principal <br> Création des scripts sur Bash |    Test bash    | Finition des scrips Powershell et rédaction technique  |     |
| CHRISTIAN |  ROLE  |                                                            PO                                                             |                                                           SM                                                            |       PO        |                           SM                           |     |
|           | ACTION | Planification des tâches de la semaine <br> Création du menu du script principal <br> Création des pseudo script sur Bash |                                              Création des scripts sur Bash                                              | Menu Powershell | Finition des scripts Powershell et rédaction technique |     |


## Étapes du projet

* Définition du menu principal
* Recherche des commandes à exécuter
* Création du menu principal 
* Création des scripts
* Teste en local 
* Ajout des commandes d'exécution à distance sur chaque scripts 
* Test à distance

## Choix Technique

- 2 clients sont mis en place :

**Client Windows 10 :** 
- Nom : CLIWIN01
- Compte utilisateur : wilder (dans le groupe des admins locaux)
- Mot de passe : Azerty1*
- Adresse IP fixe : 172.16.10.20/24

**Client Ubuntu 22.04/24.04 LTS :**
- Nom : CLILIN01
- Compte utilisateur : wilder (dans le groupe sudo)
- Mot de passe : Azerty1*
- Adresse IP fixe : 172.16.10.30/24

- 2 serveurs sont mis en place :

**Serveur Windows Server 2022 :**
- Nom : SRVWIN01
- Compte : Administrator (dans le groupe des admins locaux)
- Mot de passe : Azerty1*
- Adresse IP fixe : 172.16.10.5/24

**Serveur Debian 12 :**
- Nom : SRVLX01
- Compte : root
- Mot de passe : Azerty1*
- Adresse IP fixe : 172.16.10.10/24


- Connection à distance : 

Pour Debian/Ubuntu un connexion via ssh 
**SSH** a été préféré pour sa simplicité sa sécurité renforcée et sa compatibilité multiplateforme.

Pour Windows Server/Windows Client connection via PowerShell Remoting (WinRM)
**WinRM** est choisi pour son intégration native avec Windows, permettant une gestion à distance sécurisée et une exécution de scripts via PowerShell. Il est idéal pour automatiser les tâches sur des serveurs Windows sans nécessiter de logiciels tiers.

- Gestion des sessions

Sur Debian, une session par action. Il vous sera demandé de fournir les informations de connexion avant chaque nouvelle action, ce qui permet de gérer plusieurs clients depuis un même script. Ce système garantit à la fois **sécurité** (en n’utilisant qu’une session par action) et **flexibilité** (en adaptant facilement les connexions à différents clients).

Sur Windows Server, la session est ouverte une seule fois au début du script avec `New-PSSession`. Lorsque l'utilisateur choisit une action, le script exécute la commande correspondante via la session persistante en utilisant `Invoke-Command` sur cette session.
Pour changer de client il faut sortir du script et relancer une nouvelle session.


- Structure des scripts 

Les scripts principaux sont divisés en quatre sous-scripts distincts, chacun étant responsable d'une tâche spécifique.


## Difficultés rencontrées et Solutions trouvées

Lors de l'utilisation d'un pseudo-terminal, l'accès en tant que **root** était nécessaire pour effectuer certaines actions.

L'identification et la résolution des erreurs lors de l'exécution de commandes à distance peuvent être difficiles, surtout en cas de problèmes de communication ou de configuration. Le processus de répertorier, réessayer et ajuster les paramètres peut être long et fastidieux.

De plus, pour désactiver le message de bienvenue qui s'affiche à la connexion, la solution trouvée a été de désactiver le message d'accueil en exécutant la commande suivante :  
`sudo chmod -x /etc/update-motd.d/*`

## Axe d'amélioration possible

Les axes d'améliorations possible se divise en 5 points clés : 

1. **Centralisation de la gestion des chemins et des dépendances** : Créer un fichier de configuration centralisé pour stocker tous les chemins d'accès aux sous-scripts. Cela permet de gérer facilement les références et de réduire les risques d'erreurs liées à des sous-scripts déplacés, supprimés ou modifiés.
    
2. **Ajout de contrôles supplémentaires** : Mettre en place des vérifications avant l'exécution du script principal, comme la validation de la présence et de l'intégrité des sous-scripts Cela éviterait les erreurs liées à des fichiers manquants ou corrompus.
    
3. **Optimisation de l'écriture des scripts** : Simplifier et optimiser le code des sous-scripts pour améliorer leur performance et leur lisibilité, en évitant les redondances et en appliquant de bonnes pratiques de programmation.
    
4. **Compatibilité multi-plateforme (Ubuntu et Windows)** : Développer un script qui fonctionne à la fois sur **Ubuntu** et **Windows**, en utilisant des outils et des commandes compatibles avec les deux systèmes d'exploitation, ou en détectant automatiquement la plateforme et en ajustant l'exécution des commandes en conséquence.
   
5. **Gestion des connexions à distance sur Linux** : Utilisation de **sessions SSH persistantes** pour maintenir la connexion active tout au long de l'exécution du script, évitant ainsi de créer une nouvelle connexion à chaque commande. Utilisation de **`ssh-agent`** pour gérer les clés SSH de manière sécurisée, ce qui permet d'éviter la saisie répétée du mot de passe et d'assurer une connexion stable et sécurisée.


   
