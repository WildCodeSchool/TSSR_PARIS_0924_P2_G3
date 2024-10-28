#!bin/bash


#Menu des Action possible sur l'ordinateur

# Définition des fonctions
function stop {
    echo "Arrêt de la machine"
    # Ajoutez ici votre code pour Arrêter la machiner
}

function reboot {
    echo "Redémarrage de la machine"
    # Ajoutez ici votre code pour redémarrer 
}

function lock {
    echo "Verrouillage de la machine"
    # Ajoutez ici votre code pour verrouiller la machine
}

function update_system {
    echo "Mise-à-jour du système"
    # Ajoutez ici votre code pour mettre à jour le systeme
}

function remote_control {
    echo "Prise de main à distance (CLI)"
    # Ajoutez ici votre code pour prendre la main à distance
}

function directory_creation {
    echo "Création du répertoire"
    # Ajoutez ici votre code pour créer des répertoires
}

function directory_change {
    echo "Modification du répertoire"
    # Ajoutez ici votre code pour modifier des répertoires
}

function directory_deletion {
    echo "Suppression du répertoire"
    # Ajoutez ici votre code pour supprimer un répertoire
}

function firewall_rules {
    echo "Définition de règles de pare-feu"
    # Ajoutez ici votre code pour définir les règles de pare-feu
}

function firewall_activation {
    echo "Activation du pare-feu"
    # Ajoutez ici votre code pour activer les pare-feu
}

function firewall_desactivation {
    echo "Désactivation du pare-feu"
    # Ajoutez ici votre code pour désactiver les pare-feu
}

function software_install {
    echo "Installation du logiciel"
    # Ajoutez ici votre code pour installer un logiciel
}

function software_uninstall {
    echo "Désinstallation du logiciel"
    # Ajoutez ici votre code pour désinstaller un logiciel
}

function remote_execution {
    echo "Exécution de script sur la machine distante"
    # Ajoutez ici votre code exécuter un script sur la machine distante
}



while true
do
	echo " -------Menu Action sur l'ordinateur -------"	
	echo "1) Arrêt de la machine"	
	echo "2) Redémarrage de la machine"	
	echo "3) Verrouillage de la machine"	
	echo "4) Mise-à-jour du système"	
	echo "5) Prise de main à distance (CLI)"	
	echo "6) Création de répertoire"	
	echo "7) Modification de répertoire"	
	echo "8) Suppression de répertoire"	
	echo "9) Définition de règles de pare-feu"	
	echo "10) Activation du pare-feu"	
	echo "11) Désactivation du pare-feu"	
	echo "12) Installation de logiciel"	
	echo "13) Désinstallation de logiciel"	
	echo "14) Exécution de script sur la machine distante"	
	echo "15) Revenir au Menu Précédent"	
	echo "16) Quitter le script"	

read -p "Choissisez une option :" choice

case $choice in
        1) stop
                ;;
        2) reboot
                ;;
        3) lock
                ;;
        4) update_system
                ;;
        5) remote_control
		;;
	6) directory_creation
                ;;
	7) directory_change
                ;;
	8) directory_deletion
                ;;
	9) firewall_rules
                ;;
	10) firewall_activation
                ;;
	11) firewall_desactivation
                ;;
	12) software_install
                ;;
	13) software_uninstall
                ;;
        14) remote_execution
                ;;
        15) break
                ;;
	16) exit
                ;;
        *) echo "Option incorrect"
                ;;
esac
done 

