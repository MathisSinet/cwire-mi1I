#include "avl.h"

int main (int argc, char* argv[]) {
    FILE* fichierEntree = stdin;
    FILE* fichierSortie = stdout;

    int nbLignes = atoi(argv[1]);
    if (nbLignes <= 0)
    {
        printf("Nombre de lignes du fichier d'entree incorrect\n");
        exit(1);
    }

    Station s;
    AVL* a = NULL;
    int h;
    long capacity = 0;
    long load = 0;
    int id = 0;

    for (int i=0; i<nbLignes; i++) {
        fscanf(fichierEntree, "%d;%ld;%ld", &id, &capacity, &load);
        a = insertionAVL(a, id, capacity, load, &h); 
    }
    exporter(a, fichierSortie);
    a = vide_AVL(a);
    
    return 0;
}