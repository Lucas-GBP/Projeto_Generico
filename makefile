CC = gcc
CC_FLAGS = 	-lm		\
			-O2
OUT_FILES = $(addsuffix .o,$(addprefix out/, main $(notdir $(basename $(wildcard libs/*.c)))))

executable.exe: $(OUT_FILES)
	$(CC) $(OUT_FILES) -o executable.exe $(CC_FLAGS)

out/main.o: main.c main.h
	$(CC) -o out/main.o main.c -c $(CC_FLAGS)

out/%.o: libs/%.c libs/%.h
	$(CC) -o $@ $< -c $(CC_FLAGS)

run: executable.exe
	./executable.exe

clean:
	rm out/*.o executable.exe

