# All rules are subject to SECONDEXPANSION
.SECONDEXPANSION:

# Dependencies: lilypond, mp3info2, MP3::Tag (for mp3info2), id3v2, midish, zip, fluidsynth, lame
VARIANTS_PDF  = $(notdir $(wildcard variants/PDF/*))
VARIANTS_MIDI = $(notdir $(wildcard variants/MIDI/*))
VARIANTS_MP3  = $(notdir $(wildcard variants/MP3/*)) # allverses
SHELL         = /bin/sh # depend on POSIX shell, at least
LYS           = $(notdir $(wildcard src/EOG???.ly))
PDFS          = $(foreach v,$(VARIANTS_PDF) ,$(addprefix  PDF/$v/,$(LYS:.ly=.pdf )))
MIDIS         = $(foreach v,$(VARIANTS_MIDI),$(addprefix MIDI/$v/,$(LYS:.ly=.midi)))
MP3S          = $(foreach v,$(VARIANTS_MP3) ,$(addprefix  MP3/$v/,$(LYS:.ly=.mp3 )))
LYRICAL_MP3S  = $(foreach v,$(VARIANTS_MP3) ,$(addprefix  MP3/$v/,$(STD_LYS:.ly=.mp3)))
ADDL_MP3S     = $(foreach v,$(VARIANTS_MP3) ,$(addprefix  MP3/$v/,$(ADDL_LYS:.ly=.mp3)))
WAVS          = $(foreach v,$(VARIANTS_MP3) ,$(addprefix  WAV/$v/,$(LYS:.ly=.wav )))
TXTS          = $(patsubst %.ly,TXT/default/%.txt,$(STD_LYS))
LATINS        = $(TXTS:TXT/default/%=TXT/latinized/%)
M3US          = $(VARIANTS_MP3:%=%.m3u)
ADDL_LYS      = $(filter EOGa%.ly,$(LYS))
STD_LYS       = $(filter-out EOGa%.ly,$(LYS))

HEADERS       = hymnnumber title poet composer meter tunename

WEB_BASE = http://purl.org/echoesofgrace/
ENCODING_PERSON = Darren Kulp <darren@kulp.ch>
BOOK_NAME = Echoes of Grace
PRIMARY_FILE_COUNT = 379
TOTAL_FILE_COUNT = 387
TOTAL_PAGE_COUNT = 343

LILYPOND ?= lilypond

space :=#
space +=#
comma :=,
HEADER_BRACES = {$(subst $(space),$(comma),$(HEADERS))}

LYOPTS += --header=$(HEADER_BRACES)
LYOPTS += --loglevel=WARNING

ifneq ($(DEBUG),)
LYOPTS += --loglevel=DEBUG
endif

ifneq ($(DEBUG),1)
LYOPTS += --define-default=no-point-and-click --define-default=delete-intermediate-files
endif

# Inhibit inappropriate default suffix rules to simplify debugging
.SUFFIXES:

.DEFAULT_GOAL = all

.PHONY: all pdf midi mp3 m3u index dist zip lyrics preview latin
all: pdf midi lyrics index mp3 m3u
pdf: $(PDFS)
midi: $(MIDIS)
mp3: $(MP3S)
m3u: $(M3US)
# WAVs are not made unless requested, since the output files are large
wav: $(WAVS)
# WAVs are deleted by default when made only to produce MP3s
.INTERMEDIATE: $(WAVS)
lyrics: $(TXTS)
dist: zip
zip: EOG_midi_pdf.zip
preview: $(PDFS)
	open $^

CLOBBERFILES += $(M3US)
$(M3US): %.m3u: $(LYS:%.ly=MP3/$$*/%.mp3)
	echo '#EXTM3U' > $@
	mp3info2 -p "#EXTINF:%s,%a - %{TIT2}\n%{d1}/%{d0}/%f\n\n" $^ 2> /dev/null >> $@

CLOBBERFILES += EOG_midi_pdf.zip
EOG_midi_pdf.zip: $(PDFS) $(MIDIS) README.txt
	zip -u $@ $^

# Explicitly build `vanilla` MIDI files for index, since they are automatically
# picked up by the perl script, whereas they are only built as a side-effect of
# MP3 generation in this Makefile.
index: vanilla index.html
CLEANFILES += index.html
index.html: pdf midi mp3 m3u latin
	scripts/make_index.pl > $@ || (rm $@ ; false)

clean:
	$(RM) *.log $(CLEANFILES)

clobber: clean
	$(RM) -r $(CLOBBERFILES)

CLOBBERFILES += deps
ifeq ($(words $(filter clean clobber,$(MAKECMDGOALS))),0)
-include $(PDFS:%=deps/%.d)
-include $(MIDIS:%=deps/%.d)
-include $(MP3S:%=deps/%.d)
endif

CLOBBERFILES += $(TXTS)
# Use an order-only dependency on transforms.map, because we don't update older
# songs with new transforms -- new transforms apply only to new songs. An
# order-only dependency therefore reduces needless rebuilds of older songs.
# The same applies for the lyrics generator script.
$(TXTS): TXT/default/%.txt: src/%.ly | scripts/getlyrics.pl transforms.map
	@mkdir -p $(@D)
	scripts/getlyrics.pl $< 2>> transforms.map > $@ || (rm $@ ; false)

latin: $(LATINS)
CLOBBERFILES += $(LATINS)
TXT/latinized/%.txt: TXT/default/%.txt | TXT/latinized
	scripts/latinize.sh $< > $@ || (rm $@ ; false)

# TODO rewrite this rule (it's rather roundabout and messy)
$(PDFS:%=deps/%.d) $(MIDIS:%=deps/%.d): deps/%.d: src/$$(basename $$(*F)).ly
	@mkdir -p $(@D)
	@echo '$*: \\' > $@
	@sed -n '/\include/s#[[:space:]]*\\include[[:space:]]*##p' $< | tr -d '"' | sed 's#^#variants/$(*D)/#' | tr '\n' ' ' >> $@
	@echo >> $@

# We use midish with no explicit settings to filter out program-change events,
# so that our program-change settings to fluidsynth are respected.
vanilla: $(LYS:%.ly=MIDI/vanilla/%.midi)
MIDI/vanilla/%.midi: MIDI/default/%.midi
	mkdir -p $(@D)
	midish -b <<<'import "$<"; export "$@"'
CLOBBERFILES += $(LYS:%.ly=MIDI/vanilla/%.midi)

# I would like to use long (`--` style) options to fluidsynth, but version
# 1.1.6 doesn't seem to understand them, even though its help summary indicates
# it should.
WAV/%.wav: MIDI/vanilla/$$(*F).midi
	mkdir -p $(@D)
	fluidsynth -F $@ -T wav -f variants/MP3/$(*D)/fluid.cfg $<

MP3/%.mp3: hymnnumber = $$(< headers/$(HEADER_BASE).hymnnumber)
$(VARIANTS_MP3:%=MP3/%/EOGa%.mp3): hymnnumber = $$(( $(PRIMARY_FILE_COUNT) + $$(< headers/$(HEADER_BASE).hymnnumber) ))

MP3/%.mp3: HEADER_BASE = $(basename $(*F))
MP3/%.mp3: LAMEOPTS += --id3v2-only
MP3/%.mp3: LAMEOPTS += --tt "$$(./scripts/latinize.sh headers/$(HEADER_BASE).title)"
MP3/%.mp3: LAMEOPTS += --ta "$$(./scripts/latinize.sh headers/$(HEADER_BASE).poet)"
MP3/%.mp3: LAMEOPTS += --tn "$(hymnnumber)/$(TOTAL_FILE_COUNT)"
MP3/%.mp3: LAMEOPTS += --tl '$(BOOK_NAME)'
MP3/%.mp3: LAMEOPTS += --tv TCMP=1 # iTunes compilation flag
MP3/%.mp3: LAMEOPTS += --tv TCOM="$$(./scripts/latinize.sh headers/$(HEADER_BASE).composer)"
MP3/%.mp3: LAMEOPTS += --tv TENC="$(ENCODING_PERSON)"
MP3/%.mp3: LAMEOPTS += --tv TEXT="$$(./scripts/latinize.sh headers/$(HEADER_BASE).poet)"
MP3/%.mp3: LAMEOPTS += --tv TIT3="$$(./scripts/latinize.sh headers/$(HEADER_BASE).tunename)"
MP3/%.mp3: LAMEOPTS += --tv TLAN='English'
MP3/%.mp3: LAMEOPTS += --tv WOAF="$(WEB_BASE)$@"
MP3/%.mp3: LAMEOPTS += --tv WPUB="$(WEB_BASE)"
# depend on text files only for files containing lyrics
$(LYRICAL_MP3S): MP3/%.mp3: WAV/$$(*D)/$$(*F).wav TXT/latinized/$$(basename $$(*F)).txt
	mkdir -p $(@D)
	lame $(LAMEOPTS) $< $@
	id3v2 --USLT "$$(< $(filter %.txt,$^))" $@

$(ADDL_MP3S): MP3/%.mp3: WAV/$$(*D)/$$(*F).wav
	mkdir -p $(@D)
	lame $(LAMEOPTS) $< $@

headers TXT/latinized metrics texels:
	mkdir -p $@

check:
	[[ $$(pdfinfo booklayout/book.pdf | grep Pages: | (read a b ; echo $$b)) = $(TOTAL_PAGE_COUNT) ]]
	!(git grep -n '\b[A-Z][A-Z][a-z]' src/) # check for initial miscapitalization
	perl -ne 'die "$$ARGV\n" if /bold (\d+) .*?words(\w+)/g and $$1 != ord($$2) - ord("A") + 1' src/*.ly
	perl -ne 'next unless ($$written) = /hymnnumber = "(\d+)"/; die $$ARGV if $$written != ($$ARGV =~ /EOGa?(\d+)/)[0]' src/*.ly
	perl -ne 'die $$ARGV if /^(wordsA|Refrain\b).*\{$$/../^}/ and not /\\bar/ and not /stanza/ and not /[{}]$$/ and not /^\s*$$/ and not /^\s*\\Refrain/ and not /^%/' src/*.ly

CLOBBERFILES += metrics/
metrics/%.metrics: PDF/eogsized/%.pdf | metrics
	convert "$<" -trim info:"$@" || (rm $@ ; false)

CLOBBERFILES += texels/
texels/%.texel: PDF/eogsized/%.pdf metrics/%.metrics | texels
	scripts/makebook.pl $< > $@ || (rm $@ ; false)

CLOBBERFILES += booklayout/book.tex booklayout/book.aux booklayout/book.log
booklayout/book.tex: booklayout/header.texi booklayout/footer.texi $(LYS:%.ly=metrics/%.metrics) | $(LYS:%.ly=PDF/eogsized/%.pdf)
	cat $(word 1,$^) > $@ || (rm $@ ; false)
	scripts/makebook.pl $| >> $@ || (rm $@ ; false)
	cat $(word 2,$^) >> $@ || (rm $@ ; false)

index.meter: $(PDFS)
	(cd headers ; sed -e '' *.meter | sort | uniq | while read b ; do /bin/echo -n "$$b	" ; grep -l "^$$b$$" *.meter | cut -d. -f1 | tr '\n' ' ' ; echo ; done) > $@ || (rm $@ ; false)

INDICES += $(addprefix booklayout/,metrical.pdf first.pdf gospel.pdf children.pdf)
CLOBBERFILES += $(INDICES)
%.pdf: %.tex
	lualatex --output-directory=$(@D) $<

indices: $(INDICES)
$(INDICES): booklayout/%.pdf: booklayout/%_insert.tex

booklayout/metrical_insert.tex: index.meter
	scripts/sort_meters.pl $< | scripts/make_metrical_index.sh | scripts/format_metrical_index.pl > $@

booklayout/first_insert.tex: $(wildcard src/EOG[0123]*.ly)
booklayout/gospel_insert.tex: $(shell grep -l '%gospel' src/EOG*.ly)
booklayout/children_insert.tex: $(shell grep -l '%children' src/EOG*.ly)
booklayout/first_insert.tex: export USE_REFRAIN=1
booklayout/gospel_insert.tex: export USE_REFRAIN=1
booklayout/children_insert.tex: export USE_REFRAIN=0
booklayout/%_insert.tex:
	scripts/make_alpha_index.pl $^ > $@ || (rm $@ ; false)

book: booklayout/book.pdf $(INDICES)

CLOBBERFILES += $(PDFS) $(WAVS) $(MIDIS) $(MP3S)
CLOBBERFILES += $(LYS:%.ly=headers/%.$(HEADER_BRACES))
PDF/%.pdf MIDI/%.midi: src/$$(*F).ly | headers
	mkdir -p $(@D)
	$(LILYPOND) $(LYOPTS) --include=$(CURDIR)/variants/$(@D) --pdf --output=$(@D)/$(*F) $<
	-mv $(@D)/$(*F).pdf  PDF/$(*D)/
	-mv $(@D)/$(*F).midi MIDI/$(*D)/
	-mv $(@D)/$(basename $(*F)).$(HEADER_BRACES) headers/

