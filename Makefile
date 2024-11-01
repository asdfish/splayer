CC ?= cc
C_FLAGS := -std=gnu11 $\
					 -Wall -Wextra -Wpedantic $\
					 -O2 -march=native -pipe $\
					 -Iinclude -Ideps/miniaudio
LD_FLAGS := -ldl -lpthread -lm

INSTALL_DIRECTORY := /usr/local/bin

OBJECT_FILES := build/miniaudio.o build/directory_utils.o build/stdin_utils.o build/main.o

all: splayer

${OBJECT_FILES}: build/%.o :src/%.c
	${CC} -c $< ${C_FLAGS} -o $@

splayer: ${OBJECT_FILES}
	${CC} ${OBJECT_FILES} ${LD_FLAGS} -o splayer
	strip splayer

install: splayer ${INSTALL_DIRECTORY}
	-cp -f splayer ${INSTALL_DIRECTORY}

uninstall:
	-rm -f ${INSTALL_DIRECTORY}/splayer

clean:
	-rm -f splayer
	-rm -rf build
	-rm -rf deps

.PHONY: all clean install uninstall
