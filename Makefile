### Circumcision_and_behaviour
# https://github.com/dushoff/Circumcision_and_behaviour
# https://github.com/dushoff/Circumcision_and_behaviour/tree/master/git_push

### Hooks 
current: target
-include target.mk

##################################################################

# make files and directories

Sources = Makefile .gitignore sub.mk README.md LICENSE.md notes.md
include sub.mk
# include $(ms)/perl.def
-include $(ms)/repos.def

Sources += dushoff.mk

# Makefile: datadir figdrop overleaf

datadir:
	/bin/ln -s $(Drop)/mc_data_files/ $@

figdrop:
	/bin/ln -s $(Drop)/MC_varlvl $@

overleaf:
	git clone https://git.overleaf.com/6654613kpgmzg $@

##################################################################

Sources += $(wildcard *.R)

### Data sets
sets = ke4 ke7 ls4 ls7 mw4 mw6 mz4 mz6 nm5 nm6 rw5 rw6 tz4 tz6 ug5 ug6 zm5 zm6 zw5 zw6

######################################################################

all: combines.output surveys.Rout condomStatus.Rout

### Selecting

### Recoding
Sources += $(wildcard *.ccsv *.tsv)

Sources += questions.R
.PRECIOUS: %.questions.Rout
ke4.questions.Rout:
%.questions.Rout: datadir/.%.RData questions.R
	$(run-R)

questions.output: $(sets:%=%.questions.Routput)
	cat $^ > $@

Sources += mccut.csv
.PRECIOUS: %.norecode.Rout
%.norecode.Rout: datadir/.%.RData recodeFuns.Rout mccut.csv norecode.R
	$(run-R)

norecodes.output: $(sets:%=%.norecode.Routput) norecode.R
	cat $^ > $@

.PRECIOUS: %.recode.Rout
ke4.recode.Rout:
%.recode.Rout: datadir/.%.RData recodeFuns.Rout religion_basic.ccsv partnership_basic.ccsv mccut.csv recode.R
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


#####################################################################

finalrecode.Rout: surveys.Rout finalrecode.R
	$(run-R)

tables.Rout: finalrecode.Rout tables.R
	$(run-R)

old_tables.Rout: tables.Rout table_funs.R old_tables.R
	$(run-R)

old_table.tex: old_tables.Rout 

old_table.pdf: old_table.tex
	pdflatex old_table.tex

new_tables.Rout: tables.Rout table_funs.R new_tables.R
	$(run-R)

new_table.tex: new_tables.Rout

new_table.pdf: new_table.tex
	pdflatex new_table.tex

######################################################################

## Combine all of the recency surveys

## How do we handle the "typical" problem in effects?

effectTest.Rout: surveys.Rout effectTest.R

effectPlots.Rout: effectTest.Rout effectPlots.R

## Explore a little bit
patterns.Rout: surveys.Rout patterns.R
	$(run-R)

## Make a model (fingers crossed!)
condomStatus.Rout: surveys.Rout condomStatus.R
partnerYearStatus.Rout: surveys.Rout partnerYearStatus.R

## Variable p-values
%_varlvlsum.Rout: %.Rout varlvlsum.R
	$(run-R)


.PRECIOUS: %_isoplots.Rout

condomStatus_isoplots.Rout:
partnerYearStatus_isoplots.Rout:
%_isoplots.Rout: %_varlvlsum.RData ordfuns.R plotFuns.R iso.R
	$(run-R)

## Int plots (status models only)                                               
.PRECIOUS: %_intplots.Rout
condomStatus_intplots.Rout:
partnerYearStatus_isoplots.Rout:
%_intplots.Rout: %.Rout ordfuns.Rout plotFuns.Rout intfuns.Rout intplot.R
	$(run-R)

## Int summaries

condomStatus_int.Rout:
partnerYearStatus_int.Rout:

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
## Need to replace this with rsync stuff!

get_fits:
	cp -f datadir/condom*.Rout .; touch condom*.Rout
	cp datadir/.condom*.RData .
	cp datadir/partner*.Rout .
	cp datadir/.partner*.RData .

######################################################################

## Bibliography

## This file should use bibtex about the same way as the real one and can be used for testing simple stuff
Sources += test.tex

Sources += autorefs
auto.bib: autorefs

Sources += clip.pl
manual.clip.bib: manual.bib clip.pl
	$(PUSH)

Sources += manual.bib auto.rmu original.rmu original.bib

auto.bib: auto.rmu
auto.md: auto.rmu
auto.html: auto.rmu

Sources += small.rmu
small.bib: small.rmu

refs.bib: auto.bib manual.clip.bib
	$(cat)

## http://lalashan.mcmaster.ca/theobio/projects/index.php?title=Special:GetProjectFile&display=download&project=R.bib

######################################################################

## Mess with recency figures

## update_overleaf pushes files from here to the overleaf/ subdirectory, which is linked to the overleaf version of the project.

update_bibs: refs.bib.po auto.html.gp
	cd overleaf && $(MAKE) remotesync
	$(MAKE) sync

#condomStatus_intplots.pdf.po partnerYearStatus_intplots.pdf.po recency_back.pdf.po
update_overleaf: refs.bib.po
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
-include $(ms)/modules.mk

-include $(ms)/flextex.mk
-include $(ms)/bibtex.def

export autorefs = autorefs
-include autorefs/inc.mk

