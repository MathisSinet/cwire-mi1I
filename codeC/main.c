#include "traiter.h"
#include "avl.h"

int main (int argc, char* argv[]) {
    FILE* file = fopen(argv[1], "r");
    Station s;
    AVL* a = NULL;
    int h;
    long capacity = 0;
    long load = 0;
    int id = 0;

    while (!feof(file)) {
        fscanf(file, "%d %ld %ld", &id, &capacity, &load);
        a = insertionAVL(a, id, capacity, load, &h); 
    }
    afficheInfixe(a);

    fclose(file);

    return 0;
}