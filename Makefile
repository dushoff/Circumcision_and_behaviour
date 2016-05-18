::# Circumcision_and_behaviour
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: mediaQuants.summary.output 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

datadir:
	/bin/ln -s ~/Dropbox/MC\ \(1\)/MC\ DHS\ data/ $@

cribdir:
	/bin/ln -s /home/dushoff/Dropbox/Downloads/MC/WorkingWiki-export/MC_risk_Africa// $@

ww.mk: cribdir
	cat cribdir/Makefile > $@
	cat cribdir/*.mk >> $@

##################################################################

## Content

Sources += $(wildcard *.R)


### Data sets
sets = ke4 ke5 ls4 ls6 mw4 mw6 mz4 mz6 tz4 tz6 ug5 ug6 zw5 zw6


######################################################################

### Selecting
select=$(sets:%=%.select.Rout)

Sources += select.csv

## wselect.R needs to be moved to a general place
$(select): %.select.Rout: datadir/%.men.RData select.csv wselect.R
	$(run-R)

select.output: $(sets:%=%.select.Routput)
	cat $^ > $@

### Recoding
Sources += $(wildcard *.ccsv *.tsv)

Sources += mccut.csv
.PRECIOUS: %.recode.Rout
%.recode.Rout: %.select.Rout recodeFuns.Rout religion_basic.ccsv partnership_basic.ccsv mccut.csv recode.R
	$(run-R)

recodes.output: $(sets:%=%.recode.Routput)
	cat $^ > $@

recodes.summary.output: $(sets:%=%.recode.summary.Routput)
	cat $^ > $@

######################################################################

%.knowledgeQual.Rout: %.recode.Rout knowledge.R qual.R
	$(run-R)

knowledgeQuals.output: $(sets:%=%.knowledgeQual.Routput)
	cat $^ > $@

knowledgeQuals.objects.output: $(sets:%=%.knowledgeQual.objects.Routput)
	cat $^ > $@

knowledgeQuals.summary.output: $(sets:%=%.knowledgeQual.summary.Routput)
	cat $^ > $@

%.mediaQual.Rout: %.recode.Rout media.R qual.R
	$(run-R)

mediaQuals.output: $(sets:%=%.mediaQual.Routput)
	cat $^ > $@

mediaQuals.objects.output: $(sets:%=%.mediaQual.objects.Routput)
	cat $^ > $@

mediaQuals.summary.output: $(sets:%=%.mediaQual.summary.Routput)
	cat $^ > $@


%.knowledgeQuant.Rout: %.knowledgeQual.Rout levelcodes_knowledge.tsv quant.R
	$(run-R)

knowledgeQuants.output: $(sets:%=%.knowledgeQuant.Routput)
	cat $^ > $@

knowledgeQuants.objects.output: $(sets:%=%.knowledgeQuant.objects.Routput)
	cat $^ > $@

knowledgeQuants.summary.output: $(sets:%=%.knowledgeQuant.summary.Routput)
	cat $^ > $@

%.mediaQuant.Rout: %.mediaQual.Rout levelcodes_media.tsv quant.R
	$(run-R)

mediaQuants.output: $(sets:%=%.mediaQuant.Routput)
	cat $^ > $@

mediaQuants.objects.output: $(sets:%=%.mediaQuant.objects.Routput)
	cat $^ > $@

mediaQuants.summary.output: $(sets:%=%.mediaQuant.summary.Routput)
	cat $^ > $@

## Crib 

%.tsv %.ccsv %.csv %.R: 
	$(CP) cribdir/$@ .

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
