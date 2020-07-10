all:	y.tab.c lex.yy.c 
	gcc lex.yy.c y.tab.c -ly -lfl

y.tab.c:
	bison -y -d B063040061.y

lex.yy.c:	
	flex B063040061.l

clean:
	rm a.out lex.yy.c y.tab.c y.tab.h
	clear
