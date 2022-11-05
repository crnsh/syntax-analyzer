%{
#include "y.tab.h"
#include <stdio.h>  
void yyerror (const char * msg) {
    fprintf(stderr, "C-like : %s\n", msg);
    exit(1);
}
int line_num = 1;  
%}
%option noyywrap

/* Regular expression definitions*/
%%
[1-9]+[0-9]* {
    yylval.intval = atoi(yytext); // yylval denotes the attribute
                                  // of the current symbol
    return(NUMBER);
}
"sgn " {
    return(SGN);
}
[ \t] ; /* ignore white space */
"$" {
    return 0; /* end of input */
}

\n|. return yytext[0];
%%

