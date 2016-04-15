::# Circumcision_and_behaviour
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: add.Rout

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

cribdir:
	/bin/ln -s /home/dushoff/Dropbox/Downloads/MC/WorkingWiki-export/MC_risk_Africa// $@

ww.mk: cribdir
	cat cribdir/Makefile > $@
	cat cribdir/*.mk >> $@

##################################################################

## Content

Sources += $(wildcard *.R)

add.Rout: add.R

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
