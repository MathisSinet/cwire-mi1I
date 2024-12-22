#include "avl.h"

int main (int argc, char* argv[]) {
    // Fichiers d'entrée et de sortie
    FILE* fichierEntree = stdin;
    FILE* fichierSortie = stdout;

    // Récupère le nombre de lignes du fichier d'entrée, passé en paramètre
    int nbLignes = atoi(argv[1]);
    if (nbLignes <= 0)
    {
        // Si le nombre de lignes est incorrect, affiche un message d'erreur et termine le programme
        perror("Nombre de lignes du fichier d'entree incorrect. Pas de donnees ?\n");
        exit(1);
    }

    AVL* a = NULL; // Arbre AVL de stations vide
    int h; // Facteur de variation d'équilibre de l'AVL

    // Données de la ligne lue
    int id = 0;
    long capacite = 0;
    long charge = 0;

    // Lecture des données et calcul de la somme des consommations
    for (int i=0; i<nbLignes; i++) {
        // Lecture d'une ligne du fichier d'entrée (id;capacité;charge)
        fscanf(fichierEntree, "%d;%ld;%ld", &id, &capacite, &charge);
        // Insertion des données dans l'AVL
        a = insertionAVL(a, id, capacite, charge, &h);
    }

    // Exportation des données de l'AVL dans le fichier de sortie
    exporter(a, fichierSortie);

    // Libération de la mémoire allouée pour l'AVL
    a = vide_AVL(a);

    return 0;
}