VARIANTS_PDF  = $(notdir $(wildcard variants/PDF/*))
VARIANTS_MIDI = $(notdir $(wildcard variants/MIDI/*))
VARIANTS_MP3  = $(notdir $(wildcard variants/MP3/*)) # allverses
SHELL         = /bin/bash
LYS           = $(shell ls -1 src/EOG???{,[a-z]}.ly 2> /dev/null) # depend on bash-like expansion
PDFS          = $(foreach v,$(VARIANTS_PDF) ,$(addprefix  PDF/$v/,$(notdir $(LYS:.ly=.pdf ))))
MIDIS         = $(foreach v,$(VARIANTS_MIDI),$(addprefix MIDI/$v/,$(notdir $(LYS:.ly=.midi))))
MP3S          = $(foreach v,$(VARIANTS_MP3) ,$(addprefix  MP3/$v/,$(notdir $(LYS:.ly=.mp3 ))))
TXTS          = $(addprefix TXT/default/,$(notdir $(LYS:.ly=.txt)))

ifneq ($(ONLY),)
LYS = src/EOG$(ONLY).ly
endif

BRANCH := $(notdir $(shell git symbolic-ref HEAD))

TIMIDITY = timidity -a

tolower = $(shell tr 'A-Z' 'a-z' <<<$1)

ifneq ($(DEBUG),1)
LYOPTS += -dno-point-and-click -ddelete-intermediate-files
endif

vpath .ly   src
vpath .midi MIDI
vpath .pdf  PDF
vpath .mp3  MP3

.SUFFIXES:
.SUFFIXES: .ly .ily .pdf .midi .mp3

.DEFAULT_GOAL = all

.PHONY: all pdf midi mp3 index dist zip lyrics preview
all: pdf midi index mp3 zip
pdf: $(PDFS)
midi: $(MIDIS)
mp3: $(MP3S)
#wav: $(WAVS)
lyrics: $(TXTS)
dist: zip
zip: EOG_midi_pdf.zip
preview: $(PDFS)
	open $^

CLOBBERFILES += EOG_midi_pdf.zip
EOG_midi_pdf.zip: $(PDFS) $(MIDIS) README.txt
	zip -u $@ $^

index: index.html
CLEANFILES += index.html
index.html: $(PDFS) $(MIDIS) $(MP3S) $(TXTS)
	scripts/make_index.pl $^ > $@.$$$$ && mv $@.$$$$ $@

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

$(TXTS): TXT/default/%.txt: src/%.ly scripts/getlyrics.pl transforms.map
	@mkdir -p $(dir $@)
	scripts/getlyrics.pl $< 2>> transforms.map > $@.$$$$ && mv $@.$$$$ $@ || rm $@.$$$$

.SECONDEXPANSION:
# TODO rewrite this rule (it's rather roundabout and messy)
$(PDFS:%=deps/%.d) $(MIDIS:%=deps/%.d): deps/%.d: src/$$(notdir $$(basename $$*)).ly
	mkdir -p $(dir $@)
	echo -n '$*: ' > $@
	sed -n '/\include/s#[[:space:]]*\\include[[:space:]]*##p' $< | tr -d '"' | sed 's#^#variants/$(dir $*)#' | tr '\012' ' ' >> $@
	echo >> $@

MP3/%.mp3: MIDI/default/$$(notdir $$*).midi variants/$$(dir $$@)/timidity.cfg
	mkdir -p MP3/$(dir $*)
	$(TIMIDITY) -Ow -c variants/$(dir $@)timidity.cfg $(shell cat variants/$(dir $@)/timidity.cmd 2> /dev/null) -o $(@D)/$(*F).wav $<
	lame $(@D)/$(*F).wav $@
	$(RM) $(@D)/$(*F).wav

CLOBBERFILES += $(PDFS) $(MIDIS) $(MP3S)
PDF/%.pdf MIDI/%.midi: src/$$(notdir $$*).ly
	mkdir -p PDF/$(dir $*) MIDI/$(dir $*)
	lilypond $(LYOPTS) --include=$(PWD)/variants/$(dir $@) --pdf --output=$(dir $@)$(notdir $*) $<
	-mv $(dir $@)$(notdir $*).pdf  PDF/$(dir $*)
	-mv $(dir $@)$(notdir $*).midi MIDI/$(dir $*)

