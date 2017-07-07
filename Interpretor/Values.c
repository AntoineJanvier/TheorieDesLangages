#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "Values.h"

void addVariable(LinkedList *list, char *name, double value) {
    if (list == NULL)
        list = malloc(sizeof(LinkedList));

    int found = 0;
    Variable *current = list->first;
    Variable *var_to_replace;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            found = 1;
            var_to_replace = current;
            break;
        }
        current = current->next;
    }

    if (found) {
        var_to_replace->value = value;
    } else {
        Variable *new = malloc(sizeof(Variable));

        new->name = malloc(sizeof(name));
        strcpy(new->name, name);
        new->value = value;
        
        if (list->first == NULL) {        
            list->first = new;      
            list->last = new;  
        } else {
            list->last->next = new;
            list->last = list->last->next;
        }
    }
}


/*void addIntructionResultInVariable(LinkedList *list, char *name, Node *var, Node *num) {

    double result_to_save;
    
    if (var->type == NTVAR && num == NTNUM) {
        result_to_save = getValue(list, var->var) + num->val;
    } else {
        
    }
    
    addVariable(list, name, result_to_save);
}*/


void showVariablesTable(LinkedList *list) {
    if (!list->first) {
        printf("Empty !\n");
        return;
    }

    Variable *var = list->first;

    while (var != NULL) {
        printf("%s : %lf\n", var->name, var->value);

        var = var->next;
    }
}

double getValue(LinkedList *list, char* name) {
    Variable *var = list->first;

    while (var != NULL) {
        if (strcmp(name, var->name) == 0) {
            return var->value;
        }

        var = var->next;
    }    

    return 0;
}

/*int main() {
    LinkedList *list = malloc(sizeof(LinkedList));

    addVariable(list, "_toto", 5);
    addVariable(list, "age", 96);
    addVariable(list, "firstname", 8);    

    printf("%lf\n", getValue(list, "_toto"));
    printf("%lf\n", getValue(list, "age"));
    printf("%lf", getValue(list, "pays"));

    showVariablesTable(list);

    return 0;
}*/
