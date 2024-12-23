#!/bin/bash

PROG="codeC/prog"

# Fonction d'erreur
erreur()
{
    echo "Affichage de l'aide"
    echo
    cat help.txt
    exit $1
}

# Vérification de la présence de l'option -h
for arg in $@
do
    if [ $arg = '-h' ]
    then
        cat help.txt
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

# Vérification de l'argument 4 "identifiant de centrale"
id_centrale=-1
if (($# >= 4))
then id_centrale=$4
fi

# Vérification de la compliation
if [ ! -f $PROG ]
then
    echo "Compliation du programme..."
    cd codeC
    make
    if (($? != 0)); then
        echo "Erreur de compliation du programme"
        erreur 7
    fi
    cd ..
    echo "Compilation terminée"
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

# Vérification du dossier tests
if [ ! -d tests ]
then mkdir tests
fi

# Initialisation du temps d'exécution
temps_debut=`date +%s.%N`

# Filtrage des données avec grep et obtention du chemin sortie

chemin_sortie="" # chemin de sortie final
chemin_sortie_minmax="" # chemin de sortie pour le traitement lv_all_minmax
tete_sortie="" # en-tête du fichier CSV de sortie
nblignes=0 # nombre de lignes du fichier temporaire envoyé au programme C


# Traitement pour une centrale spécifique
# Envoi des données de type (station;capacité;consommation) dans tmp/input.csv
if (($id_centrale != -1)) 
then
    chemin_sortie="tests/${2}_${3}_${4}.csv"
    chemin_sortie_minmax="tests/lv_all_minmax_${4}.csv"

    if (($type_station == 0)) # hvb
    then
        grep -E "^$4;[0-9]+;-" $chemin_entree | cut -d';' -f2,7,8 | tr '-' '0' > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
        tete_sortie="Station_HV-B:Capacité:Consommation(entreprises)"
    elif (($type_station == 1)) # hva
    then
        grep -E "^$4;[0-9-]+;[0-9]+;-" $chemin_entree | cut -d';' -f3,7,8 | tr '-' '0' > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
        tete_sortie="Station_HV-A:Capacité:Consommation(entreprises)"
    else # lv
        case $3 in
            'all')
                grep -E "^$4;-;[0-9-]+;[0-9]+;" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                tete_sortie="Poste_LV:Capacité:Consommation(tous)"
                ;;
            'comp')
                grep -E "^$4;-;[0-9-]+;[0-9]+;[0-9-]+;-;" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                tete_sortie="Poste_LV:Capacité:Consommation(entreprises)"
                ;;
            'indiv')
                grep -E "^$4;-;[0-9-]+;[0-9]+;-;[0-9-]+" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                tete_sortie="Poste_LV:Capacité:Consommation(particuliers)"
                ;;
        esac
    fi
fi

# Traitement pour toutes les centrales
# Envoi des données de type (station;capacité;consommation) dans tmp/input.csv
if (($id_centrale == -1))
then
    chemin_sortie="tests/${2}_${3}.csv"
    chemin_sortie_minmax="tests/lv_all_minmax.csv"

    if (($type_station == 0)) # hvb
    then
        grep -E "^[0-9-]+;[0-9]+;-" $chemin_entree | cut -d';' -f2,7,8 | tr '-' '0' | cat > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
        tete_sortie="Station_HV-B:Capacité:Consommation(entreprises)"
    elif (($type_station == 1)) # hva
    then
        grep -E "^[0-9-]+;[0-9-]+;[0-9]+;-" $chemin_entree | cut -d';' -f3,7,8 | tr '-' '0' | cat > tmp/input.csv
        nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
        tete_sortie="Station_HV-A:Capacité:Consommation(entreprises)"
    else # lv
        case $3 in
            'all')
                grep -E "^[0-9]+;-;[0-9-]+;[0-9]" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' | cat > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                tete_sortie="Poste_LV:Capacité:Consommation(tous)"
                ;;
            'comp')
                grep -E "^[0-9]+;-;[0-9-]+;[0-9]+;[0-9-]+;-;" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' | cat > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                tete_sortie="Poste_LV:Capacité:Consommation(entreprises)"
                ;;
            'indiv')
                grep -E "^[0-9]+;-;[0-9-]+;[0-9]+;-;[0-9-]+" $chemin_entree | cut -d';' -f4,7,8 | tr '-' '0' | cat > tmp/input.csv
                nblignes=`wc -l tmp/input.csv | cut -f1 -d' '`
                tete_sortie="Poste_LV:Capacité:Consommation(particuliers)"
                ;;
        esac
    fi
fi

# Exécution du pprogramme

if (($nblignes == 0))
then
    echo "Aucune donnée ne correspond aux critères sélectionnés"
    erreur 8
fi

$PROG $nblignes < tmp/input.csv > tmp/output.csv
# Sortie : (station;capacité;consommation;capacité-consommation)

# Vérification que le programme C s'est bien déroulé
erreur_c=$?
if ((erreur_c != 0)); then
    echo "Erreur lors de l'exécution du programme C : erreur $erreur_c"
    erreur 15
fi

# Tri des données en sortie du programme C
echo $tete_sortie > $chemin_sortie # écriture de l'en-tête
cut -d: -f1,2,3 "tmp/output.csv" | sort -k2 -t: -n >> $chemin_sortie # tri par capacité
echo "Fichier $chemin_sortie généré"

# Traitement lv_all_minmax
if (($type_conso == 0))
then
    # Création du fichier lv_all_minmax.csv
    nbstations=`wc -l tmp/output.csv | cut -f1 -d' '`
    if (($nbstations >= 20))
    then
        sort "tmp/output.csv" -k4 -t: -n | tee | { head -n10 ; tail -n10 ; } | cut -d: -f1,2,3 > $chemin_sortie_minmax
    else
        sort "tmp/output.csv" -k4 -t: -n | cut -d_ -f1,2,3 > $chemin_sortie_minmax
    fi
    echo "Fichier $chemin_sortie_minmax généré"
    # Création du graphique de consommation des stations extrémales
    if [ -f plot_script ]; then
        gnuplot -e "data='$chemin_sortie_minmax'" plot_script 
        if (( $? != 0 )); then
            echo "Errur lors de la génération du graphique"
        else
            echo "Graphique généré dans graphs/graph.png"
        fi
    else
        echo "Script de génération du graphique introuvable"
    fi
fi

# Calcul du temps d'exécution
temps_fin=`date +%s.%N`
temps_tot=`echo $temps_fin-$temps_debut | bc | sed 's/....$//'`

echo "Le programme s'est terminé avec succès"

# Affichage du temps d'exécution
echo "Temps d'exécution : $temps_tot secondes"