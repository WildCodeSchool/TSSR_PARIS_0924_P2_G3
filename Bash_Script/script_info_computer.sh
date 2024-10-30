#!bin/bash

#Menu des informations sur l'ordinateur
# Fonction pour connaitre la version de l'OS
# Définition des fonctions
function OS_Version {
    echo "Version de l'OS : "
    
}
#Fonction pour connaitre la liste des applications/paquets installées
function disk_number {
    echo "Nombre de disque: "
    # Ajoutez ici votre code pour connaitre le nombre de disque
}

function disk_partition {
    echo "Partition (nombre, nom, FS, taille) par disque : "
    # Ajoutez ici votre code pour connaitre le partionnement des disques
}

function installed_application {
    echo "Liste des applications/paquets installées "
    
}
# Fonction pour connaitre la liste des services installées
function running_service {
    echo "Liste des services en cours d'execution"
    
}
# Fonction pour avoir des détails sur le type de CPU, nombre de coeurs, etc
function local_user {
    echo "Liste des utilisateurs locaux"
    # Ajoutez ici votre code pour connaitre la liste des utilisateurs locaux
}

function CPU_details {
    echo "CPU Information :"

}
#Fonction pour connaitre le total de la RAM
function total_RAM {
    echo "Mémoire RAM totale"
   
}
# Fonciont pour connaitre l'utilisation de la mémoire RAM
function RAM_usage {
    echo "Utilisation de la RAM"
    
}
# Fonciont pour connaitre l'utilisation du disque
function disk_usage {
    echo "Utilisation du disque"
    
}
# Fonction pour connaitre l'utilisation du processeur
function cpu_usage {
    echo "Utilisation du processeur"
    
}

# Définition des couleurs
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    YELLOW='\033[0;33m'
    NC='\033[0m' # Aucune couleur

# Menu

while true; do
    
    echo -e "${RED}------- Menu Informations sur l'Ordinateur -------${NC}"

    echo -e "${BLUE}----- Informations Système -----${NC}"
    echo "1) Version de l'OS"
    echo "2) Nombre de disques"
    echo "3) Partition (nombre, nom, FS, taille) par disque"

    echo -e "${YELLOW}---------------------------------${NC}"

    echo -e "${BLUE}----- Applications et Services -----${NC}"
    echo "4) Liste des applications/paquets installés"
    echo "5) Liste des services en cours d'exécution"
    echo "6) Liste des utilisateurs locaux"

    echo -e "${YELLOW}---------------------------------${NC}"

    echo -e "${BLUE}----- Ressources Système -----${NC}"
    echo "7) Type de CPU, nombre de cœurs, etc."
    echo "8) Mémoire RAM totale"
    echo "9) Utilisation de la RAM"
    echo "10) Utilisation du disque"
    echo "11) Utilisation du processeur"

    echo -e "${YELLOW}---------------------------------${NC}"

    echo "12) Revenir au Menu Précédent"
    echo "13) Quitter le script"

    read -p "Choissisez une option :" choice

    case $choice in
    1)
        OS_Version
        ;;
    2)
        disk_number
        ;;
    3)
        disk_partition
        ;;
    4)
        installed_application
        ;;
    5)
        running_service
        ;;
    6)
        local_user
        ;;
    7)
        CPU_details
        ;;
    8)
        total_RAM
        ;;
    9)
        RAM_usage
        ;;
    10)
        disk_usage
        ;;
    11)
        cpu_usage
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
