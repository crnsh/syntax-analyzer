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

STRINGLITERAL \"([^\\\"]|\\.)*\"
INT "int"
CHAR "char"
ELSE "else"
FOR "for"
IF "if"
RETURN "return"
VOID "void"

ILLEGALZERO [0]+[1-9]*
ILLEGALID [0-9]+[a-zA-Z]+[0-9]*
HEADER [a-zA-Z]+[0-9]*[.][h]
HASH [#]
PUNCTUATOR [;|,|(|)|\[|\]|{|}|+|\-|*|/|<|>|=|\\|\&|\:|?|%]|"<="|">="|"!="|"=="|"#"|"&&"|"||"|"-"
INTEGERS [+|-]?[1-9]+[0-9]*
ZERO [0]
CHARCONSTANT [']([a-zA-Z]|[0-9]|[!@#$%^&*()_+{}|:"<>?`~\[\]\\-])[']
IDENTIFIER [a-zA-Z]+[a-zA-Z0-9|_]*

WS [\t\r]|" "
LINE [\n]
ESCAPE [\\]['|''|?|\\|a|b|f|v]
SEMICOLON [;]

%x MULTILINE_COMMENT_NC    
%x SINGLELINE_COMMENT_NC

%%
"/*"            {BEGIN(MULTILINE_COMMENT_NC); }
<MULTILINE_COMMENT_NC>"*/" {BEGIN(INITIAL); }
<MULTILINE_COMMENT_NC>\n   {}
<MULTILINE_COMMENT_NC>.    {}

"//"            { BEGIN(SINGLELINE_COMMENT_NC); }
<SINGLELINE_COMMENT_NC>\n    {BEGIN(INITIAL); }
<SINGLELINE_COMMENT_NC>. {}

{LINE}      { line_num++ ;}
{ZERO}      {return (CONSTANT);}

{HEADER}   {printf("<KEYWORD, \"%s\">", yytext);}
{ILLEGALZERO} {printf(" lexical error in Line : %d \n ", line_num); exit(1); }
{ILLEGALID} {printf(" lexical error in Line : %d \n ", line_num); exit(1); }
"||" {return (LOGICAL_OR);}
"&&" {return (LOGICAL_AND);}
"!=" {return (NOT_EQUALITY);}
"==" {return (EQUALITY);}
"<=" {return (LESS_THAN_EQUAL);}
">=" {return (GREATER_THAN_EQUAL);}
"->" {return (ARRW_PNTR);}
{INT} {return (KEYWD_INT);}      
{CHAR} {return (KEYWD_CHAR);}
{ELSE} {return (KEYWD_ELSE);}
{FOR} {return (KEYWD_FOR);}
{IF} {return (KEYWD_IF);}
{RETURN} {return (KEYWD_RETURN);}
{VOID} {return (KEYWD_VOID);}

{HASH} {return *yytext;}
{PUNCTUATOR} {return *yytext;}
{STRINGLITERAL} {return (STRINGLITERAL);}
{IDENTIFIER} {return (IDENTIFIER);}
{CHARCONSTANT} {return *yytext;}
{INTEGERS} {return (INTEGER_CONSTANT);}

{SEMICOLON} {return *yytext;}
{WS}+    {}
.       { printf(" lexical error in Line : %d \n ", line_num); exit(1); }
%%