objs = main.o morse.o text.o data.o buffer.o
name = morse

all: $(name)

$(name): $(objs)
	ld	-o $(name) $(objs)

%.o: %.asm
	as	-o $@ $<

clean:
	rm	-rf $(objs) $(name)
