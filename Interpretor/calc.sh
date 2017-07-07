rm minipseudtree.o
rm minipseudeval.o
rm minipseud.lex.c
rm minipseud
rm minipseud.lex.o
rm minipseud.h
rm minipseud.y.c
rm minipseud.y.o

bison -d minipseud.y
mv minipseud.tab.h minipseud.h
mv  minipseud.tab.c minipseud.y.c
flex minipseud.l
mv  lex.yy.c minipseud.lex.c
gcc -c minipseudtree.c -o minipseudtree.o
gcc -c minipseudeval.c -o minipseudeval.o
gcc -c minipseud.lex.c -o minipseud.lex.o
gcc -c minipseud.y.c -o minipseud.y.o
gcc -c Values.c -o Values.o
gcc -o minipseud minipseud.lex.o minipseud.y.o minipseudtree.o minipseudeval.o Values.o -lm


#minipseud -f in.txt
