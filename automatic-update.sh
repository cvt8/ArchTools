#!/bin/sh

#Mettre à jour toutes les applications installées manuellement sous Archlinux

cd ~/aur

for repository in * 
do
	if test -d $repository
	then  cd $repository
	echo "$repository"
	git pull
	# vérifier si l'output est "Already up-to-date."
	# si ce n'est pas le cas, demander à l'utilisateur s'il veut mettre à jour
	# si oui, lancer makepkg -sirc
	# si non, continuer

	if test "$(git pull)" != "Déjà à jour."
	then
		echo "mettre à jour ? (o/n)"
		read reponse
		if test $reponse = o
			then  makepkg -sirc
		fi
	fi
	cd ..
	fi
done