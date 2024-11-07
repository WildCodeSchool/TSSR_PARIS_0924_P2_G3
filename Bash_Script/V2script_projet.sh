#!/bin/bash

# Définition des couleurs
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # Aucune couleur

# Fonction de journalisation
log_message() {
  local message="$1"
  LOG_FILE="/home/wilder/Documents/log_event.log"
  echo "$(date "+%Y-%m-%d %H:%M:%S") - $message" >> "$log_file"
}

# Appel de la fonction de log pour indiquer que le script est lancé
log_message "Le script a été lancé par l'utilisateur $USER"


# Fonction pour gérer le Menu utilisateur
function Menu_gestion_user ()
{
while true
do 
    clear
    echo -e "${RED ----- Menu de l'utilisateur ----- ${NC}
    ech ""
    echo "1) Action sur l'utilisateur"
    echo "2) Information sur l'utilisateur"
    echo "3) Revenir au menu principal" 
    echo "4) Quitter"

    read -p "Choisissez une option : " choice

    case $choice in
        1) source script_action_user.sh
            ;;
        2) source script_info_user.sh
            ;;
        3) break
            ;;
        4) exit 
            ;;
        *) echo "Option incorrecte"
    esac
done
}

# Fonction pour gérer le Menu Gestion de l'ordinateur
function Menu_gestion_computer ()
{
while true
do 
    clear
    echo -e "${RED----- Menu de l'ordinateur -----${NC}
    echo ""
    echo "1) Action sur l'ordinateur"
    echo "2) Information sur l'ordinateur"
    echo "3) Revenir au menu principal"
    echo "4) Quitter" 

    read -p "Choisissez une option : " choice

    case $choice in
        1) source script_action_computer.sh
            ;;
        2) source script_info_computer.sh
            ;;
        3) break
            ;;
        4) exit
            ;;
        *) echo "Option incorrecte"
    esac
done
}

# Menu Journal
function Journal ()
{
    while true
    do
        clear
        echo -e "${RED------- Menu Journal ---------${NC}
        echo ""
        echo "1) Événements sur l'utilisateur"
        echo "2) Événements sur l'ordinateur"

        read -p "Choisissez une option : " choice

        case $choice in
            1) echo "Ligne de commande log user" # Remplacez par la commande appropriée
                ;;
            2) echo "Ligne de commande log ordinateur" # Remplacez par la commande appropriée
                ;;
            *) echo "Option incorrecte"
        esac
    done
}

# Menu principal
while true
do 
    clear
    echo -e "${RED}--- Menu Principal ---${NC}"
    echo ""
    echo "1) Gestion de l'utilisateur"
    echo "2) Gestion des ordinateurs clients"
    echo "3) Consultation des journaux"
    echo "4) Sortir"

    read -p "Choisissez une option : " choice

    case $choice in
        1) Menu_gestion_user
            ;;
        2) Menu_gestion_computer
            ;;
        3) Journal
            ;;
        4) exit
            ;;
        *) echo "Option incorrecte"
    esac
done
