#ifndef AVL_H
#define AVL_H

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// Macros pour fonctions minimum et maximum
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))
// Minimum parmi trois valeurs
#define min3(a,b,c) (min(min(a,b),c))
// Maximum parmi trois valeurs
#define max3(a,b,c) (max(max(a,b),c))

// Structure d'une station
typedef struct {
    int id; // Identifiant unique de la station
    long capacite; // Capacité de la station
    long charge; // Charge de la station
}
Station;

// Structure d'un noeud d'un arbre AVL de structures
typedef struct _avl
{
    Station      station;
    int          eq;
    struct _avl* fg;
    struct _avl* fd;
}
AVL;

// Prototypes des fonctions
Station creerStation(int id);
AVL* creerAVL(int r);
int estVide(AVL* a);
int estFeuille(AVL* a);
int id(AVL* a);
int existeFilsGauche(AVL* a);
int existeFilsDroit(AVL* a);
int ajouterFilsGauche(AVL* a, int e);
int ajouterFilsDroit(AVL* a, int e);
AVL* rechercheAVL(AVL* a, int elmt);
void exporter(AVL* a, FILE* fichierSortie);
AVL* rotGauche(AVL* a);
AVL* rotDroite(AVL* a);
AVL* doubleRotationGauche(AVL* a);
AVL* doubleRotationDroite(AVL* a);
AVL* equilibrerAVL(AVL* a);
AVL* insertionAVL(AVL* a, int e, long capacite, long charge, int* h);
AVL* vide_AVL(AVL* a);

#endif
