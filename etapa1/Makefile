CC=gcc
CFLAGS=-I.
DEPS = tokens.h
OBJ = main.o lex.yy.o utils.o

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

main: $(OBJ)
	$(CC) -o $@.out $^ $(CFLAGS)

clean:
	rm *.o *.out
