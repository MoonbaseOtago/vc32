all:	vcasm 

vcasm:	main.c vc.tab.c
	gcc -o vcasm main.c -g

vc.tab.c: vc.y
	bison vc.y -k

test:	vcasm test.s
	./vcasm -s -m -o ../test/init.v test.s
	

