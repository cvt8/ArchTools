#!/bin/sh

#Mettre à jour toutes les applications installées manuellement sous Archlinux

sudo pacman -Syu

sh automatic-update.sh

sudo pacman -Rns $(pacman -Qtdq) # Remove orphaned packages

sudo pacman -Scc # Remove old package cache