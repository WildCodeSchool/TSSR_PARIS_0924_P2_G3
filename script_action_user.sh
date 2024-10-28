#Menu des actions possible sur l'utilisateur

# Définition des fonctions
function user_creation {
    echo "Création de compte utilisateur local"
    # Ajoutez ici votre code pour créer un utilisateur
}

function password_change {
    echo "Changement de mot de passe"
    # Ajoutez ici votre code pour changer un mot de passe
}

function user_deletion {
    echo "Suppression de compte utilisateur local"
    # Ajoutez ici votre code pour supprimer un utilisateur
}

function user_disable {
    echo "Désactivation de compte utilisateur local"
    # Ajoutez ici votre code pour désactiver un utilisateur
}

function add_group {
    echo "Ajout à un groupe local"
    # Ajoutez ici votre code pour ajouter à un groupe
}

function delete_group {
    echo "Sortie d’un groupe local"
    # Ajoutez ici votre code pour sortir d'un groupe
}

while true
do
	echo "-------Menu Action de l'utilisateur---------"
	echo "1) Création de compte utilisateur local"
	echo "2) Changement de mot de passe"
	echo "3) Suppression de compte utilisateur local"
	echo "4) Désactivation de compte utilisateur local"
	echo "5) Ajout à un groupe local"
	echo "6) Sortie d’un groupe local"
	echo "7) Revenir au Menu principal"
	echo "8) Quitter"

read -p "Choissisez une option :" choice

case $choice in
        1) user_creation
                ;;
        2) password_change
                ;;
        3) user_deletion
                ;;
        4) user_disable
                ;;
        5) add_group
		;;
	6) delete_group
                ;;
        7) break
                ;;
        8) exit
                ;;
        *) echo "Option incorrect"
                ;;
esac
done 
