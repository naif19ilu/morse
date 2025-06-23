objs = main.o
name = morse


all: $(name)

$(name): $(objs)
	ld	-o $(name) $(objs)

%.o: %.asm
	as	-o $@ $<

clean:
	rm	-rf $(objs) $(name)