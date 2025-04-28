#!/bin/sh

# Mettre à jour toutes les applications installées manuellement sous Arch Linux (AUR)

cd ~/aur || { echo "Erreur : impossible d'accéder à ~/aur"; exit 1; }

for repository in *
do
    if [ -d "$repository" ]; then
        cd "$repository" || continue
        echo "Vérification de $repository..."

        # Capturer la sortie de git pull
        git_output=$(git pull 2>&1)

        # Vérifier si le dépôt est déjà à jour
        if echo "$git_output" | grep -q "Already up to date\|Déjà à jour."; then
            echo "$repository est déjà à jour."
        else
            echo "Mise à jour disponible pour $repository. Mettre à jour ? (o/n)"
            read -r reponse
            case "$reponse" in
                [oO]*)
                    makepkg -sirc || echo "Erreur lors de la mise à jour de $repository"
                    ;;
                *)
                    echo "Mise à jour ignorée pour $repository"
                    ;;
            esac
        fi
        cd .. || exit 1
    fi
done