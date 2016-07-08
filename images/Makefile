DIAPICS = $(basename $(wildcard *.dia))
DOTPICS = $(basename $(wildcard *.dot))
SVGPICS = $(basename $(wildcard *.svg))
PDFs += $(addsuffix .pdf,$(DIAPICS) $(DOTPICS) $(SVGPICS))
EPSs +=	$(addsuffix .eps,$(DIAPICS) $(DOTPICS))

all: $(EPSs)
all: $(PDFs)

clean:
	rm -f $(PNGs) $(EPSs) $(PDFs)

%.pdf: %.svg
	inkscape -D -A $@ $<
%.eps: %.dia
	dia --export $@ $<
%.eps: %.dot
	dot -Teps -o $@ $<
%.pdf: %.eps
	epstopdf $<
