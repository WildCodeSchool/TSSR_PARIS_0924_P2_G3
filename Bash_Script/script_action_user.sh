#!/bin/bash
# Demande de renseigner le nom d'utilisateur sur lequel vous voullez agir
function user_name ()
{
    read -p "Entrez le nom d'utilisateur : " USERNAME
}
# Demande de renseigner le nom du goupe sur lequel vous voullez agir
function group_name()
{
    read -p "Entrez le nom du groupe où ajouter l'utilisateur : " GROUPNAME
}


# Demande si vous souhaitez poursuivre l'execution du script ou quitter
function ask_continue ()
{
    while true; do
        read -p "Souhaitez-vous effectuer une autre action ? (o/n) : " CONTINUE
        case $CONTINUE in
            [oO]) return ;;  # Continue le script
            [nN]) exit ;;    # Quitte le script
            *) echo "Veuillez entrer 'o' pour oui ou 'n' pour non." ;;
        esac
    done
}

# Définition des fonctions qui vont agir sur l'utilisateur
# Fonction qui permet de créer un compte utilisateur
function user_creation 
{

    echo "Création du compte utilisateur local"
    read -p "Entrez le nom du compte à créer : " newUser

#Vérification de l'existence du compte
if grep -w $newUser /etc/passwd > /dev/null
then
    #Le compte $newUser existe déjà
    #Afficher message et renvoi au menu précédent
    echo -e "Le compte utilisatueur $newUser existe déjà"

else
    #Le compte $newUser n'existe pas
    #Afficher un message et créé le compte utilisteur
   
    echo "Création de l'utilisateur $newUser"
    sudo useradd $newUser > /dev/null 
 
    #Vérification de la création du compte utilisateur
    if cat /etc/passwd | grep $newUser > /dev/null
    then

    #Le compte utilisateur a été créé   
       echo "Compte utilisateur $newUser crée!"
    else
       echo "Compte utilisateur $newUser non-crée!"
    fi
fi
    ask_continue
}
#Fonction qui permet de changer un mot de passe
function password_change 
{
#Sur quel nom d'utilisateur on veut changer le mot de passe $USERNAME
#Vérification de l'existence du compte

while 
        user_name 
        ! grep -w "$USERNAME" /etc/passwd > /dev/null
#Le compte n'existe pas
do
    echo "Le compte utilisateur $USERNAME n'existe pas."
#Le compte existe
done
   sudo passwd $USERNAME

}
#Fonction qui permet de supprimer un compte utilisateur
function user_deletion {
    echo "Suppression de compte utilisateur local"
    read -p "Entrez un nom du compte à supprimer : " supUser
#Tester l'existance du compte dans le système
    if grep -w $supUser /etc/passwd > /dev/null
    then
#Le compte existe
#Validation de la suppression 
        read -p "Etes vous sûre de vouloir supprimer le compte $supUser  ? (o/n) : " CONTINUE
        case $CONTINUE in
            [oO]) sudo userdel -r -f $supUser > /dev/null 2> /dev/null ;;  # Continue le script
            [nN]) exit ;;    # Quitte le script
            *) echo "Veuillez entrer 'o' pour oui ou 'n' pour non." ;;
        esac
   if grep -w $supUser /etc/passwd > /dev/null
   then
       #Erreur le compte utilisateur non supprimé
       echo "Attention le compte $supUser n'a pas pu être supprimé ! "
   else
       #Le compte utilisateur est supprimé
       echo "Le compte $supUser est supprimé ! "
   fi
else
   #Le compte utilisateur n'existe pas
   echo "Le compte $supUser n'exite pas "
fi

ask_continue
}

function user_disable {
    echo "Désactivation de compte utilisateur local"
    read -p "Entrez le nom du compte à désactiver : " desUser
#Tester l'existance du compte dans le système
    if grep -w $desUser /etc/passwd > /dev/null
    then
#Le compte existe
#Validation de la désactivation
        read -p "Etes vous sûre de vouloir désactiver le compte $desUser  ? (o/n) : " CONTINUE
        case $CONTINUE in
            [oO]) sudo passwd -l $desUser > /dev/null 2> /dev/null ;;  # Continue le script
            [nN]) exit ;;    # Quitte le script
            *) echo "Veuillez entrer 'o' pour oui ou 'n' pour non." ;;
        esac
   if sudo passwd -S $desUser | grep -q "L"
   then
       #Le compte utilisateur est désactivée
       echo "Le compte $desUser est désactivée ! " 
    else
       #Erreur le compte utilisateur n'est pas désactivée
       echo "Attention le compte $desUser n'a pas pu être désactivée ! "
   fi
else
   #Le compte utilisateur n'existe pas
   echo "Le compte $desUser n'exite pas "
fi
ask_continue
}

# Définition des fonctions qui vont agir sur le groupe
# Fonction qui permet de rajouter un compte utilisateur à un groupe local

function add_group {
#Quel nom d'utilisateur $USERNAME on veut mettre dans un group $GROUPNAME
#Vérification de l'existence du compte

while 
    user_name 
    ! grep -w "$USERNAME" /etc/passwd > /dev/null
#Le compte n'existe pas
do
    echo "Le compte utilisateur $USERNAME n'existe pas."
#Le compte existe
done
    while
        group_name
        ! getent group "$GROUPNAME" >/dev/null
#Le groupe n'existe pas
    do
    echo "Le groupe $GROUPNAME n'existe pas."
#Le groupe existe
    done
        if
            sudo usermod -aG "$GROUPNAME" "$USERNAME"
        then
            echo "L'utilisateur $USERNAME a été ajouté au groupe $GROUPNAME avec succès."
        else
            echo "Échec de l'ajout de l'utilisateur $USERNAME au groupe $GROUPNAME."
        fi

ask_continue
}

function delete_group 
{
#Quel nom d'utilisateur $USERNAME on veut retirer du group $GROUPNAME
#Vérification de l'existence du compte

while 
    user_name 
    ! grep -w "$USERNAME" /etc/passwd > /dev/null
#Le compte n'existe pas
do
    echo "Le compte utilisateur $USERNAME n'existe pas."
#Le compte existe
done
    while
        group_name
        ! getent group "$GROUPNAME" >/dev/null
#Le groupe n'existe pas
    do
    echo "Le groupe $GROUPNAME n'existe pas."
#Le groupe existe
    done
        if
            sudo gpasswd -d "$USERNAME" "$GROUPNAME"
        then
            echo "L'utilisateur $USERNAME a été retiré du groupe $GROUPNAME avec succès."
        else
            echo "Échec du retrait de l'utilisateur $USERNAME du groupe $GROUPNAME."
        fi



ask_continue
}

while true
do
	echo "==========Menu Action de l'utilisateur=========="
	echo "----------Utilisateur----------"
    echo "1) Création de compte utilisateur local"
	echo "2) Changement de mot de passe"
	echo "3) Suppression de compte utilisateur local"
	echo "4) Désactivation de compte utilisateur local"
	echo "----------Groupe----------"
    echo "5) Ajout à un groupe local"
	echo "6) Sortie d’un groupe local"
	echo "----------Autre----------"
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
