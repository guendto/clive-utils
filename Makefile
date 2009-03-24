# GNU Makefile

SHELL = /bin/sh

prefix      = $(HOME)
bindir      = $(prefix)/bin
datarootdir = $(prefix)/share
datadir     = $(datarootdir)
mandir      = $(datarootdir)/man
man1dir     = $(mandir)/man1

INSTALL     = install -c
INSTALL_D   = install -d
INSTALL_M   = install -c -m 444
RM          = rm -f
PERL        = perl
POD2MAN     = pod2man
AWK         = awk
TR          = tr

WITH_MAN    = yes
WITH_CHECK  = yes

RELEASE_scan := \
    $(shell sh -c "$(AWK) '/constant VERSION/ {print \$$5}' clivescan | \
        $(TR) -d '[\";]'")

RELEASE_feed := \
    $(shell sh -c "$(AWK) '/constant VERSION/ {print \$$5}' clivefeed | \
        $(TR) -d '[\";]'")

RELEASE_pass := \
    $(shell sh -c "$(AWK) '/constant VERSION/ {print \$$5}' clivepass | \
        $(TR) -d '[\";]'")

.PHONY: all checks
all: checks

MODULES = \
 Config::Tiny  WWW::Curl  Tk  Tk::Tree  Tk::DialogBox  HTML::TokeParser \
 XML::RSS::LibXML  URI::Escape  HTML::Strip  Crypt::PasswdMD5  Crypt::Twofish

checks:
ifeq ($(WITH_CHECK),yes)
	@for m in $(MODULES); \
	do \
		echo -n "Check for $$m ..."; \
        result=`$(PERL) -M$$m -e "print 'yes'" 2>/dev/null || echo no`;\
		echo "$$result";\
	done
else
	@echo Disable module checking.
endif

.PHONY: install uninstall
install:
	$(INSTALL_D) $(DESTDIR)$(bindir)
	$(INSTALL) clivescan $(DESTDIR)$(bindir)/clivescan
	$(INSTALL) clivefeed $(DESTDIR)$(bindir)/clivefeed
	$(INSTALL) clivepass $(DESTDIR)$(bindir)/clivepass
ifeq ($(WITH_MAN),yes)
	$(INSTALL_D) $(DESTDIR)$(man1dir)
	$(INSTALL_M) clivescan.1 $(DESTDIR)$(man1dir)/clivescan.1
	$(INSTALL_M) clivefeed.1 $(DESTDIR)$(man1dir)/clivefeed.1
	$(INSTALL_M) clivepass.1 $(DESTDIR)$(man1dir)/clivepass.1
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
		-s 1 -r $(RELEASE_scan) clivescan.pod clivescan.1
	$(POD2MAN) -c "clivefeed manual" -n clivefeed \
		-s 1 -r $(RELEASE_feed) clivefeed.pod clivefeed.1
	$(POD2MAN) -c "clivepass manual" -n clivepass \
		-s 1 -r $(RELEASE_pass) clivepass.pod clivepass.1
