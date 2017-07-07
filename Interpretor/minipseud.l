%option noyywrap
%{

#include "minipseud.h"
#include <stdlib.h>
#include "minipseudtree.h"

%}

empty    [ \t]+

num     [0-9]
int     {num}+
exp     [eE][+-]?{int}
var     [_a-zA-Z]+[_a-zA-Z0-9]*
real    {int}("."{int})?{exp}?

%%

{empty}  { /* Nothing */ }

"("   return(OP_PAR);
")"   return(CL_PAR);

"{"     return(OP_BRA);
"}"     return(CL_BRA);

show    { yylval.node = createNode(NTSHOW); return(SHOW); }
if      { yylval.node = createNode(NTIF); return(IF); }
else    { yylval.node = createNode(NTELSE); return(ELSE); }
floop   { yylval.node = createNode(NTFLOOP); return(FLOOP); }
repeat   { yylval.node = createNode(NTREPEAT); return(REPEAT); }
repeatStatic   { yylval.node = createNode(NTREPEATSTATIC); return(REPEATSTATIC); }

{var}    { yylval.node = createNode(NTVAR); yylval.node->var = (char*)strdup(yytext); return(VAR); }
	
{real}    { yylval.node = createNode(NTNUM); yylval.node->val = atof(yytext); return(NUM); }

"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN);  return(MIN);  }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV);  return(DIV);  }
"^"   { yylval.node = createNode(NTPOW);  return(POW);  }
"="   { yylval.node = createNode(NTAFF);  return(AFF);  }

"=="  { yylval.node = createNode(NT_EQUALS);    return(EQUALS);    }
"!="  { yylval.node = createNode(NT_NOTEQUALS); return(NOTEQUALS); }

"<"  { yylval.node = createNode(NT_INF); return(INF); }
">"  { yylval.node = createNode(NT_SUP); return(SUP); }

"<="  { yylval.node = createNode(NT_INFEQUALS); return(INFEQUALS); }
">="  { yylval.node = createNode(NT_SUPEQUALS); return(SUPEQUALS); }

";"    { return(COLON); }

"\n"   { return(EOL); }
