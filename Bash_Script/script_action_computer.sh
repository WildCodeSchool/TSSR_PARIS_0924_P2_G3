#!bin/bash

################################################################################################
# Menu des actions sur l'ordinateur, ce script sera rappelé en source depuis le menu principal #
################################################################################################

#Fonctions

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

# Demande si vous souhaitez effectuer une autre action
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

# Fonction qui permet d'arrêter la machine
function stop() {
    get_connection_info
    log "Début de l'arrêt de la machine distante $CLIENT"
    ssh_exe "echo \"Arrêt de la machine $CLIENT \" ; shutdown now"
    log "Fin de l'arrêt de la machine distante $CLIENT"
    ask_continue

}
# Fonction qui permet de redémarrer la machine
function reboot() {
    get_connection_info
    log "Début du redémarrage de la machine distante $CLIENT"
    ssh_exe "echo \"Redémarrage de la machine $CLIENT\" ; reboot"
    log "Fin du redémarrage de la machine distante $CLIENT"
    ask_continue

}
# Fonction qui permet de verrouiller la machine
function lock() {
    get_connection_info
    log "Début du verrouillage de la machine distante $CLIENT"
    ssh_exe "echo \"Verrouillage de la machine\" ; vlock"
    log "Début du verrouillage de la machine distante $CLIENT"
    ask_continue

}
# Fonction qui permet de mettre à jour le systeme
function update_system() {
    get_connection_info
    log "Mise à jour du système sur $CLIENT - Début"
    ssh_exe "echo \"Mise-à-jour du système\" ; apt update && apt upgrade -y"
    log "Mise à jour du système sur $CLIENT - Terminé"
    ask_continue

}
# Fonction qui permet de prendre la main à distance
function remote_control() {
    get_connection_info
    read -p "Entrez l'adresse IP ou le nom d'hôte de la machine distante : " MACHINEDISTANTE
    read -p "Entrez le nom d'utilisateur : " USERMACHINE
    log "Début prise en main à distance sur $MACHINEDISTANTE depuis $USERMACHINE"
    ssh_exe <<EOF
    echo "Connexion à $USERMACHINE@$MACHINEDISTANTE"
    if ssh -t $USER@$CLIENT; then
        echo "Connexion réussie !" 
    else
        echo "Échec de la connexion."
    fi
EOF
    log "Fin de la prise en main à distance"
    ask_continue

}
# Fonction qui permet de créer un répertoire
function directory_creation() {
    get_connection_info
    read -p "Quel est le nom du dossier à créer ? " DIRECTORY
    read -p "Où souhaitez-vous le créer ? " WHERE
    log "Début de création du dossier $DIRECTORY dans $WHERE"
    # Vérifie si le dossier existe déjà dans le répertoire spécifié
    ssh_exe <<EOF
    if [ -d $DIRECTORY ]; then
        echo "Le dossier existe déjà." >> $LOG_FILE
        exit 1
    else
    # Crée le dossier avec le chemin spécifié
        mkdir -p $WHERE/$DIRECTORY
        echo "Le dossier $DIRECTORY a bien été créé." 
        exit 0
    fi
EOF
    log "Fin de création du dossier"
    ask_continue
}

# Fonction qui permet de modifier un répertoire
function directory_change() {
    get_connection_info
    read -p "Quel dossier souhaitez vous modifier ?" DIRECTORY
    read -p "Quel est le nouveau nom du répertoire ?" NEW_DIRECTORY_NAME
    log "Début de la modification du répertoire $DIRECTORY"
    ssh_exe <<EOF
  if [ -d "$DIRECTORY" ]
  then
    mv "$DIRECTORY" "$NEW_DIRECTORY_NAME"
    if [ $? -eq 0 ]; then
      echo "Le répertoire $DIRECTORY a été renommé en $NEW_DIRECTORY_NAME avec succès" 
      exit 0
    else
      echo "Erreur : Impossible de renommer le répertoire $DIRECTORY" 
      exit 1
    fi
  else
    echo "Erreur : Le répertoire $DIRECTORY n'existe pas." 
    exit 1
  fi
EOF
    log "Fin de modification du répertoire"
    ask_continue

}
# Fonction qui permet de supprimer un répertoire
function directory_deletion() {
    get_connection_info
    read -p "Quel dossier souhaitez-vous supprimer ? " DIRECTORY
    log "Début de suppression du dossier $DIRECTORY"
    ssh_exe <<EOF
    if [ -d "$DIRECTORY" ]; then # verification si le dossier existe
        echo "Il s'agit bien d'un dossier présent." 
    then
            rmdir $DIRECTORY # suppression
            echo "Le dossier $DIRECTORY a bien été supprimé." 
    else 
        echo "Le dossier n'existe pas." 
        exit 1
    fi
EOF
    log "Fin de suppression du dossier $DIRECTORY"
    ask_continue
}

# Fonction qui permet de définir les règles de pare-feu
function firewall_rules() {
    get_connection_info
    read -p "Quel action souhaitez-vous effectuer (allow/deny) ?" ACTION
    if [[ "$ACTION" != "allow" && "$ACTION" != "deny" ]]; then
        echo "Action invalide. Veuillez entrer 'allow' ou 'deny'."
        exit 1
    fi
    read -p "Quel est l'adresse IP ?" IP
    if ! [[ "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Adresse IP invalide. Veuillez entrer une adresse IP valide."
        exit 1
    fi
    read -p "Sur quel port souhaitez-vous appliquer la règle ?" PORT
    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        echo "Port invalide. Veuillez entrer un numéro de port valide."
        exit 1
    fi
    log "Début de définition de règles de pare-feu : $ACTION from $IP to any port $PORT"
    ssh_exe <<EOF
    ufw $ACTION from $IP to any port $PORT
    systemctl restart ufw
    iptables -L -v -n
    echo "Règle de pare-feu appliquée avec succès."
EOF
    log "Fin de définition de la régle"
    ask_continue

}
# Fonction qui permet d'activer les pare-feu
function firewall_activation() {
    get_connection_info
    log "Début activation du pare-feu"
    ssh_exe <<EOF
    echo "Activation du pare-feu"
    if ! command -v ufw &>/dev/null; then
        echo "UFW n'est pas installé. Installation en cours..."
        apt-get update && apt-get install ufw -y
    fi
    ufw enable #activation
    echo "Le pare-feu a été activé."
    ufw status #verification
EOF
    log "Fin d'activation du pare-feu"
    ask_continue

}
# Fonction qui permet de désactiver les pare-feu
function firewall_desactivation() {
    get_connection_info
    log "Début de désactivation du pare-feu"
    ssh_exe "ufw disable && ufw status"
    echo "Le pare-feu a été désactivé."
    log "Fin de désactivation du pare-feu"
    ask_continue

}
# Fonction qui permet de d'installer un logiciel
function software_install() {
    get_connection_info
    read -p "Entrez le nom du logiciel à installer : " SOFTWARE
    log "Installation du logiciel $SOFTWARE"
    ssh_exe <<EOF
    echo "Installation du logiciel $SOFTWARE"
    apt-get update && apt-get install -y $SOFTWARE #installation
    if [ $? -eq 0 ]; then                                    #verification
        echo "$SOFTWARE a été installé avec succès." 
    else
        echo "Échec de l'installation de $SOFTWARE" 
    fi
EOF
    log "Fin d'installation du logiciel"
    ask_continue

}
# Fonction qui permet de désinstaller un logiciel
function software_uninstall() {
    get_connection_info
    read -p "Entrez le nom du logiciel à désinstaller : " SOFTWARE
    log "Désinstallation du logiciel $SOFTWARE"
    ssh_exe <<EOF
    echo "Désinstallation du logiciel $SOFTWARE"
    apt-get remove --purge -y $SOFTWARE
    if [ $? -eq 0 ]; then #verification
        echo "$SOFTWARE a été désinstallé avec succès." 
    else
        echo "Échec de la désinstallation de $SOFTWARE" 
    fi
EOF
    log "Fin d'installation du logiciel"
    ask_continue
}

# Fonction qui permet de prendre la main à distance via CLI :
function remote_control() {
    log "Début de session ssh par l'utilisateur $USERDISTANT sur $CLIENT"
    read -p "Entrez le nom d'utilisateur avec lequel vous souhaitez vous connecter : " USERDISTANT
    read -p "Entrez l'adresse IP ou le nom d'hôte de la machine distante :" CLIENT
    ssh $USERDISTANT@$CLIENT
    log "Fin de session"
    ask_continue

}
# Fonction qui permet d'exécuter un script sur la machine distante
function remote_execution() {
    get_connection_info
    read -p "Entrez le chemin du script à exécuter sur la machine distante : " SCRIPT_PATH
    log "Début d'execution du script $SCRIPT_PATH"
    echo "Exécution du script $SCRIPT_PATH sur $CLIENT"
    ssh_exe "bash -s" <"$SCRIPT_PATH"
    if [ $? -eq 0 ]; then
        echo "Le script a été exécuté avec succès sur $HOST."
    else
        echo "Échec de l'exécution du script sur $HOST."
    fi
    log "Fin d'execution du script sur la machine $CLIENT"
    ask_continue

}

###############################################################
#Menu Princpial du script

while true; do
    echo -e "${RED} ------- Action Disponible -------${NC}"

    echo ""

    echo -e "${BLUE}----- Gestion de la Machine -----${NC}"
    echo "1) Arrêt de la machine"
    echo "2) Redémarrage de la machine"
    echo "3) Verrouillage de la machine"
    echo "4) Mise à jour du système"

    echo ""

    echo -e "${BLUE}----- Gestion des Répertoires -----${NC}"
    echo "5) Création de répertoire"
    echo "6) Modification de répertoire"
    echo "7) Suppression de répertoire"

    echo ""

    echo -e "${BLUE}----- Gestion du Pare-feu -----${NC}"
    echo "8) Définition de règles de pare-feu"
    echo "9) Activation du pare-feu"
    echo "10) Désactivation du pare-feu"

    echo ""

    echo -e "${BLUE}----- Gestion des Logiciels -----${NC}"
    echo "11) Installation de logiciel"
    echo "12) Désinstallation de logiciel"

    echo ""

    echo -e "${BLUE}----- Contrôle à Distance -----${NC}"
    echo "13) Prise de main à distance (CLI)"
    echo "14) Exécution de script sur la machine distante"

    echo ""

    echo "15) Revenir au menu précédent"
    echo "16) Quitter le script"

    read -p "Choissisez une option :" choice

    case $choice in
    1)
        stop
        ;;
    2)
        reboot
        ;;
    3)
        lock
        ;;
    4)
        update_system
        ;;
    5)
        directory_creation
        ;;
    6)
        directory_change
        ;;
    7)
        directory_deletion

        ;;
    8)
        firewall_rules
        ;;
    9)
        firewall_activation

        ;;
    10)
        firewall_desactivation

        ;;
    11)
        software_install

        ;;
    12)
        software_uninstall

        ;;
    13)
        remote_control

        ;;
    14)
        remote_execution
        ;;
    15)
        break
        ;;
    16)
        exit
        ;;
    *)
        echo "Option incorrect"
        ;;
    esac
done
