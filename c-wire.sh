#!/bin/bash

PROG="codeC/prog"

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
    'hvb') type_station=0 
    ;;
    'hva') type_station=1 
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
    'all') type_conso=0
    if (($type_station != 2))
    then
        echo "Erreur : Impossible d'utiliser l'option 'all' avec une station $2"
        erreur 5
    fi
    ;;
    'comp') type_conso=1 ;;
    'indiv') type_conso=2
    if (($type_station != 2))
    then
        echo "Erreur : Impossible d'utiliser l'option 'indiv' avec une station $2"
        erreur 5
    fi
    ;;
    *)
        echo "Type de consommateur inconnu '$3'"
        erreur 6
        ;;
esac

# Vérification de l'argument 4 "identifiant de station"
id_station=-1
if (($# >= 4))
then id_station=$4
fi

# Vérifier compliation
if [ ! -f $PROG ]
then
    cd codeC
    make
    cd ..
fi

# Vérification du dossier tmp
if [ -d tmp ]
then cd tmp; rm -f *; cd ..;
else mkdir tmp
fi

# Vérification du dossier graphs
if [ ! -d graphs ]
then mkdir graphs
fi

temps_debut=`date +%s.%N`

# Filtrage des données avec awk et obtention du chemin sortie

col=$(($type_station+2)) # colonne du fichier csv
regex=""
chemin_sortie=""
nblignes=0

if (($id_station != -1)) # cas du traitement pour une station spécifique
then
    chemin_sortie="${2}_${3}_${4}.csv"

    if (($type_station == 0)) # hvb ou hva
    then
        regex="^[^;]+;$4;-"
        grep -E "$regex" $chemin_entree | cut -d';' -f2,7,8 | tr '-' '0' > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
    elif (($type_station == 1))
    then
        regex="^[^;]+;[^;]+;$4;-"
        grep -E "$regex" $chemin_entree | cut -d';' -f3,7,8 | tr '-' '0' > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
    else # lv
        case $3 in
            'all')
                regex="^[^;]+;[^;]+;[^;]+;$4"
                grep -E "$regex" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                ;;
            'comp')
                regex="^[^;]+;[^;]+;[^;]+;$4;[^;]+;-"
                grep -E "$regex" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                ;;
            'indiv')
                regex="^[^;]+;[^;]+;[^;]+;$4;-;[^;]+"
                grep -E "$regex" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                ;;
        esac
    fi
fi

if (($id_station == -1)) # cas du traitement pour toutes les stations
then
    chemin_sortie="${2}_${3}.csv"

    if (($type_station == 0)) # hvb ou hva
    then
        regex="^[^;]+;[0-9]+;-"
        grep -E "$regex" $chemin_entree | cut -d';' -f2,7,8 | tr '-' '0' > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
    elif (($type_station == 1))
    then
        regex="^[^;]+;[^;]+;[0-9]+;-"
        grep -E "$regex" $chemin_entree | cut -d';' -f3,7,8 | tr '-' '0' > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
    else # lv
        case $3 in
            'all')
                regex="^[^;]+;[^;]+;[^;]+;[0-9]+"
                grep -E "$regex" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                ;;
            'comp')
                regex="^[^;]+;[^;]+;[^;]+;[0-9]+;[^;]+;-"
                grep -E "$regex" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                ;;
            'indiv')
                regex="^[^;]+;[^;]+;[^;]+;[0-9]+;-;[^;]+"
                grep -E "$regex" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                ;;
        esac
    fi
fi

# Exécution du pprogramme

$PROG $nblignes < tmp/input.csv > tmp/output.csv

# Tri des données

cut -d_ -f1,2,3 "tmp/output.csv" | sort -k2 -t_ -n -o $chemin_sortie
if (($type_conso == 0) && ($id_station == -1) && ($nblignes >= 20))
then
    
fi

temps_fin=`date +%s.%N`
temps_tot=`echo $temps_fin-$temps_debut | bc`

echo "Temps d'exécution : $temps_tot"