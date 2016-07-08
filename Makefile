NAME = main
DEPS = $(wildcard *.tex)
DEPS += build-images-stamp

PICSDIR = images
PDFDIR = pdf

YEAR := $(shell basename `dirname $(CURDIR)`)
TALK := $(notdir $(CURDIR))

all: pdf notes.config
pdf: $(NAME).pdf notes-stamp
dvi: $(NAME).dvi
$(NAME).pdf $(NAME).dvi: $(DEPS)

show: showpdf
showpdf: $(NAME).pdf
	xdg-open $<
showdvi: $(NAME).dvi
	xdvi $<

install: $(PDFDIR)/$(YEAR)/$(TALK).pdf
$(PDFDIR)/$(YEAR)/$(TALK).pdf: $(NAME).pdf
	cd $(PDFDIR) && test -z "`git status --porcelain`"
	mkdir -p $(PDFDIR)/$(YEAR)/
	cp -u $(NAME).pdf $(PDFDIR)/$(YEAR)/$(TALK).pdf
	cd $(PDFDIR) && git add $(YEAR)/$(TALK).pdf && git commit -m 'check in pdf for $(TALK)'
	cd $(PDFDIR)/.. && git add pdf && git commit -m 'sync pdf submodule'

notes-stamp: $(DEPS)
	bin/extract-notes $(NAME).tex
	touch $@

build-images-stamp: $(wildcard $(PICSDIR)/*)
	$(MAKE) -C $(PICSDIR)/
	touch $@
clean::
	-rm -f *.vrb
	-rm -f build-images-stamp notes-stamp

export TEXINPUTS=../../common:

# credits for beamer notes configuration: Benjamin Mako Hill
# origin: http://projects.mako.cc/source/?p=beamer-mako;a=blob;f=template/Makefile;hb=HEAD

# by default, we produce combined notes/slides output
notes.config dual-config:
	echo '\setbeameroption{show notes on second screen}' > notes.config
dual: dual-config pdf

# rules for generating notesonly
notes-config:
	echo '\setbeameroption{show only notes}' > notes.config
notes: notes-config pdf

# rules for generating slides only
slides-config:
	echo '' > notes.config
slides: slides-config pdf


# Debian package: latex-make
include /usr/include/LaTeX.mk
