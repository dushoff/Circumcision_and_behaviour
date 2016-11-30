### Circumcision_and_behaviour
# https://github.com/dushoff/Circumcision_and_behaviour

### Hooks 
current: target

target pngtarget pdftarget vtarget acrtarget: auto.bib 

##################################################################

# make files and directories

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

Sources += notes.txt

Sources += dushoff.mk

# Makefile: datadir figdrop overleaf

datadir:
	/bin/ln -s $(Drop)/MC/MC\ DHS\ data/ $@

figdrop:
	/bin/ln -s $(Drop)/MC_varlvl $@

overleaf:
	git clone https://git.overleaf.com/6654613kpgmzg $@


##################################################################

# New set import. Carefully

newmen = $(newsets:%=datadir/%.men.RData)

######################################################################

## You need to uncomment these rules to import new data sets, apparently

## This did not work until I made it completely implicit, which is insane. 
## Changing back because working version is dangerous
# datadir/%.RData: convert_dataset.R
# 	$(MAKE) datadir/$*.Rout
# 	cd datadir && /bin/ln -fs .$*.RData $*.RData

# More danger
# datadir/%.Rout: convert_dataset.R
# 	$(run-R)

######################################################################

datadir/rw7.men.Rout: datadir/RWMR70FL.SAV
datadir/ls7.men.Rout: datadir/LSMR71SV/LSMR71FL.SAV
datadir/ke7.men.Rout: datadir/KEMR70SV/KEMR70FL.SAV
datadir/nm6.men.Rout: datadir/NMMR61SV/NMMR61FL.SAV
datadir/zm5.men.Rout: datadir/ZMMR51SV/ZMMR51FL.SAV
datadir/zm6.men.Rout: datadir/ZMMR61SV/ZMMR61FL.SAV
datadir/nm5.men.Rout: datadir/NMMR51sv/nmmr51fl.sav

##################################################################

Sources += $(wildcard *.R)

### Data sets
sets = ke4 ke7 ls4 ls7 mw4 mw6 mz4 mz6 nm5 nm6 rw5 rw7 tz4 tz6 ug5 ug6 zm5 zm6 zw5 zw6

newsets = ke7 ls7 nm5 nm6 rw7 zm5 zm6

######################################################################

all: select.output combines.output surveys.Rout condomStatus.Rout

### Selecting
select=$(sets:%=%.select.Rout)

Sources += select.csv
## wselect.R needs to be moved to a general place
$(select): %.select.Rout: datadir/%.men.RData select.csv wselect.R
	$(run-R)

select.output: $(sets:%=%.select.Routput)
	cat $^ > $@
select.objects.output: $(sets:%=%.select.objects.Routput)
	cat $^ > $@

select.summary.output: $(sets:%=%.select.summary.Routput)
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

## How do we handle the "typical" problem in effects?

effectTest.Rout: surveys.Rout effectTest.R

effectPlots.Rout: effectTest.Rout effectPlots.R

## Explore a little bit
patterns.Rout: surveys.Rout patterns.R
	$(run-R)

## Make a model (fingers crossed!)
condomStatus.Rout: surveys.Rout condomStatus.R
partnerYearStatus.Rout: surveys.Rout partnerYearStatus.R
condomRecency.Rout: surveys.Rout condomRecency.R
partnerYearRecency.Rout: surveys.Rout partnerYearRecency.R
partnerLifeRecency.Rout: surveys.Rout partnerLifeRecency.R

## Variable p-values
%_varlvlsum.Rout: %.Rout varlvlsum.R
	$(run-R)

##shortcut 

.PRECIOUS: %_load.Rout
%_load.Rout: MC_varlvl/.%_varlvlsum.RData load.R
	$(run-R)

.PRECIOUS: %_isoplots.Rout
%_isoplots.Rout: %_load.Rout ordfuns.R plotFuns.R iso.R
	$(run-R)

## Int plots (status models only)                                               
.PRECIOUS: %_intplots.Rout
%_intplots.Rout: %.Rout ordfuns.Rout plotFuns.Rout intfuns.Rout intplot.R
	$(run-R)

## Iso plots
#%_isoplots.Rout: %_varlvlsum.Rout ordfuns.R plotFuns.R iso.R
	#$(run-R)

## Int plots (status models only)

#%_intplots.Rout: #_varlvlsum.Rout ordfuns.R plotFuns.R intfuns.R intplot.R
	#$(run-R) 

## Interaction coeff (status models only)

.PRECIOUS: %_int.Rout
%_int.Rout: %_intplots.Rout ordfuns.Rout effectSize.R
	$(run-R)

## MC Cat plots (recency models only)

.PRECIOUS: %_MCcat.Rout
%_MCcat.Rout: %_load.Rout ordfuns.R plotFuns.R iso.R MCcat.R
	$(run-R)

#%_MCcat.Rout: %_varlvlsum.Rout ordfuns.R plotFuns.R iso.R MCcat.R
	#$(run-R)

## Crib 

.PRECIOUS: %.tsv %.ccsv %.csv %.R
# %.tsv %.ccsv %.csv %.R: 
	# $(CP) cribdir/$@ .

######################################################################

## Importing (without wasting Chyun's time)

get_fits:
	cp -f datadir/condom*.Rout .; touch condom*.Rout
	cp datadir/.condom*.RData .
	cp datadir/partner*.Rout .
	cp datadir/.partner*.RData .

######################################################################

## Manuscript stuff should all be in overleaf/ now




######################################################################

## Bibliography

## This file should use bibtex about the same way as the real one and can be used for testing simple stuff
Sources += test.tex

auto.bib: autorefs

Sources += clip.pl
manual.clip.bib: manual.bib clip.pl
	$(PUSH)

auto.bib: auto.rmu
auto.md: auto.rmu
auto.html: auto.rmu

Sources += manual.bib auto.rmu original.rmu original.bib
refs.bib: auto.bib manual.clip.bib
	$(cat)

## http://lalashan.mcmaster.ca/theobio/projects/index.php?title=Special:GetProjectFile&display=download&project=R.bib

######################################################################

## Mess with recency figures

## update_overleaf pushes files from here to the overleaf/ subdirectory, which is linked to the overleaf version of the project.
update_overleaf: refs.bib.po condomStatus_intplots.pdf.po partnerYearStatus_intplots.pdf.po recency_back.pdf.po
%.po: %
	$(CPF) $< overleaf/

overleaf_files += recency_back.pdf
recency_back.pdf: condomRecency_MCcat-1.pdf partnerLifeRecency_MCcat-1.pdf partnerYearRecency_MCcat-1.pdf
	pdfjam -o $@ --nup 3x1 --landscape $(filter-out Makefile, $^)

recency_figs = condomRecency_MCcat-0.pdf partnerLifeRecency_MCcat-0.pdf partnerYearRecency_MCcat-0.pdf 
overleaf_files += $(recency_figs)

# --papersize '{10cm,20cm}' 

######################################################################

## To connect a file made here to overleaf, add it to the update_overleaf list

overleaf_files += refs.bib condomStatus_intplots.pdf 

update_overleaf: $(overleaf_files) $(overleaf_files:%=%.po)

%.po: %
	$(CPF) $< overleaf/
	touch $@

%.pdf: figdrop/%.pdf
	cp $< $@

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/pandoc.mk

-include $(ms)/wrapR.mk
-include $(ms)/linkdirs.mk

-include $(ms)/flextex.mk
-include $(ms)/bibtex.def

export autorefs = autorefs
-include autorefs/inc.mk

