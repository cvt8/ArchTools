#!/bin/bash

# Script de maintenance automatique pour Arch Linux
# Met à jour le système, les paquets AUR, supprime les orphelins et nettoie le cache

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Pas de couleur

# Fonction pour afficher des messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERREUR]${NC} $1" >&2
}

# Fonction pour demander une confirmation
confirm() {
    echo -e "${YELLOW}$1 (o/n)${NC}"
    read -r response
    case "$response" in
        [oO]*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Vérifier si l'utilisateur a les privilèges nécessaires
if ! command -v sudo >/dev/null 2>&1; then
    error "sudo est requis pour exécuter ce script."
    exit 1
fi

# Vérifier si pacman est disponible
if ! command -v pacman >/dev/null 2>&1; then
    error "Ce script est conçu pour Arch Linux (pacman requis)."
    exit 1
fi

# Étape 1 : Mise à jour du système
log "Mise à jour des paquets du système avec pacman..."
if ! sudo pacman -Syu --noconfirm; then
    error "Échec de la mise à jour du système."
    exit 1
fi

# Étape 2 : Mise à jour des paquets AUR
log "Mise à jour des paquets AUR..."
aur_script="$HOME/aur/automatic-update.sh"
if [ -x "$aur_script" ]; then
    if ! bash "$aur_script"; then
        error "Échec de l'exécution de $aur_script."
        exit 1
    fi
else
    log "Script AUR ($aur_script) non trouvé ou non exécutable. Mise à jour AUR ignorée."
fi

# Étape 3 : Suppression des paquets orphelins
log "Recherche des paquets orphelins..."
orphans=$(pacman -Qtdq)
if [ -n "$orphans" ]; then
    log "Paquets orphelins trouvés : $orphans"
    if confirm "Supprimer les paquets orphelins ?"; then
        if ! sudo pacman -Rns $orphans --noconfirm; then
            error "Échec de la suppression des paquets orphelins."
            exit 1
        fi
        log "Paquets orphelins supprimés."
    else
        log "Suppression des orphelins ignorée."
    fi
else
    log "Aucun paquet orphelin trouvé."
fi

# Étape 4 : Nettoyage du cache
log "Nettoyage du cache des paquets..."
if confirm "Supprimer le cache des anciens paquets ?"; then
    if ! sudo pacman -Scc --noconfirm; then
        error "Échec du nettoyage du cache."
        exit 1
    fi
    log "Cache nettoyé."
else
    log "Nettoyage du cache ignoré."
fi

log "Maintenance terminée avec succès !"