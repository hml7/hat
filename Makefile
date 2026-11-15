PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man

all: hat hat.1

hat: main.ha
	hare build -o $@ main.ha

hat.1: hat.1.scd
	scdoc < hat.1.scd > $@

install: all
	install -Dm755 hat $(DESTDIR)$(BINDIR)/hat
	install -Dm644 hat.1 $(DESTDIR)$(MANDIR)/man1/hat.1

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/hat
	rm -f $(DESTDIR)$(MANDIR)/man1/hat.1

clean:
	rm -f hat hat.1

.PHONY: all install uninstall clean
