#!/bin/bash

# Demander la machine d'intervention
read -p "Entrez l'adresse IP ou le nom de la machine distante" Client  #variable $Client represente la location de l'intervention

# Fonction pour gerer le sous Menu action utilisateur 
function sous_menu_action_user ()
{
while true
do
        echo "-------Sous Menu Action user ---------"
        echo "1. Utilisateur"
        echo "2. Groupes"
        echo "3. Revenir au menu précedent"
	echo "4. Quitter"

read -p "Choissisez une option :" choice

case $choice in
        1) source script.user.sh
                ;;
        2) source script_group.sh
                ;;
        3) break
           	;;
	4) echo "Sortie du script"
	   exit
                ;;
        *) echo "Option incorrect"
                ;;
esac
done 
}
  

# Fonction pour gerer le sous Menu information utilisateur 
function sous_menu_information_user ()
{
while true
do
        echo "-------Sous Menu information utilisateur ---------"
        echo "1. Utilisateur"
        echo "2. Droit"
        echo "3. Revenir au menu précedent"
	echo "4. Quitter"

read -p "Choissisez une option :" choice

case $choice in
        1) source script_infouser.sh
                ;;
        2) source script_right.sh
                ;;
        3) break;
                ;;
	4) echo "Sortie du script"
	   exit
	        ;;
        *) echo "Option incorrect"
                ;;
esac
done 
}

# Fonction pour gerer le sous Menu action de la machine 
function sous_menu_action_computer ()
{
while true
do
        echo "-------Sous Menu Action Machine---------"
        echo "1. Systeme"
        echo "2. Remote Controle"
        echo "3. Repertoire"
        echo "4. Securité"
        echo "5. Software"
        echo "6. Revenir au menu précedent"
        echo "7. Quitter"

read -p "Choissisez une option :" choice

case $choice in
        1) source script_system.sh
                ;;
        2) source script_remotecontrol.sh
                ;;
        3) source script_repertoire.sh
                ;;
        4) source script_securité.sh
                ;;
        5) source script_software.sh
                ;;
        6) break
                ;;
        7) exit
                ;;
        *) echo "Option incorrect"
                ;;
esac
done 
}

# Fonction pour gerer le sous Menu Information de la machine 
function sous_menu_info_computer ()
{
while true
do
        echo "-------Sous Menu Information Machine---------"
        echo "1. OS"
        echo "2. Disque"
        echo "3. Task Manager"
        echo "4. System"
        echo "5. Revenir au menu précedent"
	echo "6. Quitter"

read -p "Choissisez une option :" choice

case $choice in
        1) source script_os.sh
                ;;
        2) source script_disque.sh
                ;;
        3) source script_taskmanager.sh
                ;;
        4) source script_systeme.sh
                ;;
        5) break
                ;;
	6) exit
		;;
        *) echo "Option incorrect"
                ;;
esac
done 
}



# Fonction pour gerer le Menu utilisateur
function Menu_gestionuser ()
{
while true
do 
    echo "--- Menu de l'utilisateur ---"
    echo "1) Action sur l'utilisateur"
    echo "2) Information sur l'utilisateur"
    echo "3) Revenir au menu précedent" 
    echo "4) Quitter"

read -p "Choissisez une option :" choice

case $choice in
        1) sous_menu_action_user
		;;
       	2) sous_menu_information_user
		;;
        3) break
                ;;
        4) exit 
                ;;
        *) echo "Option incorrect"
		
esac
done
}

# Fonction pour gerer le Menu Gestion de l'ordinateur
function Menu_gestionmachine ()
{
while true
do 
    echo "--- Menu de l'ordinateur ---"
    echo "1) Action sur l'ordinateur"
    echo "2) Information sur l'ordinateur"
    echo "3) Revenir au menu précedent"
    echo "4) Quitter" 

read -p "Choissisez une option :" choice

case $choice in
        1) sous_menu_action_computer;;
	2) sous_menu_info_computer;;
        3) break;;
        4) exit;;
        *) echo "Option incorrect"
esac
done
}

# Menu Journal
#function Journal ()
#{
#read -p "Choissisez une option :" choice

 #echo "------- Menu Journal---------"
  #      echo "1. Evenement sur le user"
   #     echo "2. Evenement sur l'ordinateur "

#case $choice in
 #       1) ligne de commande log user
  #              ;;
   #     2) ligne de commande log ordinateur
    #            
    #esac
    #done
#}


# Menu principal
while true
do 
    echo "--- Menu Principal---"
    echo "1) Gestion de l'utilisateur"
    echo "2) Gestion de la machine"
    echo "3) Edition journal"
    echo "4) Sortir"

read -p "Choissisez une option :" choice

case $choice in
        1) Menu_gestionuser
                ;;
        2) Menu_gestionmachine
                ;;
        3) Journal
                ;;
        4) exit
                ;;
        *) echo "Option incorrect"
               
esac
done


