#!/bin/bash

# Définition des couleurs
RED='\033[0;31m'
NC='\033[0m' # Aucune couleur

# Fonction de journalisation
log_message() {
    local message="$1"
    log_file="/home/wilder/Documents/log_evt.log"
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $message" >>"$log_file"
}

# Appel de la fonction de log pour indiquer que le script est lancé
log_message "Le script a été lancé par l'utilisateur $USER"

# Fonction pour gérer le Menu utilisateur
function Menu_gestion_user() {
    while true; do
        clear
        echo -e "${RED} ----- Menu de l'utilisateur ----- ${NC}"
        echo ""
        echo "1) Action sur l'utilisateur"
        echo "2) Information sur l'utilisateur"
        echo "3) Revenir au menu principal"
        echo "4) Quitter"

        read -p "Choisissez une option : " choice

        case $choice in
        1)
            source script_action_user.sh
            ;;
        2)
            source script_info_user.sh
            ;;
        3)
            break
            ;;
        4)
            exit
            ;;
        *) echo "Option incorrecte" ;;
        esac
    done
}

# Fonction pour gérer le Menu Gestion de l'ordinateur
function Menu_gestion_computer() {
    while true; do
        clear
        echo -e "${RED}----- Menu de l'ordinateur -----${NC}"
        echo ""
        echo "1) Action sur l'ordinateur"
        echo "2) Information sur l'ordinateur"
        echo "3) Revenir au menu principal"
        echo "4) Quitter"

        read -p "Choisissez une option : " choice

        case $choice in
        1)
            source script_action_computer.sh
            ;;
        2)
            source script_info_computer.sh
            ;;
        3)
            break
            ;;
        4)
            exit
            ;;
        *) echo "Option incorrecte" ;;
        esac
    done
}

log_user() {
    read -p "Consultation du fichier evt_log.log pour quel utilisateur : " LOG_USER
    log "Extrait du journal evt_log.log pour l'utilisateur $LOGUSER"
    cat "/home/wilder/Documents/log_evt.log"" | grep "$LOG_USER" 
    echo "Fin de consultation du fichier evt_log.log pour utilisateur"
    }

log_computer (){
read -p "Consultation du fichier evt_log.log pour quel machine : " LOG_COMP
    echo "Extrait du journal evt_log.log pour la machine $LOG_COMP"
    cat "/home/wilder/Documents/log_evt.log"" | grep "$LOG_COMP"
    echo "Fin de consultation du fichier evt_log.log pour la machine"
}

# Menu Journal
function Journal() {
    while true; do
        echo -e "${RED}------- Menu Journal ---------${NC}"
        echo ""
        echo "1) Événements sur l'utilisateur"
        echo "2) Événements sur l'ordinateur"
        echo "3) Revenir au menu principal"
        echo "4) Quitter le script"

        read -p "Choisissez une option : " choice

        case $choice in
        1)
            log_user
            ;;
        2)
            log_computer
            ;;
        3)
            break
            ;;
        4)
            exit
            ;;
        *) echo "Option incorrecte" ;;
        esac
    done
}

# Menu principal
while true; do
    clear
    echo -e "${RED}--- Menu Principal ---${NC}"
    echo ""
    echo "1) Gestion de l'utilisateur"
    echo "2) Gestion des ordinateurs clients"
    echo "3) Consultation des journaux"
    echo "4) Sortir"

    read -p "Choisissez une option : " choice

    case $choice in
    1)
        Menu_gestion_user
        ;;
    2)
        Menu_gestion_computer
        ;;
    3)
        Journal
        ;;
    4)
        exit
        ;;
    *) echo "Option incorrecte" ;;
    esac
done
