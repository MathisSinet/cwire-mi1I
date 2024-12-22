# cwire-mi1I

Projet d'informatique pour le semestre 1 de Pré Ing 2.

Programme Linux fait avec Shell et C.
Permet d'analyser la consommation d'énergie de stations d'un réseau électrique à partir d'un fichier CSV
Renvoie en sortie un fichier CSV contenant les identifiants des stations, leur capacité ainsi que la somme
de l'énergie demandée par ses consommateurs directs.

Les sorties se font dans les dossiers `tests` et `graphs`.

Pour plus de détails, utilisez `./c-wire.sh -h`.

Vous trouverez dans le dossier `tests` déjà présents les résultats d'exécution du programme
avec le fichier de référence `c-wire_v25.dat` qui n'a pas été inclus dans le dépôt
pour des raisons de taille. Le graphique `lv_all_minmax` a également été inclus.
Les fichiers de tests pré-générés se terminent par `_test`.

## Auteurs

- Kentaro L.
- Mathis S.
- Nourhene M.

## Utilisation

Téléchargez le dossier du projet.

Dans le répertoire du projet :

```./c-wire.sh [Chemin des données] [Type de station] [Type de consommateur] [Identifiant de station (Optionnel)]```

Utilisez `./c-wire.sh -h` pour plus d'informations.

Les temps d'exécution peuvent varier selon la machine utilisée.

## Paquets nécessaires

Compilation : `make, gcc`

Exécution : `bc, gnuplot`
