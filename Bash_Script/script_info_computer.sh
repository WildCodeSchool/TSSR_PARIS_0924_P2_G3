#!/bin/bash

################################################################################################
# Menu des informations ordinateurs, ce script sera rappelé en source depuis le menu principal #
################################################################################################

# Fonctions : 

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

# Demande si l'utilisateur souhaite continuer dans le script ou quitter
function ask_continue {
    while true; do
        read -p "Voulez-vous effectuer une autre action ? (o/n) : " CONTINUE
        case $CONTINUE in
        [oO]) return ;; # Continue le script
        [nN]) exit ;;   # Quitte le script
        *) echo "Veuillez entrer 'o' pour oui ou 'n' pour non." ;;
        esac
    done
}
################################################################################

# Menu

while true; do

    echo -e "${RED}------- Menu Informations sur l'Ordinateur -------${NC}"

    echo ""

    echo -e "${BLUE}----- Informations Système -----${NC}"
    echo "1) Version de l'OS"
    echo "2) Nombre de disques"
    echo "3) Partition (nombre, nom, FS, taille) par disque"

    echo ""

    echo -e "${BLUE}----- Applications et Services -----${NC}"
    echo "4) Liste des applications/paquets installés"
    echo "5) Liste des services en cours d'exécution"
    echo "6) Liste des utilisateurs locaux"

    echo ""

    echo -e "${BLUE}----- Ressources Système -----${NC}"
    echo "7) Type de CPU, nombre de cœurs, etc."
    echo "8) Mémoire RAM totale"
    echo "9) Utilisation de la RAM"
    echo "10) Utilisation du disque"
    echo "11) Utilisation du processeur"

    echo ""

    echo "12) Revenir au Menu Précédent"
    echo "13) Quitter le script"

    read -p "Choissisez une option :" choice

    case $choice in
    1)
        get_connection_info
        log "Début de consultation de la version de l'OS"
        ssh_exe "echo \"Version de l'OS :\" ; lsb_release -a"
        log "Fin de consultation de la version de l'OS"
        ask_continue
        ;;
    2)
        get_connection_info
        log "Début de consultation du nom de disque présent sur la machine"
        ssh_exe "echo \"Nombre de disque:\" ; df -h"
        log "Fin de consultation du nombre de disque présent sur la machine"
        ask_continue
        ;;
    3)
        get_connection_info
        log "Début de consultation du partionnement par dique"
        ssh_exe "echo \"Partition (nombre, nom, FS, taille) par disque : \" ; lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT"
        log "Fin de consultation du partionnement par dique"
        ask_continue
        ;;
    4)
        get_connection_info
        log "Début de consultation des applications et paquets installés sur la machine"
        ssh_exe "echo \"Liste des applications/paquets installées : \" ; dpkg -l"
        log "Fin de consultation des applications et paquets installés sur la machine"
        ask_continue
        ;;
    5)
        get_connection_info
        log "Début de consultation des services en cours d'execution"

        ssh_exe "echo \"Liste des services en cours d'execution : \" ; systemctl list-units --type=service --state=running"
        log "Fin de consultation des services en cours d'execution"
        ask_continue
        ;;
    6)
        get_connection_info
        log "Début de consultation des utilisateurs locaux"

        ssh_exe "echo \"Liste des utilisateurs locaux : \" ; cut -d: -f1 /etc/passwd"
        log "Fin de consultation des utilisateurs locaux"
        ask_continue
        ;;
    7)
        get_connection_info
        log "Début de consultation des informations relatives au CPU"

        ssh_exe "echo \"CPU Information : \" ; lscpu"
        log "Fin de consultation des informations relatives au CPU"
        ask_continue
        ;;
    8)
        get_connection_info
        log "Début de consultation des informations relatives à la RAM"

        ssh_exe "echo \"Mémoire RAM totale : \" ; free -h -t"
        log "Fin de consultation des informations relatives à la RAM"
        ask_continue
        ;;
    9)
        get_connection_info
        log "Début de consultation des informations relatives à l'utilisation de la RAM"

        ssh_exe "echo \"Utilisation de la RAM : \" ; free -h | grep 'Mem' | awk {'print $3'}"
        log "Fin de consultation des informations relatives à l'utilisation de la RAM"
        ask_continue
        ;;
    10)
        get_connection_info
        log "Début de consultation des informations relatives à l'utilisation du disque"

        ssh_exe "echo \"Utilisation du disque : \" ; df -h"
        log "Fin de consultation des informations relatives à l'utilisation du disque"
        ask_continue
        ;;
    11)
        get_connection_info
        log "Début de consultation des informations relatives à l'utilisation du processeur"

        ssh_exe "echo \"Utilisation du processeur : \" ; top -b -n1 | grep 'Cpu(s)'"
        log "Fin de consultation des informations relatives à l'utilisation du processeur"
        ask_continue

        ;;
    12)
        break
        ;;
    13)
        exit
        ;;
    *) echo "Option incorrect" ;;

    esac
done
