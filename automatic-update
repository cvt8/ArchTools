#!/bin/sh

#Mettre à jour toutes les applications installées manuellement sous Archlinux

for repository in * 
do
	if test -d $repository
	then  cd $repository
	echo "$repository"
	git pull
	echo "mettre à jour ? (o/n)"
	read reponse
	if test $reponse = o
		then  makepkg -sirc
	fi
	cd ..
	fi
done
