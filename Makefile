CC ?= cc
C_FLAGS := -std=gnu11 $\
					 -Wall -Wextra -Wpedantic $\
					 -O2 -march=native -pipe $\
					 -Iinclude -Ideps/miniaudio
LD_FLAGS := -ldl -lpthread -lm

INSTALL_DIRECTORY := /usr/local/bin

PROCESSED_HEADER_FILES := $(subst .h,$\
														$(if $(findstring clang,${CC}),$\
															.h.pch,$\
															.h.gch),$\
														$(shell find -name '*.h' -not -path './deps/*'))
OBJECT_FILES := $(patsubst src/%.c,$\
									build/%.o,$\
									$(shell find src -name '*.c'))

define REMOVE_LIST
	$(foreach ITEM,$\
		$(1),$\
		$(if $(wildcard ${ITEM}),$\
			$(shell rm ${ITEM})))

endef

all: splayer

%.gch: %
	${CC} -c $< ${C_FLAGS}

%.pch: %
	${CC} -c $< ${C_FLAGS}

build/%.o: src/%.c
	${CC} -c $< ${C_FLAGS} -o $@

splayer: ${PROCESSED_HEADER_FILES} ${OBJECT_FILES}
	${CC} ${OBJECT_FILES} ${LD_FLAGS} -o splayer

install: splayer ${INSTALL_DIRECTORY} uninstall
	cp splayer ${INSTALL_DIRECTORY}

uninstall:
ifneq (,$(wildcard ${INSTALL_DIRECTORY}/splayer))
	rm ${INSTALL_DIRECTORY}/splayer
endif

clean:
	$(call REMOVE_LIST,$\
		${PROCESSED_HEADER_FILES})
	$(call REMOVE_LIST,$\
		${OBJECT_FILES})
ifneq (,$(wilcard splayer))
	rm splayer
endif

.PHONY: all clean install uninstall
