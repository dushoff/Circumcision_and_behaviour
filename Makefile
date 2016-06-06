::# Circumcision_and_behaviour
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: surveys.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

Sources += dushoff.mk

Makefile: datadir

datadir:
	/bin/ln -s $(MC)/MC\ DHS\ data/ $@

cribdir:
	/bin/ln -s /home/dushoff/Dropbox/Downloads/MC/WorkingWiki-export/MC_risk_Africa// $@

ww.mk: cribdir
	cat cribdir/Makefile > $@
	cat cribdir/*.mk >> $@


##################################################################

# New set import. Carefully

newmen = $(newsets:%=datadir/%.men.RData)

## This did not work until I made it completely implicit, which is insane. 
## Changing back because working version is dangerous
$(newmen):datadir/%.RData: convert_dataset.R
	$(MAKE) datadir/$*.Rout
	cd datadir && /bin/ln -fs .$*.RData $*.RData

# More danger
datadir/%.Rout: convert_dataset.R
	$(run-R)

datadir/rw7.men.Rout: datadir/RWMR70FL.SAV
datadir/ke7.men.Rout: datadir/KEMR70SV/KEMR70FL.SAV
datadir/nm6.men.Rout: datadir/NMMR61SV/NMMR61FL.SAV
datadir/zm5.men.Rout: datadir/ZMMR51SV/ZMMR51FL.SAV
datadir/zm6.men.Rout: datadir/ZMMR61SV/ZMMR61FL.SAV
datadir/nm5.men.Rout: datadir/NMMR51sv/nmmr51fl.sav

##################################################################

## Content

Sources += $(wildcard *.R)


### Data sets
sets = ke4 ke7 ls4 ls6 mw4 mw6 mz4 mz6 nm5 nm6 rw5 rw7 tz4 tz6 ug5 ug6 zm5 zm6 zw5 zw6

newsets = ke7 nm5 nm6 rw7 zm5 zm6

######################################################################

### Selecting
select=$(sets:%=%.select.Rout)


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

.PRECIOUS: %.knowledgeQual.Rout
%.knowledgeQual.Rout: %.recode.Rout knowledge.R qual.R
	$(run-R)

knowledgeQuals.output: $(sets:%=%.knowledgeQual.Routput)
	cat $^ > $@

knowledgeQuals.objects.output: $(sets:%=%.knowledgeQual.objects.Routput)
	cat $^ > $@

knowledgeQuals.summary.output: $(sets:%=%.knowledgeQual.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.mediaQual.Rout
%.mediaQual.Rout: %.recode.Rout media.R qual.R
	$(run-R)

mediaQuals.output: $(sets:%=%.mediaQual.Routput)
	cat $^ > $@

mediaQuals.objects.output: $(sets:%=%.mediaQual.objects.Routput)
	cat $^ > $@

mediaQuals.summary.output: $(sets:%=%.mediaQual.summary.Routput)
	cat $^ > $@


.PRECIOUS: %.knowledgeQuant.Rout
%.knowledgeQuant.Rout: %.knowledgeQual.Rout levelcodes_knowledge.tsv quant.R
	$(run-R)

knowledgeQuants.output: $(sets:%=%.knowledgeQuant.Routput)
	cat $^ > $@

knowledgeQuants.objects.output: $(sets:%=%.knowledgeQuant.objects.Routput)
	cat $^ > $@

knowledgeQuants.summary.output: $(sets:%=%.knowledgeQuant.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.mediaQuant.Rout
%.mediaQuant.Rout: %.mediaQual.Rout levelcodes_media.tsv quant.R
	$(run-R)

mediaQuants.output: $(sets:%=%.mediaQuant.Routput)
	cat $^ > $@

mediaQuants.objects.output: $(sets:%=%.mediaQuant.objects.Routput)
	cat $^ > $@

mediaQuants.summary.output: $(sets:%=%.mediaQuant.summary.Routput)
	cat $^ > $@

######################################################################

## PCA

.PRECIOUS: %.knowledgePCA.Rout
%.knowledgePCA.Rout: %.knowledgeQuant.Rout catPCA.R 
	$(run-R)

knowledgePCAs.output: $(sets:%=%.knowledgePCA.Routput)
	cat $^ > $@

knowledgePCAs.objects.output: $(sets:%=%.knowledgePCA.objects.Routput)
	cat $^ > $@

knowledgePCAs.summary.output: $(sets:%=%.knowledgePCA.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.mediaPCA.Rout
%.mediaPCA.Rout: %.mediaQuant.Rout catPCA.R
	$(run-R)

mediaPCAs.output: $(sets:%=%.mediaPCA.Routput)
	cat $^ > $@

mediaPCAs.objects.output: $(sets:%=%.mediaPCA.objects.Routput)
	cat $^ > $@

mediaPCAs.summary.output: $(sets:%=%.mediaPCA.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.combined.Rout
%.combined.Rout: %.recode.Rout %.knowledgePCA.Rout.envir %.mediaPCA.Rout.envir combinePCA.R
	$(run-R)

combines.output: $(sets:%=%.combined.Routput)
	cat $^ > $@

combines.objects.output: $(sets:%=%.combined.objects.Routput)
	cat $^ > $@

combines.summary.output: $(sets:%=%.combined.summary.Routput)
	cat $^ > $@

######################################################################

## Combine all of the surveys
## We already have a country code, but we need to code surveys as new or old.

surveys.Rout: $(sets:%=%.combined.Rout.envir) surveys.R
	$(run-R)

## Does not work! Does summary not play nicely with plyr?
surveys.summary.Routput: surveys.R

######################################################################

## Explore a little bit
patterns.Rout: surveys.Rout patterns.R
	$(run-R)

## Make a model (fingers crossed!)
condomStatus.Rout: surveys.Rout condomStatus.R

## Crib 

.PRECIOUS: %.tsv %.ccsv %.csv %.R
# %.tsv %.ccsv %.csv %.R: 
	# $(CP) cribdir/$@ .

######################################################################

 
### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
