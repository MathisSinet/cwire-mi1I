#include "traiter.h"
#include "avl.h"



Station traiter (Station s, int argc, char* argv[]) {
    FILE* file = fopen(argv[1], "r");
    AVL* a = NULL;
    int h;
    long capacity = 0;
    long load = 0;
    int id = 0;

    while (!feof(file)) {
        fscanf(file, "%d %ld %ld", &id, &capacity, &load);
        AVL* recherche = rechercheAVL(a, id);
        if (recherche == NULL) {
            a = insertionAVL(a, id, &h); 
        }
        recherche->station.capacity += capacity;
        recherche->station.load += load; 
        recherche->station.id = id;
    }
    

    fclose(file);
    return s;
}