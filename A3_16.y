%{
#include <string.h>
#include <iostream>
extern int yylex();
void yyerror(char *s);
%}

%token KEYWD_VOID
%token KEYWD_CHAR
%token KEYWD_INT
%token KEYWD_IF
%token KEYWD_ELSE
%token KEYWD_FOR
%token KEYWD_RETURN

%token INTEGER_CONSTANT
%token CONSTANT
%token STRINGLITERAL
%token IDENTIFIER

%token ARRW_PNTR
%token LESS_THAN_EQUAL
%token GREATER_THAN_EQUAL
%token EQUALITY
%token NOT_EQUALITY
%token LOGICAL_AND
%token LOGICAL_OR

%%
primary_expression: IDENTIFIER
                  | constant // defined at last
                  | STRINGLITERAL
                  | '(' expression ')'
                  ;
postfix_expression:  primary_expression
                  |  postfix_expression '[' expression ']' // 1_D array access
                  |  postfix_expression '(' argument_expression_list_opt ')' // Function invocation
                  |  postfix_expression ARRW_PNTR IDENTIFIER // Pointer indirection. Only one level
                  ;                                              // Only a single postfix op is allowed in an expression here
argument_expression_list_opt: argument_expression_list
                            | 
                            ;
argument_expression_list: assignment_expression
                  |  argument_expression_list ',' assignment_expression
                  ;
unary_expression: postfix_expression
                |  unary_operator unary_expression // Expr. with prefix ops. Right assoc. in C; non_assoc. here
                ;                                    // Only a single prefix op is allowed in an expression here
unary_operator: '&'
              | '*'
              | '+'
              | '-'
              | '!'
              ;
multiplicative_expression: unary_expression
                         | multiplicative_expression '*' unary_expression
                         | multiplicative_expression '/' unary_expression
                         | multiplicative_expression '%' unary_expression
                        ;
additive_expression: multiplicative_expression
                   | additive_expression '+' multiplicative_expression
                   | additive_expression '-' multiplicative_expression
                   ;
relational_expression: additive_expression
                     | relational_expression '<' additive_expression
                     | relational_expression '>' additive_expression
                     | relational_expression LESS_THAN_EQUAL additive_expression
                     | relational_expression GREATER_THAN_EQUAL additive_expression
                     ;
equality_expression: relational_expression
                   | equality_expression EQUALITY relational_expression
                   | equality_expression NOT_EQUALITY relational_expression
                   ;
logical_AND_expression: equality_expression
                      | logical_AND_expression LOGICAL_AND equality_expression
                      ;
logical_OR_expression: logical_AND_expression
                     | logical_OR_expression LOGICAL_OR logical_AND_expression
                     ;
conditional_expression: logical_OR_expression
                      | logical_OR_expression '?' expression ':' conditional_expression
                      ;
assignment_expression: conditional_expression
                     | unary_expression '=' assignment_expression // unary_expression must have lvalue
                     ;
expression: assignment_expression
          ;
declaration: type_specifier init_declarator 
           ; // Only one element in a declaration
init_declarator: declarator // Simple identifier',' 1-D array or function declaration
               | declarator '=' initializer // Simple id with init. initializer for array / fn/ is semantically skipped
               ;
type_specifier: // Built-in types
              | KEYWD_VOID
              | KEYWD_CHAR
              | KEYWD_INT
              ;
declarator: pointer_opt direct_declarator // Optional injection of pointer
          ;
direct_declarator:
                 | IDENTIFIER // Simple identifier
                 | IDENTIFIER '[' INTEGER_CONSTANT ']' // 1-D array of a built-in type or ptr to it. Only +ve constant
                 | IDENTIFIER '(' parameter_list ')' // Fn. header with params of built-in type or ptr to them
                 ;
pointer_opt: pointer
           | 
           ;
pointer: '*'
       ;
parameter_list: parameter_declaration
              | parameter_list ',' parameter_declaration
              ;
parameter_declaration: type_specifier pointer_opt identifier_opt
identifier_opt: IDENTIFIER
              | 
              ;
initializer: assignment_expression
statement: compound_statement // Multiple statements and / or nest block/s
         | expression_statement // Any expression or null statements
         | selection_statement // if or if_else
         | iteration_statement // for
         | jump_statement // return
         ;
compound_statement: '{' block_item_list_opt '}'
block_item_list_opt: block_item_list
                   | 
                   ;
block_item_list: block_item
               | block_item_list block_item
               ;
block_item: declaration // Block scope _ declarations followed by statements
          | statement
          ;
expression_statement: expression_opt ';'
                    ;
expression_opt: expression
              | 
              ;
selection_statement: KEYWD_IF '(' expression ')' statement
                   | KEYWD_IF '(' expression ')' statement KEYWD_ELSE statement
                   ;
iteration_statement: KEYWD_FOR '(' expression_opt ';' expression_opt ';' expression_opt ')' statement
                   ;
jump_statement: KEYWD_RETURN expression_opt ';'
              ;
translation_unit: function_definition // Single source file containing main'('')'
                | declaration
                ;
function_definition: type_specifier declarator '(' declaration_list_opt ')' compound_statement
                   ;
declaration_list_opt: declaration_list
                    | 
                    ;
declaration_list: declaration
                | declaration_list declaration 
                ;
constant: INTEGER_CONSTANT
        | CONSTANT
        ;

%%

void yyerror(char *s) {
    std::cout << s << std::endl;
}
int main() {
    yyparse();
}