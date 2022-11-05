#include <stdio.h>
#include "y.tab.h"

extern int yyparse(void);

int main() {
    #ifdef YYDEBUG
        // yydebug=1;
    #endif
    yyparse();
}