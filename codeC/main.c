#include "avl.h"

int main () {
    AVL* a = NULL;
    int h;
    a = insertionAVL(a, 5, &h);
    afficheInfixe(a);
    afficheInfixeEquilibre(a);

    return 0;
}