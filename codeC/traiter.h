#ifndef TRAITER_H
#define TRAITER_H

#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id; 
    long capacity;
    long load;
}
Station;

Station traiter (Station s, int argc, char* argv[]);

#endif