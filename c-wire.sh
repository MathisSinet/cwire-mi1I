#!/bin/bash

# Vérification de la présence de l'option -h

for arg in $@
do
    if [ $arg = '-h' ]
    then
        ./help.sh
        exit 1
    fi
done

# Vérification des arguments

if (($# < 3))
then
    echo "Nombre d'arguments invalide"
    echo "Utilisez c-wire.sh -h pour obtenir de l'aide"
    exit 2
fi

if [ ! -f $1 ] || [ ! -r $1 ]
then
    echo "$1 n'est pas un fichier valide"
    echo "Utilisez c-wire.sh -h pour obtenir de l'aide"
    exit 3
else
    chemin_entree=$1
fi

type_station=-1
case $2 in
    'hva') type_station=0 
    ;;
    'hvb') type_station=1 
    ;;
    'lv') type_station=2
    ;;
    *)
        echo "Type de station inconnu '$2'"
        echo "Utilisez c-wire.sh -h pour obtenir de l'aide"
        exit 4
        ;;
esac

type_conso=-1
case $3 in
    'comp') type_conso=0 
    ;;
    'indiv') type_conso=1
    if (($type_station != 2))
    then
        echo "Impossible d'utiliser l'option 'indiv' avec une station $2"
        exit 5
    fi
    ;;
    *)
        echo "Type de consommateur inconnu '$3'"
        echo "Utilisez c-wire.sh -h pour obtenir de l'aide"
        exit 6
        ;;
esac

id_centrale=-1

