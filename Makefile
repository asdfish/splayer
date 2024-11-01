CC ?= cc
C_FLAGS := -std=gnu11 $\
					 -Wall -Wextra -Wpedantic $\
					 -O2 -march=native -pipe $\
					 -Iinclude -Ideps/miniaudio
LD_FLAGS := -ldl -lpthread -lm

INSTALL_DIRECTORY := /usr/local/bin

OBJECT_FILES := $(patsubst src/%.c,$\
									build/%.o,$\
									$(shell find src -name '*.c'))

all: splayer

build/%.o: src/%.c
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

.PHONY: all clean install uninstall
