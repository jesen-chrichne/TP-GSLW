#!/bin/bash


if [ $# -ne 1 ]
then
	echo "Specifier le fichier xls"
	echo "$0 exemple.xls"
	exit 99
fi

#La liste utilis�e pour stocker les utilisateurs du pc
UTILISATEURS=( 0 )



index=0
OLDIFS=$IFS
IFS=:
while read -r username _ _ _ _ dir _
do
    USERS[$index]=$username
    index=$(($index+1))
done <<<$(grep /home /etc/passwd | sort -t: -k6 )
IFS=$OLDIFS




FICHIER=$1
PASS=123456

OLDIFS=$IFS
IFS=','
[ ! -f $FICHIER ] && { echo "$FICHIER non existant"; exit 99; }
while read id username nom prenom 
do
	username=${username:1:-1}
        if [[ "$username"  = "username" ]] || [ -z  "$username" ]
	then
		continue
	fi

	#Verification si la personne est d�j� inscrite
	if [[ " ${UTILISATEURS[@]} " =~ " $username " ]];
	then
		echo "$username est d�j� inscrit."
	else
		echo "inscription de $username."
		sudo useradd "$username" --create-home
		#mettre le mots de passe
		echo "$username":${PASS} | sudo chpasswd
	fi

done <<<$(xls2csv ${FICHIER})
IFS=$OLDIFS