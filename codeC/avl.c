#include "avl.h"

// Fonction pour créer une station avec un identifiant donné
Station creerStation(int id) {
    Station s;
    s.capacite = 0; // Initialisation de la capacité
    s.charge = 0; // Initialisation de la charge
    s.id = id; // Attribue l'identifiant
    return s;
}

// Fonction pour créer un noeud AVL avec un identifiant donné
AVL* creerAVL(int id)
{
    AVL* nouv = (AVL*) malloc(sizeof(AVL)); // Allocation mémoire pour un nouveau noeud

    if (nouv == NULL)
    {
        exit(1); // Si l'allocation échoue, le programme s'arrête
    }

    nouv->station = creerStation(id); // Créer une station et l'associer au noeud
    nouv->fg = NULL; // Pas de sous-arbre gauche initialement
    nouv->fd = NULL; // Pas de sous-arbre droit initialement
    nouv->eq = 0; // Facteur d'équilibre initialisé

    return nouv;
}

// Renvoie 1 si l'arbre est vide
int estVide(AVL* a)
{
    return a == NULL;
}

// Renvoie 1 si le noeud est une feuille
int estFeuille(AVL* a)
{
    return estVide(a) || (estVide(a->fg) && estVide(a->fd));
}

// Renvoie l'identifiant de la station
int id(AVL* a)
{
    return estVide(a) ? 0 : a->station.id;
}

// Vérifie si le fils gauche existe
int existeFilsGauche(AVL* a)
{
    return !estVide(a) && !estVide(a->fg);
}

// Vérifie si le fils droit existe
int existeFilsDroit(AVL* a)
{
    return !estVide(a) && !estVide(a->fd);
}

// Ajoute un fils gauche au noeud
int ajouterFilsGauche(AVL* a, int e)
{
    if (estVide(a))
    {
        return 0; // échec si le noeud est vide
    }
    a->fg = creerAVL(e);
    return 1; //Succès
}

// Ajoute un fils droit au noeud
int ajouterFilsDroit(AVL* a, int e)
{
    if (estVide(a))
    {
        return 0; // échec si le noeud est vide
    }
    a->fd = creerAVL(e);
    return 1; //Succès
}

// Cherche un noeud par identifiant de station, le renvoie si trouvé, sinon NULL
AVL* rechercheAVL(AVL* a, int elmt)
{
    if (a == NULL)
    {
        return NULL; // L'élément n'est pas trouvé
    }
    else if (id(a) == elmt)
    {
        return a; // L'élément est trouvé
    }
    else if (elmt < id(a))
    {
        return rechercheAVL(a->fg, elmt); // Recherche dans le sous-arbre gauche
    }
    else
    {
        return rechercheAVL(a->fd, elmt); // Recherche dans le sous-arbre droit
    }
}

// Exporte toutes les données de l'arbre AVL dans un fichier
void exporter(AVL* a, FILE* fichierSortie)
{
    if (!estVide(a))
    {
        exporter(a->fg, fichierSortie);
        // écrit les données de la station
        fprintf(fichierSortie, "%d:%ld:%ld:%ld\n", a->station.id, a->station.capacite, a->station.charge, a->station.capacite-a->station.charge);
        exporter(a->fd, fichierSortie);
    }
}

// Effectue une rotation gauche
AVL* rotGauche(AVL* a)
{
    AVL* pivot = a->fd;
    int eqa, eqp;

    // Rotation
    a->fd = pivot->fg;
    pivot->fg = a;

    // Mise à jour des facteurs d'équilibre
    eqa = a->eq;
    eqp = pivot->eq;

    a->eq = eqa - max(eqp, 0) - 1;
    pivot->eq = min3(eqa-2, eqa+eqp-2, eqp-1);
    a = pivot;

    return a;
}

// Effectue une rotation droite
AVL* rotDroite(AVL* a)
{
    AVL* pivot = a->fg;
    int eqa, eqp;

    // Rotation
    a->fg = pivot->fd;
    pivot->fd = a;

    // Mise à jour des facteurs d'équilibre
    eqa = a->eq;
    eqp = pivot->eq;

    a->eq = eqa - min(eqp, 0) + 1;
    pivot->eq = max3(eqa+2, eqa+eqp+2, eqp+1);
    a = pivot;

    return a;
}

// Effectue une double rotation gauche
AVL* doubleRotationGauche(AVL* a)
{
    a->fd = rotDroite(a->fd); // Rotation droite sur le sous-arbre droit
    return rotGauche(a); //Puis rotation gauche
}

// Effectue une double rotation droite
AVL* doubleRotationDroite(AVL* a)
{
    a->fg = rotGauche(a->fg); // Rotation gauche sur le sous-arbre gauche
    return rotDroite(a); //Puis rotation droite
}

// équilibrage du sous-arbre AVL
AVL* equilibrerAVL(AVL* a)
{
    // Déséquilibre à droite
    if (a->eq >= 2)
    {
        if (a->fd->eq >= 0)
        {
            return rotGauche(a);
        }
        else
        {
            return doubleRotationGauche(a);
        }
    }
    // Déséquilibre à gauche
    else if (a->eq <= -2)
    {
        if (a->fg->eq <= 0)
        {
            return rotDroite(a);
        }
        else
        {
            return doubleRotationDroite(a);
        }
    }
    // Aucun rééquilibrage nécessaire
    return a;
}

// Insère une station dans d'AVL ou met à jour ses données
AVL* insertionAVL(AVL* a, int e, long capacite, long charge, int* h)
{
    // La station n'est pas dans l'AVL
    if (estVide(a))
    {
        *h = 1;
        a = creerAVL(e);
        a->station.capacite += capacite; // Ajoute la capacité la station
        a->station.charge += charge; // Ajoute la charge de la station
        return a;
    }
    // Recherche dans le sous-arbre gauche
    else if (e < id(a))
    {
        a->fg = insertionAVL(a->fg, e, capacite, charge, h);
        *h = -*h;
    }
    // Recherche dans le sous-arbre droit
    else if (e > id(a))
    {
        a->fd = insertionAVL(a->fd, e, capacite, charge, h);
    }
    // Station trouvée
    else if (e == id(a))
    {
        *h = 0;
        // Mise à jour des données
        a->station.capacite += capacite;
        a->station.charge += charge;
        return a;
    }
    if (*h != 0)
    {
        a->eq = a->eq + *h; // Mise à jour du facteur d'équilibre
        a = equilibrerAVL(a); // Equilibrage si nécessaire
        if (a->eq == 0)
        {
            *h = 0;
        }
        else
        {
            *h = 1;
        }
    }
    return a;
}

// Vide l'AVL et libère la mémoire
AVL* vide_AVL(AVL* a)
{
    if (a != NULL)
    {
        a->fg = vide_AVL(a->fg);
        a->fd = vide_AVL(a->fd);
        free(a);
        return NULL;
    }
    else
    {
        return NULL;
    }
}
