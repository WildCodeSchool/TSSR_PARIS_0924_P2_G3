#!bin/bash

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
    log "Informations de connexion via SSH - Utilisateur : $USERDISTANT, Client : $CLIENT"
}

# Commande pour lancer le ssh en fonction des variables
function ssh_exe {
    ssh "$USERDISTANT@$CLIENT" "$1"
}

# Fonction pour demander les informations sur quel utilisateur vous souhaitez des infos
function user_name() {
    echo -e "${GREEN}Entrez le nom d'utilisateur sur lequel vous souhaitez consulter :${NC}"
    read USERNAME
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

# Définition des fonctions du script :

# Fonction qui permet de voir la derniere date de connexion de l'utilisateur
function last_connexion() {
    clear
    get_connection_info
    user_name
    log "Début de consultation de la dernière connexion de l'utilisateur $USERNAME sur  $CLIENT"
    ssh_exe <<EOF
if id "$USERNAME" &>/dev/null
    then
    echo "Date de dernière connexion de l'utilisateur $USERNAME :"
    last -n 1 "$USERNAME"
    else
    echo "L'utilisateur $USERNAME n'existe pas"
fi
EOF
    log "Fin de consultation de la dernière connexion de l'utilisateur $USERNAME sur  $CLIENT"
    ask_continue
}
# Fonction qui permet de voir la date de dernière modification du mot de passe de l'utilisateur
function last_pwd_change() {
    clear
    get_connection_info
    user_name
    log "Début de consultation de la dernière modification du mot de passe pour l'utilisateur $USERNAME sur $CLIENT"
    ssh_exe <<EOF
    if id "$USERNAME" &>/dev/null
    then
    echo "Date de dernière modification du mot de passe de l'utilisateur $USERNAME :"
    chage -l $USERNAME |  grep "Dernière modification du mot de passe"
    else
    echo "L'utilisateur $USERNAME n'existe pas"
fi
EOF
    log "Fin de consultation de la dernière modification du mot de passe pour l'utilisateur $USERNAME sur $CLIENT"
    ask_continue
}
# Fonction qui permet de lister les sessions ouvertes par l'utilisateur
function user_open_session() {
    clear
    get_connection_info
    user_name
    log "Début de consultation de la liste des sessions ouvertes par l'utilisateur $USERNAME sur $CLIENT"
    ssh_exe <<EOF
    if id "$USERNAME" &>/dev/null; then
        echo "Liste des sessions ouvertes par l'utilisateur :"
        who | grep "\$USERNAME"
    else
        echo "L'utilisateur \$USERNAME n'existe pas"
    fi
EOF
    log "Fin de consultation de la liste des sessions ouvertes par l'utilisateur $USERNAME sur $CLIENT"
    ask_continue

}
# Fonction qui permet de voir le groupe d’appartenance de l'utilisateur
function user_group {
    clear
    get_connection_info
    user_name
    log "Début de consultation du groupe d'appartenance de l'utilisateur $USERNAME sur $CLIENT"
    ssh_exe <<EOF
if id "$USERNAME" &>/dev/null
    then
    echo "Groupe d'appartenance de l'utilisateur $USERNAME"
    groups $USERNAME
    else
    echo "L'utilisateur $USERNAME n'existe pas"
fi
EOF
    log "Fin de consultation du groupe d'appartenance de l'utilisateur $USERNAME sur $CLIENT"
    ask_continue
}
# Fonction qui permet de voir l'historique des commandes exécutées par l'utilisateur
function user_history() {
    clear
    get_connection_info
    user_name
    read -p "Combien de lignes de l'historique souhaitez-vous voir ? " LINES
    log "Début de consultation l'historique des commandes exécutées par l'utilisateur $USERNAME sur $CLIENT"
    ssh_exe <<EOF
if id "$USERNAME" &>/dev/null
    then
    echo "Historique des $LINES dernieres commandes exécutées par l'utilisateur $USERNAME"
    tail -n "$LINES" /home/"$USERNAME"/.bash_history
    else
    echo "L'utilisateur n'existe pas"
fi
EOF
    log "Fin de consultation l'historique des commandes exécutées par l'utilisateur $USERNAME sur $CLIENT"
    ask_continue
}
# Fonction qui permet de voir les droits/permissions de l’utilisateur sur un dossier
function right_perm_directory() {
    clear
    get_connection_info
    user_name
    read -p "Entrez le chemin du dossier : " DIRECTORY
    log "Début de consultation des droits et permissions sur le dossier $DIRECTORY"
    ssh_exe <<EOF
    if [ ! -d "$DIRECTORY" ]; then      
        echo "Le dossier $DIRECTORY n'existe pas."
        exit 1
    fi

    INFO=\$(ls -ld "$DIRECTORY")       
    echo "Droits/permissions du dossier $DIRECTORY :"
    echo "\$INFO"

    if echo "\$INFO" | grep -q "\$USERNAME"; then         
        echo "L'utilisateur \$USERNAME a des permissions sur le dossier."
    else
        echo "L'utilisateur \$USERNAME n'a pas de permissions sur le dossier."
    fi
EOF

    log "Fin de consultation des droits et permissions sur le dossier $DIRECTORY"
    ask_continue

}
# Fonction qui permet de voir les droits/permissions de l’utilisateur sur un fichier
function right_perm_file() {
    clear
    get_connection_info
    user_name
    read -p "Entrez le chemin du fichier : " FILE
    log "Début de consultation des droits et permissions sur le fichier $FILE"
    ssh_exe <<EOF
    if [ ! -e "$FILE" ]; then       # Vérifier si le fichier existe
        echo "Le fichier $FILE n'existe pas."
        exit 1
    fi

    INFO=\$(ls -l "$FILE")      # Afficher les permissions du fichier
    echo "Droits/permissions du fichier $FILE :"
    echo "\$INFO"

    if echo "\$INFO" | grep -q "\$USERNAME"; then       # Vérifier les permissions pour l'utilisateur spécifié
        echo "L'utilisateur \$USERNAME a des permissions sur le fichier."
    else
        echo "L'utilisateur \$USERNAME n'a pas de permissions sur le fichier."
    fi
EOF
    log "Fin de consultation des droits et permissions sur le fichier $FILE"
    ask_continue
}

# Définition des couleurs
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # Aucune couleur

while true; do
    echo -e "${RED} ----- Menu information des utilisateurs -----${NC}"
    echo ""
    echo -e "${BLUE}----- Suivi des utilisateurs -----${NC}"
    echo "1) Date de dernière connexion d'un utilisateur"
    echo "2) Date de dernière modification du mot de passe"
    echo "3) Liste des sessions ouvertes par l'utilisateur"
    echo "4) Groupe d'appartenance d'un utilisateur"
    echo "5) Historique des commandes exécutées par l'utilisateur"
    echo ""
    echo -e "${BLUE}----- Droits et permissions -----${NC}"
    echo "6) Droits d'accès sur un dossier"
    echo "7) Droits d'accès sur un fichier"
    echo ""
    echo "8) Revenir au Menu Précédent"
    echo "9) Quitter le script"

    read -p "Choissisez une option :" choice

    case $choice in
    1)
        last_connexion
        ;;
    2)
        last_pwd_change
        ;;
    3)
        user_open_session
        ;;
    4)
        user_group
        ;;
    5)
        user_history
        ;;
    6)
        right_perm_directory
        ;;
    7)
        right_perm_file
        ;;
    8)
        break
        ;;
    9)
        exit
        ;;
    *)
        echo "Option incorrect"
        ;;
    esac
done
