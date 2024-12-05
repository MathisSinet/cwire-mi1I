#ifndef AVL_H
#define AVL_H

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))
#define min3(a,b,c) (min(min(a,b),c))
#define max3(a,b,c) (max(max(a,b),c))

typedef struct _avl
{
    int          elmt;
    int          eq;
    struct _avl* fg;
    struct _avl* fd;
}
AVL;

AVL* creerAVL(int r);
int estVide(AVL* a);
int estFeuille(AVL* a);
int element(AVL* a);
int existeFilsGauche(AVL* a);
int existeFilsDroit(AVL* a);
int ajouterFilsGauche(AVL* a, int e);
int ajouterFilsDroit(AVL* a, int e);
AVL* rechercheAVL(AVL* a, int elmt);
AVL* afficheInfixe(AVL* a);
AVL* afficheInfixeEquilibre(AVL* a);
AVL* rotGauche(AVL* a);
AVL* rotDroite(AVL* a);
AVL* doubleRotationGauche(AVL* a);
AVL* doubleRotationDroite(AVL* a);
AVL* equilibrerAVL(AVL* a);
AVL* insertionAVL(AVL* a, int e, int* h);
AVL* suppMinAVL(AVL* a, int* h, int* pe);
AVL* suppressionAVL(AVL* a, int e, int* h);


#endif 