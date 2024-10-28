#!bin/bash


#Menu des Informations possible sur l'utilisateur

# Définition des fonctions
function last_connexion {
    echo "Date de dernière connexion d’un utilisateur"
    # Ajoutez ici votre code pour créer un utilisateur
}

function last_pwd_change {
    echo "Date de dernière modification du mot de passe"
    # Ajoutez ici votre code pour Date de dernière modification du mot de passe
}

function user_open_session {
    echo "Liste des sessions ouvertes par l'utilisateur"
    # Ajoutez ici votre code pour Liste des sessions ouvertes par l'utilisateur
}

function user_group {
    echo "Groupe d’appartenance d’un utilisateur"
    # Ajoutez ici votre code pour voir le groupe d’appartenance d’un utilisateur
}

function user_history {
    echo "Historique des commandes exécutées par l'utilisateur"
    # Ajoutez ici votre code pour voir l'historique des commandes exécutées par l'utilisateur
}

function right_perm_directory {
    echo "Droits/permissions de l’utilisateur sur un dossier"
    # Ajoutez ici votre code pour voir les droits/permissions de l’utilisateur sur un dossier
}

function right_perm_file {
    echo "Droits/permissions de l’utilisateur sur un fichier"
    # Ajoutez ici votre code pour voir les droits/permissions de l’utilisateur sur un fichier
}


while true
do
	echo " -------Menu information de l'utilisateur-------"
	echo "1) Date de dernière connexion d’un utilisateur"
	echo "2) Date de dernière modification du mot de passe"
	echo "3) Liste des sessions ouvertes par l'utilisateur"
	echo "4) Groupe d’appartenance d’un utilisateur"
	echo "5) Historique des commandes exécutées par l'utilisateur"
	echo "6) Droits/permissions de l’utilisateur sur un dossier"
	echo "7) Droits/permissions de l’utilisateur sur un fichier"
	echo "8) Revenir au Menu Précédent"
	echo "9) Quitter le script"

read -p "Choissisez une option :" choice

case $choice in
        1) last_connexion
                ;;
        2) last_pwd_change
                ;;
        3) user_open_session
                ;;
        4) user_group
                ;;
        5) user_history
		;;
	6) right_perm_directory
                ;;
	7) right_perm_file
                ;;
        8) break
                ;;
        9) exit
                ;;
        *) echo "Option incorrect"
                ;;
esac
done 

