typedef struct Variable Variable;

struct Variable {
    char *name;
    double value;
    Variable *next;
};

typedef struct LinkedList {
    Variable *first;
    Variable *last;
} LinkedList;

void addVariable(LinkedList *list, char *name, double value);
void showList(LinkedList *list);
double getValue(LinkedList *list, char* name);
