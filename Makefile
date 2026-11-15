PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)

all: hat hat.1

.version: FORCE
	@echo '$(VERSION)' | cmp -s - $@ || echo '$(VERSION)' > $@

hat: main.ha .version
	hare build -D VERSION:str='"$(VERSION)"' -o $@ main.ha

hat.1: hat.1.scd .version
	sed 's/@VERSION@/$(VERSION)/g' hat.1.scd | scdoc > $@

install: all
	install -Dm755 hat $(DESTDIR)$(BINDIR)/hat
	install -Dm644 hat.1 $(DESTDIR)$(MANDIR)/man1/hat.1

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/hat
	rm -f $(DESTDIR)$(MANDIR)/man1/hat.1

clean:
	rm -f hat hat.1 .version

FORCE:

.PHONY: all install uninstall clean FORCE
