#!/bin/bash

# Demander la machine d'intervention
read -p "Entrez l'adresse IP ou le nom de la machine distante : " Client  # variable $Client représente la location de l'intervention

# Fonction pour gérer le Menu utilisateur
function Menu_gestion_user ()
{
while true
do 
    echo "--- Menu de l'utilisateur ---"
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
    echo "--- Menu de l'ordinateur ---"
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
        echo "------- Menu Journal ---------"
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
    echo "--- Menu Principal ---"
    echo "1) Gestion de l'utilisateur"
    echo "2) Gestion de la machine"
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
