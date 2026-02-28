# simple Makefile for building init.c and installing oinit

# allow overriding via environment
CC ?= gcc
CFLAGS ?= -O3 -Ofast -march=native -funroll-loops -fomit-frame-pointer -ffast-math -fno-common -pipe -Wall -Wextra -flto
LDFLAGS ?= -flto -Wl,--as-needed

# fallback to cc if chosen compiler is missing
ifeq (, $(shell command -v $(CC) 2>/dev/null))
CC := cc
endif

# default target
all: oinit

# build rule
oinit: init.c
	@echo "Compiling with $(CC) $(CFLAGS)"
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) -s

# installation (may require root)
install: oinit
	@if [ -w /sbin ] || [ "$$$(id -u)" -eq 0 ]; then \
		mv -f oinit /sbin/oinit; \
	else \
		echo "Installing to /sbin requires root privileges."; \
		doas mv -f oinit /sbin/oinit; \
	fi

clean:
	rm -f oinit

.PHONY: all install clean
