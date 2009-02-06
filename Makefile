# GNU Makefile

SHELL = /bin/sh

prefix      = $(HOME)
bindir      = $(prefix)/bin
datarootdir = $(prefix)/share
datadir     = $(datarootdir)
mandir      = $(datarootdir)/man
man1dir     = $(mandir)/man1

INSTALL     = install
RM          = rm -f
PERL        = perl
POD2MAN     = pod2man
AWK         = awk
TR          = tr

WITH_MAN    = yes

RELEASE_scan := \
    $(shell sh -c "$(AWK) '/constant VERSION/ {print \$$5}' clivescan | \
        $(TR) -d '[\";]'")

RELEASE_feed := \
    $(shell sh -c "$(AWK) '/constant VERSION/ {print \$$5}' clivefeed | \
        $(TR) -d '[\";]'")

RELEASE_pass := \
    $(shell sh -c "$(AWK) '/constant VERSION/ {print \$$5}' clivepass | \
        $(TR) -d '[\";]'")

.PHONY: all
all: man

.PHONY: install uninstall
install:
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -c clivescan $(DESTDIR)$(bindir)/clivescan
	$(INSTALL) -c clivefeed $(DESTDIR)$(bindir)/clivefeed
	$(INSTALL) -c clivepass $(DESTDIR)$(bindir)/clivepass
ifeq ($(WITH_MAN),yes)
	$(INSTALL) -d $(DESTDIR)$(man1dir)
	$(INSTALL) -c -m 444 clivescan.1 $(DESTDIR)$(man1dir)/clivescan.1
	$(INSTALL) -c -m 444 clivefeed.1 $(DESTDIR)$(man1dir)/clivefeed.1
	$(INSTALL) -c -m 444 clivepass.1 $(DESTDIR)$(man1dir)/clivepass.1
endif

uninstall:
	$(RM) $(DESTDIR)$(bindir)/clivescan
	$(RM) $(DESTDIR)$(bindir)/clivefeed
	$(RM) $(DESTDIR)$(bindir)/clivepass
ifeq ($(WITH_MAN),yes)
	$(RM) $(DESTDIR)$(man1dir)/clivescan.1
	$(RM) $(DESTDIR)$(man1dir)/clivefeed.1
	$(RM) $(DESTDIR)$(man1dir)/clivepass.1
endif

.PHONY: man clean
man:
	$(POD2MAN) -c "clivescan manual" -n clivescan \
		-s 1 -r $(RELEASE_scan) clivescan clivescan.1
	$(POD2MAN) -c "clivefeed manual" -n clivefeed \
		-s 1 -r $(RELEASE_feed) clivefeed clivefeed.1
	$(POD2MAN) -c "clivepass manual" -n clivepass \
		-s 1 -r $(RELEASE_pass) clivescan clivepass.1

clean:
	@$(RM) clivescan.1 clivefeed.1 clivepass.1 2>/dev/null
