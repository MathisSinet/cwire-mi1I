#include <stdio.h>
#include <stdlib.h>

typedef struct t {
    int value;
    struct t* fg;
    struct t* fd;
}tree_t;

typedef struct n {
    tree_t* tree;
    struct n* next; 
}node_t;

typedef struct q {
    struct n* head;
    struct n* tail;
}queue_t;

tree_t* creationTree(int value) {
    tree_t* new = malloc(sizeof(tree_t));
    if (new == NULL) {
        exit(EXIT_FAILURE);
    }
    new->value = value;
    new->fd = NULL;
    new->fg = NULL;

    return new;
}

int isTreeNull(tree_t* tree) {
    return tree == NULL ? 1 : 0;
}

//{
// int isLeaf(tree_t* tree){
//     return (tree != NULL && tree->fg == NULL && tree->fd == NULL) ? 1 : 0;
// }
//
// int value(tree_t* tree) {
//     return tree->value;
// }
//
// int existeFG(tree_t* tree) {
//     return (tree->fg != NULL) ? 1 : 0;
// }
//
// int existeFD(tree_t* tree) {
//     return (tree->fd != NULL) ? 1 : 0;
// }
// }

void addFG(tree_t* tree, int e) {
    tree->fg = creationTree(e);
}

void addFD(tree_t* tree, int e) {
    tree->fd = creationTree(e);
}

void prefix(tree_t* tree) {
    if (tree != NULL) {
        printf("[%d] ", tree->value);
        prefix(tree->fg);
        prefix(tree->fd);
        
    }
}

tree_t* putValueTree(tree_t* tree) {
    tree = creationTree(1);
    addFD(tree, 8);
    addFG(tree, 2);
    addFG(tree->fg, 3);
    addFD(tree->fg, 6);
    addFG(tree->fg->fg, 4);
    addFD(tree->fg->fg, 5);
    addFD(tree->fg->fd, 7);
    addFG(tree->fd, 9);
    addFD(tree->fd, 10);

    return tree;
}

queue_t createQueue() {
    queue_t queue;
    queue.head = NULL;
    queue.tail = NULL;
    
    return queue;
}

node_t* createNode(tree_t* tree) {
    node_t* new = malloc(sizeof(tree_t));
    if (new == NULL) {
        exit(EXIT_FAILURE);
    }
    new->tree = tree;
    new->next = NULL;

    return new;
}

void push (queue_t* queue, tree_t* tree) {
    if (queue == NULL) {
        exit(EXIT_FAILURE);
    }
    if (queue->head == NULL) {
        
    }
}

int main (void) {
    tree_t* tree = NULL;
    queue_t queue = createQueue();

    tree = putValueTree(tree);
    push(&queue, tree);
    prefix(tree);

    printf("\n");
    return 0;
}