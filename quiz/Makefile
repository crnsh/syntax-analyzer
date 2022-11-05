A3_16:
	flex --debug A3_16.l
	yacc -dtv A3_16.y
	g++ -c lex.yy.c
	g++ -c y.tab.c
	g++ -c A3_16.c
	g++ lex.yy.o y.tab.o A3_16.o -lfl