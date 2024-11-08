# TSSR_PARIS_0924_P2_G3

## Objectif 

Ce projet vise à créer un script qui s'exécute sur une machine locale et permet d'effectuer diverses tâches sur des machines distantes, situées sur le même réseau. Le script offrira un moyen efficace et sécurisé de gérer à distance des actions et des requêtes d'information.

## Membre de l'équipe et organisation

|MEMBRES		| |SEMAINE 1 |SEMAINE2	|SEMAINE 3|	SEMAINE 4 |
|:----------:|:-----------:|:-----------:|:---------------:|:------------------:|:------------------:|
|RAYA	| ROLE	|SM |	PO	| SM |	PO |
|	| ACTION	| Mise en place de l'environnement <br> S'assurer que les tâches soient réalisées dans les délais impartis |	Planification des tâches de la semaine <br> Modification du menu du script principal <br> Création des scripts sur Bash	| Menu Powershell |	Revision des codes et rédaction technique | 
|CHRISTIAN	| ROLE	|SM |	PO	| SM |	PO |
|	| ACTION	| Planification des tâches de la semaine <br> Création du menu du script principal <br> Création des pseudo script sur Bash |	Création des scripts sur Bash	| Menu Powershell  |	Revision des codes et rédaction technique |

## Prérequis

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
division des scripts par menu
appel via source ==> vigilance ++ que tout les scripts soit dans le meme dossier



## Difficultés rencontrées et Solutions trouvées

pseudo terminal ==> utilisation root
message de bienvenue ==> desactiver le message d'acceuil : sudo chmod -x /etc/update-motd.d/*

## Conclusion

_**Recommandations**_
