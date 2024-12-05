#!/bin/bash

# Fonction d'erreur
erreur()
{
    ./help.sh
    echo "Temps : 0.00 secondes"
    exit $1
}

# Vérification de la présence de l'option -h
for arg in $@
do
    if [ $arg = '-h' ]
    then
        ./help.sh
        exit 0
    fi
done

# Vérification du nombre d'arguments
if (($# < 3))
then
    echo "Erreur : Nombre d'arguments invalide"
    erreur 2
fi

# Vérification de l'argument 1 "fichier d'entrée"
if [ ! -f $1 ] || [ ! -r $1 ]
then
    echo "Erreur : '$1' n'est pas un fichier valide"
    erreur 3
else
    chemin_entree=$1
fi

# Vérification de l'argument 2 "type de station"
type_station=-1
case $2 in
    'hva') type_station=0 
    ;;
    'hvb') type_station=1 
    ;;
    'lv') type_station=2
    ;;
    *)
        echo "Erreur : Type de station inconnu '$2'"
        erreur 4
        ;;
esac

# Vérification de l'argument 3 "type de consommateur"
type_conso=-1
case $3 in
    'comp') type_conso=0 ;;
    'indiv') type_conso=1
    if (($type_station != 2))
    then
        echo "Erreur : Impossible d'utiliser l'option 'indiv' avec une station $2"
        erreur 5
    fi
    ;;
    'all') type_conso=2 ;;
    *)
        echo "Type de consommateur inconnu '$3'"
        echo "Erreur : Utilisez c-wire.sh -h pour obtenir de l'aide"
        erreur 6
        ;;
esac

# Vérification de l'argument 4 "identifiant de station"
id_centrale=-1
if (($# >= 4))
then
    id_centrale=$4
fi

