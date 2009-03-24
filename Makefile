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

.PHONY: all checks
all: checks

MODULES = \
 Config::Tiny  WWW::Curl  Tk  Tk::Tree  Tk::DialogBox  HTML::TokeParser \
 XML::RSS::LibXML  URI::Escape  HTML::Strip  Crypt::PasswdMD5  Crypt::Twofish \

MODULES_OPTIONAL = \
 Clipboard  Tk::FontDialog

checks:
ifeq ($(WITH_CHECK),yes)
	@echo == Required Perl modules:
	@for m in $(MODULES); \
	do \
        result=`$(PERL) -M$$m -e "print 'yes'" 2>/dev/null || echo no`;\
		echo "$$m ...$$result"; \
	done
	@echo == Optional Perl modules:
	@for m in $(MODULES_OPTIONAL); \
	do \
        result=`$(PERL) -M$$m -e "print 'yes'" 2>/dev/null || echo no`;\
		echo "$$m ...$$result"; \
	done
else
	@echo Disable module checking.
endif

.PHONY: install uninstall

SCRIPTS = clivefeed clivescan clivepass

install:
	# TODO: Merge these two loops
	$(INSTALL_D) $(DESTDIR)$(bindir)
	@for s in $(SCRIPTS); \
	do \
		echo "$(INSTALL) $$s $(DESTDIR)$(bindir)/$$s"; \
		$(INSTALL) $$s $(DESTDIR)$(bindir)/$$s; \
	done
ifeq ($(WITH_MAN),yes)
	$(INSTALL_D) $(DESTDIR)$(man1dir)
	@for s in $(SCRIPTS); \
	do \
		echo "$(INSTALL_M) $$s.1 $(DESTDIR)$(man1dir)/$$s.1"; \
		$(INSTALL_M) $$s.1 $(DESTDIR)$(man1dir)/$$s.1; \
	done
endif

uninstall:
	# TODO: Merge these two loops
	@for s in $(SCRIPTS); \
	do \
		echo "$(RM) $(DESTDIR)$(bindir)/$$s"; \
		$(RM) $(DESTDIR)$(bindir)/$$s; \
	done
ifeq ($(WITH_MAN),yes)
	@for s in $(SCRIPTS); \
	do \
		echo "$(RM) $(DESTDIR)$(man1dir)/$$s.1"; \
		$(RM) $(DESTDIR)$(man1dir)/$$s.1; \
	done
endif

.PHONY: man
man:
	@for s in $(SCRIPTS); \
	do \
		release=`$(AWK) '/constant VERSION/ {print \$$5}' $$s | \
			$(TR) -d '["\;]'`; \
		echo $(POD2MAN) -c "$$s manual" -n $$s \
			-s 1 -r $$release $$s.pod $$s.1; \
		$(POD2MAN) -c "$$s manual" -n $$s \
			-s 1 -r $$release $$s.pod $$s.1; \
	done
