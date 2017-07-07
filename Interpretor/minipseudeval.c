#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <setjmp.h>
#include "minipseudtree.h"
#include "Values.h"

int printDepth = 0;
int funcDepth = 0;

LinkedList *values;

double evalExpr(Node *node) {
	switch ( node->type ) {
	    case NTEMPTY:  return 0.0;
	    case NTNUM: return node->val;	 
	    case NTPLUS: return evalExpr(node->children[0])	+ evalExpr(node->children[1]);
	    case NTMIN: return evalExpr(node->children[0]) - evalExpr(node->children[1]);
	    case NTMULT: return evalExpr(node->children[0])	* evalExpr(node->children[1]);
	    case NTDIV: return evalExpr(node->children[0]) / evalExpr(node->children[1]);
	    case NTPOW: return pow(evalExpr(node->children[0]),	evalExpr(node->children[1]));
        case NTVAR: return getValue(values, node->var);
        case NT_EQUALS: return evalExpr(node->children[0]) == evalExpr(node->children[1]);
        case NT_NOTEQUALS: return evalExpr(node->children[0]) != evalExpr(node->children[1]);        
        case NT_INF: return evalExpr(node->children[0]) < evalExpr(node->children[1]);
        case NT_SUP: return evalExpr(node->children[0]) > evalExpr(node->children[1]);
        case NT_INFEQUALS: return evalExpr(node->children[0]) <= evalExpr(node->children[1]);
        case NT_SUPEQUALS: return evalExpr(node->children[0]) >= evalExpr(node->children[1]);

	    default: 
		    printf("Error in evalExpr ... Wrong node type: %s\n", node2String(node));
		    exit(1);
    };
}

void evalInst(Node* node) {
	double val;
    int res;
	switch (node->type) {
        case NTIF:
            if (evalExpr(node->children[0])) {   
                // printf("enter");                
                evalInst(node->children[1]);
            }
            break;
        case NTIFELSE:
            if (evalExpr(node->children[0]->children[0])) {
                evalInst(node->children[0]->children[1]);
            } else {
                evalInst(node->children[1]);
            }
            break;
        case NTFLOOP:
            while (evalExpr(node->children[0])) {
                evalInst(node->children[1]);
            }
            break;
        case NTREPEAT:
            for (int i = 0; i < evalExpr(node->children[0]); i++) {
                evalInst(node->children[1]);
            }
            break;
        case NTREPEATSTATIC:
            res = evalExpr(node->children[0]);
            for (int i = 0; i < res; i++) {
                evalInst(node->children[1]);
            }
            break;
        case NTAFF:  
            if (values == NULL) {
                values = malloc(sizeof(LinkedList));
            }  
            
            addVariable(values, node->children[0]->var, evalExpr(node->children[1]));
                                    
            break;
        case NTSHOW:
            printf("%lf\n", evalExpr(node->children[0]));            
            break;
	    case NTEMPTY:            
            break;
        /*case NTMULTILINE:
            evalInst(node->children[0]);
            evalInst(node->children[1]);
            break;*/
	    case NTINSTLIST:
		    evalInst(node->children[0]);
		    evalInst(node->children[1]);
		    break;	    
	    default:
		    printf("Error in evalInst ... Wrong node type: %s\n", node2String(node));
		    exit (1);
	}
}

void eval(Node *node) {	 
	evalInst(node);
}
