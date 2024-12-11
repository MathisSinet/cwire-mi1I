#include "avl.h"

Station creerStation(int id) {
    Station s;
    s.capacity = 0;
    s.load = 0;
    s.id = id;
    return s;
}

AVL* creerAVL(int id)
{
    AVL* nouv = (AVL*) malloc(sizeof(AVL)); 

    if (nouv == NULL) 
    {
        exit(1);
    }

    nouv->station = creerStation(id);
    nouv->fg = NULL; 
    nouv->fd = NULL; 
    nouv->eq = 0; 

    return nouv; 
}

int estVide(AVL* a)
{
    return a == NULL;
}

int estFeuille(AVL* a)
{
    return estVide(a) || estVide(a->fg) && estVide(a->fd);
}

int id(AVL* a)
{
    return estVide(a) ? 0 : a->station.id;
}

int existeFilsGauche(AVL* a)
{
    return !estVide(a) && !estVide(a->fg);
}

int existeFilsDroit(AVL* a)
{
    return !estVide(a) && !estVide(a->fd);
}

int ajouterFilsGauche(AVL* a, int e)
{
    if (estVide(a))
    {
        return 0;
    }
    a->fg = creerAVL(e);
    return 1;
}

int ajouterFilsDroit(AVL* a, int e)
{
    if (estVide(a))
    {
        return 0;
    }
    a->fd = creerAVL(e);
    return 1;
}

AVL* rechercheAVL(AVL* a, int elmt)
{
    if (a == NULL)
    {
        return NULL;
    }
    else if (id(a) == elmt)
    {
        return a;
    }
    else if (elmt < id(a))
    {
        return rechercheAVL(a->fg, elmt);
    }
    else
    {
        return rechercheAVL(a->fd, elmt);
    }
}

AVL* afficheInfixe(AVL* a)
{
    if (!estVide(a))
    {
        afficheInfixe(a->fg);
        printf("%d %ld %ld \n", a->station.id, a->station.capacity, a->station.load);
        afficheInfixe(a->fd);
    }
}

AVL* afficheInfixeEquilibre(AVL* a)
{
    if (!estVide(a))
    {
        afficheInfixeEquilibre(a->fg);
        printf("Valeur:%d Equilibre:%d\n", id(a), a->eq);
        afficheInfixeEquilibre(a->fd);
    }
}


AVL* affichePrefixeEquilibre(AVL* a)
{
    if (!estVide(a))
    {
        printf("Valeur:%d Equilibre:%d\n", id(a), a->eq);
        affichePrefixeEquilibre(a->fg);
        affichePrefixeEquilibre(a->fd);
    }
}

AVL* affichePrefixeEquilibre2(AVL* a)
{
    if (!estVide(a))
    {
        printf("=Valeur:%d Equilibre:%d\n", id(a), a->eq);
        affichePrefixeEquilibre2(a->fg);
        printf("-Valeur:%d Equilibre:%d\n", id(a), a->eq);
        affichePrefixeEquilibre2(a->fd);
        printf("\\Valeur:%d Equilibre:%d\n", id(a), a->eq);
    }
}

AVL* rotGauche(AVL* a)
{
    AVL* pivot = a->fd;
    int eqa, eqp;

    a->fd = pivot->fg;
    pivot->fg = a;
    eqa = a->eq;
    eqp = pivot->eq;

    a->eq = eqa - max(eqp, 0) - 1;
    pivot->eq = min3(eqa-2, eqa+eqp-2, eqp-1);
    a = pivot;

    return a;
}

AVL* rotDroite(AVL* a)
{
    AVL* pivot = a->fg;
    int eqa, eqp;

    a->fg = pivot->fd;
    pivot->fd = a;
    eqa = a->eq;
    eqp = pivot->eq;

    a->eq = eqa - min(eqp, 0) + 1;
    pivot->eq = max3(eqa+2, eqa+eqp+2, eqp+1);
    a = pivot;

    return a;
}

AVL* doubleRotationGauche(AVL* a)
{
    a->fd = rotDroite(a->fd);
    return rotGauche(a);
}

AVL* doubleRotationDroite(AVL* a)
{
    a->fg = rotGauche(a->fg);
    return rotDroite(a);
}


AVL* equilibrerAVL(AVL* a)
{
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
    return a;
}


AVL* insertionAVL(AVL* a, int e, long capacity, long load, int* h)
{
    if (estVide(a))
    {
        *h = 1;
        a = creerAVL(e);        
        a->station.capacity += capacity;
        a->station.load += load;
        return a;
    }
    else if (e < id(a))
    {
        a->fg = insertionAVL(a->fg, e, capacity, load, h);
        *h = -*h;
    }
    else if (e > id(a))
    {
        a->fd = insertionAVL(a->fd, e, capacity, load, h);
    }
    else if (e == id(a))
    {
        *h = 0;
        a->station.capacity += capacity;
        a->station.load += load;
        return a;
    }
    if (*h != 0)
    {
        a->eq = a->eq + *h;
        a = equilibrerAVL(a);
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


// AVL* suppMinAVL(AVL* a, int* h, int* pe)
// {
//     AVL* temp;

//     if (estVide(a->fg))
//     {
//         *pe = id(a);
//         *h = -1;
//         temp = a;
//         a = a->fd;
//         free(temp);
//         return a;
//     }
//     else
//     {
//         a->fg = suppMinAVL(a->fg, h, pe);
//         *h = -*h;
//     }
    
//     if (*h != 0)
//     {
//         a->eq = a->eq + *h;
//         a = equilibrerAVL(a);
//         if (a->eq == 0)
//         {
//             *h = -1;
//         }
//         else
//         {
//             *h = 0;
//         }
//     }
//     return a;
// }


// AVL* suppressionAVL(AVL* a, int e, int* h)
// {
//     AVL* temp;

//     if (estVide(a))
//     {
//         *h = 0;
//         return a;
//     }
//     if (e > id(a))
//     {
//         a->fd = suppressionAVL(a->fd, e, h);
//     }
//     else if (e < id(a))
//     {
//         a->fg = suppressionAVL(a->fg, e, h);
//         *h = -*h;
//     }
//     else if (existeFilsDroit(a))
//     {
//         a->fd = suppMinAVL(a->fd, h, &(a->station));
//     }
//     else
//     {
//         temp = a;
//         a = a->fg;
//         free(temp);
//         *h = -1;
//         return a;
//     }
//     if (estVide(a))
//     {
//         *h = 0;
//         return a;
//     }
//     if (*h != 0)
//     {
//         a->eq = a->eq + *h;
//         a = equilibrerAVL(a);
//         if (a->eq == 0)
//         {
//             *h = -1;
//         }
//         else
//         {
//             *h = 0;
//         }
//     }
//     return a;
// }