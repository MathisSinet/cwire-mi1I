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
    'all') type_conso=0 ;;
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
        echo "Erreur : Utilisez c-wire.sh -h pour obtenir de l'aide"
        erreur 6
        ;;
esac

# Vérification de l'argument 4 "identifiant de station"
id_station=-1
if (($# >= 4))
then id_station=$4
fi

# Vérifier compliation


# Vérification du dossier tmp
if [ -d tmp ]
then cd tmp; rm -f *; cd ..;
else mkdir tmp
fi

# Vérification du dossier graphs
if [ ! -d graphs ]
then mkdir graphs
fi


# Filtrage des données avec awk et obtention du chemin sortie

col=$(($type_station+2)) # colonne du fichier csv
prog_awk=""
chemin_sortie=""

if (($id_station != -1)) # cas du traitement pour une station spécifique
then
    chemin_sortie="${2}_${3}_${4}.csv"

    if (($type_station <= 1)) # hvb ou hva
    then
        prog_awk='NR>1 && NF=8 { if ($'"$col==$id_station"') print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
    else # lv
        case $3 in
            'all')
                prog_awk='NR>1 && NF=8 { if ($'"$col==$id_station"') print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
                ;;
            'comp')
                prog_awk='NR>1 && NF=8 { if ($'"$col==$id_station"' && $5!="-") print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
                ;;
            'indiv')
                prog_awk='NR>1 && NF=8 { if ($'"$col==$id_station"' && $6!="-") print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
                ;;
        esac
    fi

    awk "$prog_awk" FS=';' OFS=' ' $chemin_entree > tmp/input.csv

    if (($? != 0)); then
        echo "Erreur awk"
        erreur 10
    fi
    _lc=`wc -l tmp/input.csv | cut -f1 -d' '`
    if (($_lc == 0)); then
        echo "Aucune entrée ne correspond aux critères sélectionnés"
        echo "Traitement pour toutes les stations"
        id_station=-1
    fi

fi

if (($id_station == -1)) # cas du traitement pourtoutes les stations
then
    chemin_sortie="${2}_${3}.csv"

    if (($type_station <= 1)) # hvb ou hva
    then
        prog_awk='NR>1 && NF=8 { if ($'$col'!="-") print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
    else # lv
        case $3 in
            'all')
                prog_awk='NR>1 && NF=8 { if ($'$col'!="-") print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
                ;;
            'comp')
                prog_awk='NR>1 && NF=8 { if ($'$col'!="-" && $5!="-") print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
                ;;
            'indiv')
                prog_awk='NR>1 && NF=8 { if ($'$col'!="-" && $6!="-") print $'$col',($7=="-"?0:$7),($8=="-"?0:$8)}'
                ;;
        esac
    fi

    awk "$prog_awk" FS=';' OFS=' ' $chemin_entree > tmp/input.csv

    if (($? != 0)); then
        echo "Erreur awk"
        erreur 10
    fi
    _lc=`wc -l tmp/input.csv | cut -f1 -d' '`
    if (($_lc == 0)); then
        echo "Aucune entrée ne correspond aux critères sélectionnés"
        erreur 11
    fi
fi

# Exécution du pprogramme

if (($id_station == -1)) && (($type_station == 2)) && (($type_conso == 0))
then
    echo "Bonjour"
    $PROG $chemin_entree $chemin_sortie 1
else
    $PROG $chemin_entree $chemin_sortie 0
fi