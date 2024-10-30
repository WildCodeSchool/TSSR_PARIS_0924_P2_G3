#!bin/bash

#Menu des Action possible sur l'ordinateur

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
    echo "Arrêt de la machine"
    ssh $USER@$CLIENT "sudo shutdown now"

}
# Fonction qui permet de redémarrer la machine
function reboot() {
    echo "Redémarrage de la machine"
    ssh $USER@$CLIENT "sudo reboot"

}
# Fonction qui permet de verrouiller la machine
function lock() {
    echo "Verrouillage de la machine"
    ssh $USER@$CLIENT "sudo vlock"

}
# Fonction qui permet de mettre à jour le systeme
function update_system() {
    echo "Mise-à-jour du système"
    ssh $USER@$CLIENT "sudo apt update && apt upgrade -y"

}
# Fonction qui permet de prendre la main à distance
function remote_control() {
    read -p "Entrez l'adresse IP ou le nom d'hôte de la machine distante : " CLIENT
    read -p "Entrez le nom d'utilisateur : " USERNAME
    echo "Connexion à $USERNAME@$CLIENT"
    if ssh "$USERNAME@$CLIENT"; then
        echo "Connexion réussie !"
    else
        echo "Échec de la connexion."
    fi

}
# Fonction qui permet de créer un répertoire
function directory_creation() {
    read -p "Quel est le nom du dossier à créer ? DIRECTORY
if [ -d $DIRECTORY ]
then                                                #si le dossier existe
    echo "Le dossier existe déja"
    exit 1
else                                                #si le dossier n'existe pas
    read -p "Où souhaitez vous le créer ?" WHERE
    ssh $USER@$CLIENT sudo mkdir -p $WHERE/$DIRECTORY
    echo "Le dossier $DIRECTORY a bien été crée"
    exit 0
fi

}
# Fonction qui permet de modifier un répertoire
function directory_change() {
    read -p "Quel dossier souhaitez vous modifier ?
    echo "Modification du répertoire"

}
# Fonction qui permet de supprimer un répertoire
function directory_deletion() {
    read -p "Quel dossier souhaitez-vous supprimer ? " DIRECTORY
    if [ -d "$DIRECTORY" ]; then # verification si le dossier existe
        echo "Il s'agit bien d'un dossier présent."
        read -p "Êtes-vous sûr de vouloir le supprimer (oui/non) ? " confirm
        if [ "$confirm" = "oui" ]; then
            rmdir "$DIRECTORY" # suppression
            echo "Le dossier $DIRECTORY a bien été supprimé."
        else
            echo "Suppression annulée."
        fi
    else # le dossier n'existe pas
        echo "Le dossier n'existe pas."
        exit 1
    fi
}

# Fonction qui permet de définir les règles de pare-feu
function firewall_rules() {
    echo "Définition de règles de pare-feu"

}
# Fonction qui permet d'activer les pare-feu
function firewall_activation() {
    echo "Activation du pare-feu"
    if ! command -v ufw &>/dev/null; then
        echo "UFW n'est pas installé. Installation en cours..."
        sudo apt-get update && sudo apt-get install ufw -y
    fi
    sudo ufw enable #activation
    echo "Le pare-feu a été activé."
    sudo ufw status #verification

}
# Fonction qui permet de désactiver les pare-feu
function firewall_desactivation() {
    echo "Désactivation du pare-feu"
    sudo ufw disable
    echo "Le pare-feu a été désactivé."
    sudo ufw status

}
# Fonction qui permet de d'installer un logiciel
function software_install() {
    read -p "Entrez le nom du logiciel à installer : " SOFTWARE
    echo "Installation du logiciel $SOFTWARE"
    sudo apt-get update && sudo apt-get install -y $SOFTWARE #installation
    if [ $? -eq 0 ]; then                                    #verification
        echo "$SOFTWARE a été installé avec succès."
    else
        echo "Échec de l'installation de $SOFTWARE"
    fi

}
# Fonction qui permet de désinstaller un logiciel
function software_uninstall() {
    read -p "Entrez le nom du logiciel à désinstaller : " SOFTWARE
    echo "Désinstallation du logiciel $SOFTWARE"
    sudo apt-get remove --purge -y $SOFTWARE
    if [ $? -eq 0 ]; then #verification
        echo "$SOFTWARE a été désinstallé avec succès."
    else
        echo "Échec de la désinstallation de $SOFTWARE"
    fi
}
# Fonction qui permet d'exécuter un script sur la machine distante
function remote_execution() {
    read -p "Entrez l'adresse IP ou le nom de la machine distante : " CLIENT
    read -p "Entrez le nom de l'utilisateur : " USER
    read -p "Entrez le chemin du script à exécuter sur la machine distante : " SCRIPT_PATH

    echo "Exécution du script $SCRIPT_PATH sur $CLIENT..."

    # Exécuter le script à distance
    ssh "$USER@$CLIENT" "bash -s" <"$SCRIPT_PATH"

    if [ $? -eq 0 ]; then
        echo "Le script a été exécuté avec succès sur $HOST."
    else
        echo "Échec de l'exécution du script sur $HOST."
    fi

}

while true; do
    echo "======== Action Possible sur la Machine========"

    echo "----- Gestion de la Machine -----"
    echo "1) Arrêt de la machine"
    echo "2) Redémarrage de la machine"
    echo "3) Verrouillage de la machine"
    echo "4) Mise à jour du système"

    echo "---------------------------------"

    echo "----- Gestion des Répertoires -----"
    echo "5) Création de répertoire"
    echo "6) Modification de répertoire"
    echo "7) Suppression de répertoire"

    echo "---------------------------------"

    echo "----- Gestion du Pare-feu -----"
    echo "8) Définition de règles de pare-feu"
    echo "9) Activation du pare-feu"
    echo "10) Désactivation du pare-feu"

    echo "---------------------------------"

    echo "----- Gestion des Logiciels -----"
    echo "11) Installation de logiciel"
    echo "12) Désinstallation de logiciel"

    echo "---------------------------------"

    echo "----- Contrôle à Distance -----"
    echo "13) Prise de main à distance (CLI)"
    echo "14) Exécution de script sur la machine distante"

    echo "---------------------------------"

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
