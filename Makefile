CC ?= gcc

STANDARD := -std=gnu11

LINK_FLAGS :=  -ldl -lm -lpthread
INCLUDE_FLAGS :=  -Ideps/miniaudio/extras/miniaudio_split -Iinclude

SOURCE_FILES := src/main.c src/directory_utils.c src/stdin_utils.c
HEADER_FILES   := config.h include/directory_utils.h include/stdin_utils.h

DEBUG_FLAGS := -Wall -Wextra -Wpedantic
OPTIMIZATION_FLAGS := -O2 -march=native

INSTALL_DIRECTORY := /usr/local/bin

OBJECT_FILES := build/miniaudio.c.o build/directory_utils.c.o build/stdin_utils.c.o build/main.c.o

define COMPILE_FILE
	${CC} -c ${STANDARD} $(1) ${INCLUDE_FLAGS} ${DEBUG_FLAGS} ${OPTIMIZATION_FLAGS} -o build/$(notdir $(1)).o 

endef

all: splayer

build:
	mkdir build

build/directory_utils.c.o: include/directory_utils.h src/directory_utils.c
	$(call COMPILE_FILE,src/directory_utils.c)

build/main.c.o: config.h include/directory_utils.h include/stdin_utils.h src/main.c
	$(call COMPILE_FILE,src/main.c)

build/miniaudio.c.o: deps/miniaudio deps/miniaudio/extras/miniaudio_split/miniaudio.c
	$(call COMPILE_FILE,deps/miniaudio/extras/miniaudio_split/miniaudio.c)

build/stdin_utils.c.o: include/stdin_utils.h src/stdin_utils.c
	$(call COMPILE_FILE,src/stdin_utils.c)

deps:
	mkdir deps

deps/miniaudio: deps
	git -C deps clone https://github.com/mackron/miniaudio --depth=1

splayer: build ${OBJECT_FILES}
	cc ${OBJECT_FILES} ${LINK_FLAGS} -o splayer

install: splayer ${INSTALL_DIRECTORY}
	cp -f splayer ${INSTALL_DIRECTORY}

uninstall:
ifneq (, $(wildcard ${INSTALL_DIRECTORY}/splayer))
	rm -f ${INSTALL_DIRECTORY}/splayer
endif

clean:
ifneq (, $(wildcard splayer))
	rm -f splayer
endif
ifneq (, $(wildcard build))
	rm -rf build
endif
ifneq (, $(wildcard deps))
	rm -rf deps
endif
