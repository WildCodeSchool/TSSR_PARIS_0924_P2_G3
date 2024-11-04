#!bin/bash

# Demande de renseigner le nom d'utilisateur dont vous voulez les informations
function user_name ()
{
    read -p "Entrez le nom d'utilisateur : " USERNAME
    }
# Demande si vous souhaitez poursuivre l'execution du script ou quitter
function ask_continue ()
{
    while true; do
        read -p "Souhaitez-vous effectuer une autre action ? (o/n) : " CONTINUE
        case $CONTINUE in
            [oO]) return ;;  # Continue le script
            [nN]) exit ;;    # Quitte le script
            *) echo "Veuillez entrer 'o' pour oui ou 'n' pour non." ;;
        esac
    done
}

# Définition des fonctions qui donne les informations disponible 
# Fonction qui permet de voir la derniere date de connexion de l'utilisateur
function last_connexion ()
{
    #user_name
    #echo "Date de dernière connexion de l'utilisateur"
    #ssh "$CLIENT_IP" "last $USERNAME"

    user_name
    echo "Date de dernière connexion de l'utilisateur $USERNAME :"
    ssh -t $USER@$CLIENT last -n 1 "$USERNAME"
    ask_continue 
        
}
# Fonction qui permet de voir la date de dernière modification du mot de passe de l'utilisateur
function last_pwd_change {
    user_name
    echo "Date de dernière modification du mot de passe de l'utilisateur $USERNAME :"
    chage -l "$USERNAME" | grep "Last password change"
    ask_continue
}
# Fonction qui permet de lister les sessions ouvertes par l'utilisateur
function user_open_session ()
{
    user_name
    echo "Liste des sessions ouvertes par l'utilisateur :"
    who | grep "$USERNAME"
    ask_continue
    
}
# Fonction qui permet de voir le groupe d’appartenance de l'utilisateur
function user_group {
    user_name
    echo "Groupe d’appartenance de l'utilisateur $USERNAME :"
    groups "$USERNAME"
    ask_continue
    
}
# Fonction qui permet de voir l'historique des commandes exécutées par l'utilisateur
function user_history ()
{
    user_name
    read -p "Combien de lignes de l'historique souhaitez-vous voir ? " LINES
    echo "Historique des $LINES dernieres commandes exécutées par l'utilisateur $USERNAME"
    tail -n "$LINES" /home/"$USERNAME"/.bash_history
    ask_continue
}
# Fonction qui permet de voir les droits/permissions de l’utilisateur sur un dossier
function right_perm_directory ()
{
    user_name
    read -p "Entrez le chemin du dossier : " FILE
    echo "Droits/permissions de l'utilisateur $USERNAME sur le dossier $DIRECTORY :"
    INFO=$(ls -l "$DIRECTORY")
    echo "$INFO"
    if echo "$INFO" | grep -q "$USERNAME"; then
        echo "L'utilisateur $USERNAME a des permissions sur le fichier."
    else
        echo "L'utilisateur $USERNAME n'a pas de permissions sur le fichier."
    fi
    ask_continue
    
}
# Fonction qui permet de voir les droits/permissions de l’utilisateur sur un fichier
function right_perm_file ()
{
    read -p "Entrez le chemin du fichier : " FILE
    echo "Droits/permissions de l'utilisateur $USERNAME sur le fichier $FILE :"
    getfacl "$FILE" | grep "$USERNAME"
    ask_continue
    
}


while true; do
    echo " -------Menu information de l'utilisateur-------"
    echo "1) Date de dernière connexion d’un utilisateur"
    echo "2) Date de dernière modification du mot de passe"
    echo "3) Liste des sessions ouvertes par l'utilisateur"
    echo "4) Groupe d’appartenance d’un utilisateur"
    echo "5) Historique des commandes exécutées par l'utilisateur"
    echo "6) Droits/permissions de l’utilisateur sur un dossier"
    echo "7) Droits/permissions de l’utilisateur sur un fichier"
    echo "8) Revenir au Menu Précédent"
    echo "9) Quitter le script"

    read -p "Choissisez une option :" choice

    case $choice in
    1)
        last_connexion
        ;;
    2)
        last_pwd_change
        ;;
    3)
        user_open_session
        ;;
    4)
        user_group
        ;;
    5)
        user_history
        ;;
    6)
        right_perm_directory
        ;;
    7)
        right_perm_file
        ;;
    8)
        break
        ;;
    9)
        exit
        ;;
    *)
        echo "Option incorrect"
        ;;
    esac
done
