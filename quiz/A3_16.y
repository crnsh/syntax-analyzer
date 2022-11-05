%{
#include <string.h>
#include <iostream>
extern int yylex();
void yyerror(char *s);
%}
%union { // Placeholder for a value
    int intval;
}
%token <intval> NUMBER

%left '+' '-'
%left '*' '/'
%right '^'
%right UMINUS UPLUS SGN
%left '!'

%type <intval> expression
%%
statement: expression { printf("= %d\n", $1); }
         ;
expression: expression '+' expression { $$ = $1 + $3; }
          | expression '-' expression { $$ = $1 - $3; }
          | expression '*' expression { $$ = $1 * $3; }
          | expression '/' expression { $$ = $1 / $3; }
          | expression '^' expression { $$ = power($1, $3); }
          | '-' expression %prec UMINUS { $$ = $2 * (-1); }
          | '+' expression %prec UPLUS { $$ = $2; }
          | SGN expression { $$ = $2 * (-1); }
          | expression '!' { $$ = factorial($1); }
          | '(' expression ')' { $$ = $2; } // have to resolve bracket issue
          | NUMBER { $$ = $1; }
          ;
%%
void yyerror(char *s) {
    std::cout << s << std::endl;
}

