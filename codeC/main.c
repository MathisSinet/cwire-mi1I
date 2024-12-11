#include "traiter.h"
#include "avl.h"

int main (int argc, char* argv[]) {
    FILE* fichierEntree = fopen(argv[1], "r");
    FILE* fichierSortie = fopen(argv[2], "w");
    Station s;
    AVL* a = NULL;
    int h;
    long capacity = 0;
    long load = 0;
    int id = 0;

    while (!feof(fichierEntree)) {
        fscanf(fichierEntree, "%d %ld %ld", &id, &capacity, &load);
        a = insertionAVL(a, id, capacity, load, &h); 
    }
    afficheInfixe(a, fichierSortie);

    fclose(fichierEntree);
    fclose(fichierSortie);
    
    return 0;
}