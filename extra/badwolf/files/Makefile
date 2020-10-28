# POSIX-ish Makefile with extensions common to *BSD and GNU such as:
# - Usage of backticks for shell evaluation
# - Usage of ?= for defining variables when not already defined
# - Usage of += for appending to a variable

PACKAGE = Badwolf
VERSION = 1.0.3
VERSION_FULL = $(VERSION)`./version.sh`

PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man
DOCDIR  ?= $(PREFIX)/share/doc/badwolf-$(VERSION)
DATADIR ?= $(PREFIX)/share/badwolf
APPSDIR ?= $(PREFIX)/share/applications

CC        ?= cc
CFLAGS    ?= -g -Wall -Wextra -Wconversion -Wsign-conversion -O2
DBG       ?=
PKGCONFIG ?= pkg-config
MSGFMT    ?= msgfmt
INKSCAPE  ?= inkscape

# for i in 24 32 48 64 128 256; do echo icons/hicolor/${i}x${i}/apps/badwolf.png; done | tr '\n' ' '
ICON_SIZES = icons/hicolor/24x24/apps/badwolf.png icons/hicolor/32x32/apps/badwolf.png icons/hicolor/48x48/apps/badwolf.png icons/hicolor/64x64/apps/badwolf.png icons/hicolor/128x128/apps/badwolf.png icons/hicolor/256x256/apps/badwolf.png

DEPS  = gtk+-3.0 webkit2gtk-4.0 libsoup-2.4
SRCS  = uri.c uri_test.c keybindings.c downloads.c badwolf.c
OBJS  = uri.o keybindings.o downloads.o badwolf.o
OBJS_test = uri_test.o
EXE   = badwolf
EXE_test = uri_test
TRANS = 
DOCS  = usr.bin.badwolf README.md KnowledgeBase.md interface.txt

CDEPS = -DDATADIR=\"$(DATADIR)\" -DPACKAGE=\"$(PACKAGE)\" -D_XOPEN_SOURCE=500 -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION_FULL)\"
CDEPS += `$(PKGCONFIG) --cflags $(DEPS)`
LIBS   = `$(PKGCONFIG) --libs $(DEPS)`

all: $(EXE) $(TRANS)

icons: $(ICON_SIZES)

icons/hicolor/scalable/apps/badwolf.svg: badwolf.svg
	mkdir -p icons/hicolor/scalable/apps
	scour --no-line-breaks --enable-id-stripping --remove-metadata $< $@

icons/hicolor/%/apps/badwolf.png: icons/hicolor/scalable/apps/badwolf.svg
	mkdir -p `dirname $@`
	$(INKSCAPE) `echo $@ | cut -d/ -f3 | ./icons_size.sh` $< -o $@

badwolf: $(OBJS)
	$(CC) -std=c11 -o $@ $(OBJS) $(LDFLAGS) $(LIBS)

.c:
	$(CC) -std=c11 $(CFLAGS) $(CDEPS) $(LDFLAGS) $(LIBS) -o $@ $<

.c.o:
	$(CC) -std=c11 $(CFLAGS) $(CDEPS) -c -o $@ $<

uri_test: uri.o uri_test.o
	$(CC) -std=c11 -o $@ uri.o uri_test.o $(LDFLAGS) $(LIBS)
	$(DBG) ./$@

.PHONY: test
test: $(EXE_test)

.PHONY: install
install: all
	mkdir -p $(DESTDIR)$(BINDIR)
	cp -p badwolf $(DESTDIR)$(BINDIR)/
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	cp -p badwolf.1 $(DESTDIR)$(MANDIR)/man1/
	cp interface.css $(DESTDIR)$(DATADIR)/
	mkdir -p $(DESTDIR)$(APPSDIR)
	cp -p badwolf.desktop $(DESTDIR)$(APPSDIR)/
	mkdir -p $(DESTDIR)$(DOCDIR)
	cp -p $(DOCS) $(DESTDIR)$(DOCDIR)/
	mkdir -p $(DESTDIR)$(PREFIX)/share
	cp -r icons $(DESTDIR)$(PREFIX)/share/
	@printf '\nNote: An example AppArmor profile has been installed at '$(DOCDIR)/usr.bin.badwolf'\n'

.PHONY: clean
clean:
	rm -fr $(OBJS) $(OBJS_test) $(EXE) $(EXE_test)

format: *.c *.h
	clang-format -style=file -assume-filename=.clang-format -i *.c *.h
