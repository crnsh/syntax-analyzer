A3_16:
	flex --debug A3_16.l
	yacc -dtv --debug A3_16.y
	g++ -c lex.yy.c
	g++ -c y.tab.c
	g++ lex.yy.o y.tab.o -lfl