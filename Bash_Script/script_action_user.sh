#!/bin/bash

# Définition des couleurs
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # Aucune couleur

# Fonction de journalisation
function log {
	LOG_DATE=$(date +"%Y-%m-%d")
	LOG_FILE="/home/wilder/Documents/log_evt_$LOG_DATE.log"
	echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" >>$LOG_FILE
}

# Demande les informations de connexion
function get_connection_info {
    echo -e "${GREEN}Entrez le nom d'utilisateur avec lequel vous souhaitez vous connecter :${NC}"
    read USERDISTANT
    echo -e "${GREEN}Entrez l'adresse IP ou le nom d'hôte de la machine distante :${NC}"
    read CLIENT
    echo -e "${GREEN}Entrez le nom d'utilisateur :${NC}"
    read USERNAME
    log "Informations de connexion via SSH - Utilisateur : $USERDISTANT, Client : $CLIENT"
}

# Commande pour lancer le ssh en fonction des variables
function ssh_exe {
    ssh -t "$USERDISTANT@$CLIENT" "$1"
}

# Demande de renseigner le nom du goupe sur lequel vous voullez agir
function group_name() {
    read -p "Entrez le nom du groupe où vous souhaitez ajouter/supprimer l'utilisateur : " GROUPNAME
}

# Demande si vous souhaitez poursuivre l'execution du script ou quitter
function ask_continue() {
    while true; do
        read -p "Souhaitez-vous effectuer une autre action ? (o/n) : " CONTINUE
        case $CONTINUE in
        [oO]) return ;; # Continue le script
        [nN]) exit ;;   # Quitte le script
        *) echo "Veuillez entrer 'o' pour oui ou 'n' pour non." ;;
        esac
    done
}

# Définition des fonctions qui vont agir sur l'utilisateur
# Fonction qui permet de créer un compte utilisateur
function user_creation {
    clear
    get_connection_info
    echo "Création du compte utilisateur local"
    log "Début de la création de l'utilisateur $USERNAME "
    ssh_exe <<EOF
#Vérification de l'existence du compte
if grep -w $USERNAME /etc/passwd > /dev/null
then
    #Le compte $USERNAME existe déjà
    #Afficher message et renvoi au menu précédent
    echo -e "Le compte utilisateur $USERNAME existe déjà"

else
    #Le compte $USERNAME n'existe pas
    #Afficher un message et créé le compte utilisateur
   
    echo "Création de l'utilisateur $USERNAME"
    useradd $USERNAME > /dev/null 
 
    #Vérification de la création du compte utilisateur
    if cat /etc/passwd | grep $USERNAME > /dev/null
    then

    #Le compte utilisateur a été créé   
       echo "Compte utilisateur $USERNAME créé!"
    else
       echo "Compte utilisateur $USERNAME non-créé!"
    fi
fi
EOF
    log " Fin de création du compte utilisateur $USERNAME "
    ask_continue
}
#Fonction qui permet de changer un mot de passe
function password_change {
    clear
    get_connection_info
    log "Début du changement du mot de passe de l'utilisateur $USERNAME "
    ssh_exe <<EOF
while  
        ! grep -w "$USERNAME" /etc/passwd > /dev/null

do
    echo "Le compte utilisateur $USERNAME n'existe pas."
done
    passwd $USERNAME
EOF
    log "Fin du changement de mot de passe de l'utilisateur $USERNAME "
    ask_continue
}

#Fonction qui permet de supprimer un compte utilisateur
function user_deletion {
    clear
    get_connection_info
    echo "Suppression de compte utilisateur local"
    log "Début de suppression de compte utilisateur $USERNAME "
    ssh_exe <<EOF
    if grep -w $USERNAME /etc/passwd > /dev/null
    then
    	userdel -r -f $USERNAME > /dev/null 2> /dev/null
	cat /etc/passwd
    	echo "Le compte utilisateur $USERNAME est supprimé"
   else
   	echo "Le compte utilisateur $USERNAME n'exite pas "
fi
EOF
    log "Fin de suppression de compte utilisateur $USERNAME "
    ask_continue
}

# Définition des fonctions qui vont agir sur l'utilisateur
# Fonction de désactivation du compte utlisateur
function user_disable {
    clear
    get_connection_info
    echo "Désactivation de compte utilisateur local"
    # "Début de désactivation de compte utilisateur $USERNAME "
    ssh_exe <<EOF
#Tester l'existance du compte dans le système
    if grep -w $USERNAME /etc/passwd > /dev/null
    then
 
        usermod -L $USERNAME | grep -q "L"  #Le compte existe
        echo "Le compte utilisateur $USERNAME est désactivé ! " #Le compte utilisateur est désactivé
        grep $USERNAME /etc/shadow
       
else
   #Le compte utilisateur n'existe pas
   echo "Le compte utilisateur $USERNAME n'existe pas "
fi
EOF
    log "Fin de désactivation de compte utilisateur $USERNAME "
    ask_continue
}

# Définition des fonctions qui vont agir sur le groupe
# Fonction qui permet de rajouter un compte utilisateur à un groupe local

function add_group {

    clear
    get_connection_info
    group_name
    log "Début de l'ajout de compte utilisateur $USERNAME dans le groupe $GROUPNAME "
    ssh_exe <<EOF
while 
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
            usermod -aG "$GROUPNAME" "$USERNAME"
        then
            echo "Le compte utilisateur $USERNAME a été ajouté au groupe $GROUPNAME avec succès."
            groups $USERNAME
        else
            echo "Échec de l'ajout du compte utilisateur $USERNAME au groupe $GROUPNAME."
        fi
EOF
    log "Fin de l'ajout de compte utilisateur $USERNAME dans le groupe $GROUPNAME "
    ask_continue
}

function delete_group {
    #Quel nom d'utilisateur $USERNAME on veut retirer du group $GROUPNAME
    #Vérification de l'existence du compte

    clear
    get_connection_info
    group_name
    log "Début de retrait de compte utilisateur $USERNAME dans le groupe $GROUPNAME "
    ssh_exe <<EOF
 while 
    ! grep -w "$USERNAME" /etc/passwd > /dev/null
do
    echo "Le compte utilisateur $USERNAME n'existe pas."
done
    while
        group_name
        ! getent group "$GROUPNAME" >/dev/null
    do
    echo "Le groupe $GROUPNAME n'existe pas."
    done
        if
            gpasswd -d "$USERNAME" "$GROUPNAME"
        then
            echo "Le compte utilisateur $USERNAME a été retiré du groupe $GROUPNAME avec succès."
            groups $USERNAME
        else
            echo "Échec du retrait du compte utilisateur $USERNAME du groupe $GROUPNAME."
        fi
EOF
    log "Fin de retrait de compte utilisateur $USERNAME dans le groupe $GROUPNAME "
    ask_continue
}

# Menu
while true; do
    clear
    echo -e "${RED}------- Action Disponible -------${NC}"

    echo ""

    echo -e "${BLUE}----- Gestion des Utilisateurs -----${NC}"
    echo "1) Création de compte utilisateur local"
    echo "2) Changement de mot de passe"
    echo "3) Suppression de compte utilisateur local"
    echo "4) Désactivation de compte utilisateur local"

    echo""

    echo -e "${BLUE}----- Gestion des Groupe -----${NC}"
    echo "5) Ajout à un groupe local"
    echo "6) Sortie d’un groupe local"

    echo""

    echo -e "${BLUE}----- Autre -----${NC}"
    echo "7) Revenir au Menu principal"
    echo "8) Quitter"

    read -p "Choissisez une option :" choice

    case $choice in
    1)
        user_creation
        ;;
    2)
        password_change
        ;;
    3)
        user_deletion
        ;;
    4)
        user_disable
        ;;
    5)
        add_group
        ;;
    6)
        delete_group
        ;;
    7)
        break
        ;;
    8)
        exit
        ;;
    *)
        echo "Option incorrect"
        ;;
    esac
done
