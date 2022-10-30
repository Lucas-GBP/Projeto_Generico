##
## Variables
##
CC = gcc
SRC_DIR := src
BUILD_DIR := build
WARNINGS =-Wall -Wextra -Wshadow -Wconversion
ifeq ($(CC), clang)
  WARNINGS := $(WARNINGS) -Wpedantic -Wno-unused-command-line-argument
endif
C_FLAGS = -O2 $(WARNINGS)

##
## OS Variables
##
ifeq '$(findstring ;,$(PATH))' ';'
  OS := Windows_OS
else
  OS := $(shell uname 2>/dev/null || echo Unknown)
  OS := $(patsubst CYGWIN%,Cygwin,$(OS))
  OS := $(patsubst MSYS%,MSYS,$(OS))
  OS := $(patsubst MINGW%,MINGW,$(OS))
endif

##
## Commands and Files
##
ifeq ($(OS), Windows_OS)
  DIR = $(shell chdir)
  TARGET = bin\executable.exe
  RM_COMMAND = del /q /f
  MAKE_DIR = mkdir
  #SRC_FILES := $(shell dir "$(DIR)\*.c" /s /b)
  SRC_FILES := $(shell (for /f "delims=" %f in ('dir /b /s /c *.c') do @echo "%f") > x.x)
else
  DIR = $(shell pwd)
  TARGET = bin/executable.out
  RM_COMMAND = rm -f
  MAKE_DIR = mkdir -p
  SRC_FILES = $(shell find $(SRC_DIR) -type f -name \*.c)
  O_FILES = $(patsubst $(SRC_DIR)/%,$(BUILD_DIR)/%,$(SRC_FILES:.c=.o))
endif

##
## Targets
##
$(TARGET): $(O_FILES)
	@$(MAKE_DIR) $(dir $@)
	$(CC) $^ -o $(TARGET) $(C_FLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@$(MAKE_DIR) $(dir $@)
	$(CC) $(C_FLAGS) -c -o $@ $<

test:
	@echo $(OS)
	@echo $(TARGET)
	@echo $(DIR)
	@echo $(SRC_FILES)

build: $(TARGET)

run:
	@./$(TARGET)

clean:
	$(RM_COMMAND) $(O_FILES) $(TARGET)
	clear

.PHONY: clean build run
