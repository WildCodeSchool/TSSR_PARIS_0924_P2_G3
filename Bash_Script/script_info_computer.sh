#!bin/bash

#Menu des informations sur l'ordinateur
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
# Définition des couleurs
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # Aucune couleur

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
        echo "Version de l'OS : "
        ssh $USER@$CLIENT lsb_release -a
        ask_continue
        ;;
    2)
        echo "Nombre de disque: "
        ssh $USER@$CLIENT df -h
        ask_continue
        ;;
    3)
        echo "Partition (nombre, nom, FS, taille) par disque : "
        ssh $USER@$CLIENT lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
        ask_continue
        ;;
    4)
        echo "Liste des applications/paquets installées "
        ssh $USER@$CLIENT dpkg --get-selections 
        ;;
    5)
        echo "Liste des services en cours d'execution"
        ssh $USER@$CLIENT systemctl list-units --type=service --state=running
        ;;
    6)
        echo "Liste des utilisateurs locaux"
        ssh $USER@$CLIENT cut -d: -f1 /etc/passwd
        ;;
    7)
        echo "CPU Information :"
        ssh $USER@$CLIENT lscpu
        ;;
    8)
        echo "Mémoire RAM totale"
        ssh $USER@$CLIENT free -h -t
        ;;
    9)
        echo "Utilisation de la RAM"
        ssh $USER@$CLIENT free -h
        ;;
    10)
        echo "Utilisation du disque"
        ssh $USER@$CLIENT df -h
        ;;
    11)
        echo "Utilisation du processeur :"
        ssh $USER@$CLIENT top -b -n1 | grep "Cpu(s)"

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
