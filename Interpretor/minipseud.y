%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "minipseudtree.h"
#include "minipseudeval.h"

extern int  yyparse();
extern FILE *yyin;
int yylex();
int yyerror();

Node root;
 
int exec(Node *node) {
   printGraph(node);
   eval(node);
}

%}

%union {
	struct Node *node;
}

%token   <node> NUM VAR
%token   <node> PLUS MIN MULT DIV POW SHOW AFF EQUALS NOTEQUALS INF SUP INFEQUALS SUPEQUALS IF ELSE IFELSE FLOOP REPEAT REPEATSTATIC
%token   OP_PAR CL_PAR COLON OP_BRA CL_BRA
%token   EOL

%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr
%type   <node> VarExpr
%type   <node> MixedExpr
  
%left OR
%left AND
%left EQ NEQ
%left GT LT GET LET
%left PLUS  MIN
%left MULT  DIV
%left NEG NOT
%right  POW

%start Input
%%

Input:
    {/* Nothing ... */ }
    | Line Input { /* Nothing ... */ }

Line:
    EOL {  }
    | Instlist EOL { exec($1);    }
    ; 

Instlist:
    Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, createNode(NTEMPTY)); }    
    | Instlist Inst{ $$ = nodeChildren(createNode(NTINSTLIST), $1, $2); }
    | IF OP_PAR MixedExpr CL_PAR OP_BRA Instlist CL_BRA { $$ = nodeChildren($1, $3, $6); } 
    ;

Inst:
    VAR AFF MixedExpr COLON { $$ = nodeChildren($2, $1, $3); }
    | SHOW OP_PAR MixedExpr CL_PAR COLON { $$ = nodeChildren($1, $3, createNode(NTEMPTY)); }
    | IF OP_PAR MixedExpr CL_PAR OP_BRA Instlist CL_BRA { $$ = nodeChildren($1, $3, $6); }
    | IF OP_PAR MixedExpr CL_PAR OP_BRA Instlist CL_BRA ELSE OP_BRA Instlist CL_BRA { $$ = nodeChildren(createNode(NTIFELSE), nodeChildren($1, $3, $6), $10); }
    | FLOOP OP_PAR MixedExpr CL_PAR OP_BRA Instlist CL_BRA { $$ = nodeChildren($1, $3, $6); }
    | REPEAT OP_PAR MixedExpr CL_PAR OP_BRA Instlist CL_BRA { $$ = nodeChildren($1, $3, $6); }
    | REPEATSTATIC OP_PAR MixedExpr CL_PAR OP_BRA Instlist CL_BRA { $$ = nodeChildren($1, $3, $6); }
    | FOR OP_PAR Instlist COLON MixedExpr COLON Instlist CL_PAR OP_BRA Instlist CL_BRA { $$ = nodeChildren($1, nodeChildren($3, $3, $5), nodeChildren($7, $7, $8)); }
    ;

Expr:
  NUM			{ $$ = $1; }
  | Expr PLUS Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr MIN Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr MULT Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr DIV Expr      { $$ = nodeChildren($2, $1, $3); }
  | MIN Expr %prec NEG { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
  | Expr POW Expr      { $$ = nodeChildren($2, $1, $3); }
  | OP_PAR Expr CL_PAR { $$ = $2; }
  | Expr EQUALS Expr { $$ = nodeChildren($2, $1, $3); }
  | Expr NOTEQUALS Expr { $$ = nodeChildren($2, $1, $3); }
  | Expr INF Expr { $$ = nodeChildren($2, $1, $3); }
  | Expr SUP Expr { $$ = nodeChildren($2, $1, $3); }
  | Expr INFEQUALS Expr { $$ = nodeChildren($2, $1, $3); }
  | Expr SUPEQUALS Expr { $$ = nodeChildren($2, $1, $3); }
  ;

VarExpr:
  VAR { $$ = $1; }
    | VarExpr PLUS VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr MIN VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr MULT VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr DIV VarExpr { $$ = nodeChildren($2, $1, $3); }
    | MIN VarExpr %prec NEG { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
    | VarExpr POW VarExpr { $$ = nodeChildren($2, $1, $3); }
    | OP_PAR VarExpr CL_PAR { $$ = $2; }
    | VarExpr EQUALS VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr NOTEQUALS VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr INF VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr SUP VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr INFEQUALS VarExpr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr SUPEQUALS VarExpr { $$ = nodeChildren($2, $1, $3); }
    ;

MixedExpr:
    VarExpr { $$ = $1; }
    | Expr { $$ = $1; }
    | VarExpr PLUS Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr MIN  Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr MULT Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr DIV  Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr EQUALS  Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr NOTEQUALS  Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr INF Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr SUP Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr INFEQUALS Expr { $$ = nodeChildren($2, $1, $3); }
    | VarExpr SUPEQUALS Expr { $$ = nodeChildren($2, $1, $3); }

    | Expr PLUS VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr MIN  VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr MULT VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr DIV  VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr EQUALS  VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr NOTEQUALS  VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr INF VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr SUP VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr INFEQUALS VarExpr { $$ = nodeChildren($2, $1, $3); }
    | Expr SUPEQUALS VarExpr { $$ = nodeChildren($2, $1, $3); }

    | MixedExpr PLUS MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr MIN  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr MULT MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr DIV  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr EQUALS  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr NOTEQUALS  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr INF  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr SUP  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr INFEQUALS  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    | MixedExpr SUPEQUALS  MixedExpr { $$ = nodeChildren($2, $1, $3); }
    ;

%%

int yyerror(char *s) {
  printf("%s\n", s);
} 

int main(int arc, char **argv) {
   if ((arc == 3) && (strcmp(argv[1], "-f") == 0)) {
    
    FILE *fp=fopen(argv[2],"r");
    if(!fp) {
      printf("Impossible d'ouvrir le fichier à executer.\n");
      exit(0);
    }      
    yyin=fp;
    yyparse();
		  
    fclose(fp);
  }  
  exit(0);
}
