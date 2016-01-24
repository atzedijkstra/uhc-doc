#!/usr/bin/make -f

.PHONY: ehcs dist www www-sync install lib src build ruler1

###########################################################################################
# Location from which make is invoked
###########################################################################################

UHCDOC_TOP_PREFIX		:= 

###########################################################################################
# First (default) target just explains what can be done
###########################################################################################

default: help
#default: 99/ehclib
help: explanation

###########################################################################################
# Definitions, dependencies, rules, etc: spread over subdirectories for subproducts
###########################################################################################

# do not change the order of these includes
-include latex/files.mk
-include lhs2TeX/files.mk

include mk/config.mk
include $(UHC_TOP_PREFIX)mk/config.mk

### BEGIN of Ruler1
# This definitely should not remain here....!!!!
# Ruler1, will be obsolete until all type rules are specified with Ruler2 (currently not in Explicit/implicit story)
RULER1				:= bin/ruler1$(EXEC_SUFFIX)
RULER1_DIR			:= ruler1
RULER1_MAIN			:= Ruler
RULER1_AG			:= $(RULER1_MAIN).ag
RULER1_HS			:= $(RULER1_AG:.ag=.hs)
RULER1_DERIV		:= $(RULER1_DIR)/$(RULER1_HS)

RULER1_SRC			:= $(RULER1_DIR)/$(RULER1_AG)

ruler1: $(RULER1)

$(RULER1): $(RULER1_DIR)/$(RULER1_AG) $(LIB_EH_UTIL_INS_FLAG)
	cd $(RULER1_DIR) && \
	$(AGC) -csdfr --module=Main `basename $<` && \
	$(GHC) -XFlexibleContexts --make $(GHC_OPTS) $(RULER1_HS) -o ../$@ && \
	$(STRIP) ../$@
### END of Ruler1

include src/files.mk
include $(UHC_TOP_PREFIX)src/files.mk
include $(UHCRULES_TOP_PREFIX)src/files.mk
include $(UHC_SRC_PREFIX)ehc/shared.mk
#include $(MK_PREFIX)functions.mk
include $(UHCDOC_MK_PREFIX)shared.mk

#include $(SRC_PREFIX)libutil/files.mk
include $(UHCDOC_SRC_PREFIX)text2text/files.mk
#include $(SRC_PREFIX)ruler2/files.mk
include $(UHC_SRC_PREFIX)ehc/variant.mk
#include $(SRC_PREFIX)gen/files.mk
include $(UHC_SRC_PREFIX)ehc/files1.mk

#include $(SRC_PREFIX)ehc/files2.mk
include figs/files.mk
include text/files1.mk
include text/files-variants.mk
include $(wildcard text/files1-*.mk)
include text/files2.mk
include text/files-targets.mk
include $(wildcard text/files2-*.mk)
include www/files.mk

###########################################################################################
# Target: explain what can be done
###########################################################################################

explanation:
	@$(EXIT_IF_ABSENT_LIB_OR_TOOL)
	@echo  "Documentation" ; \
	echo  "=============" ; \
	echo  "make help                : print this help" ; \
	echo  "make www                 : make www documentation: $(TEXT_WWW_DOC_PDFS)" ; \
	echo  "make www-sync            : install www documentation in the EHC web (http://www.cs.uu.nl/wiki/Ehc/WebHome)" ; \
	echo  "" ; \
	echo  "make doc/<d>.pdf         : make (public) documentation <d> (where <d> in {$(TEXT_PUB_VARIANTS)})," ; \
	echo  "                           or (non-public): <d> in {$(TEXT_PRIV_VARIANTS)}" ; \
	echo  "                           or (doc): <d> in {$(TEXT_DOCLTX_VARIANTS)}" ; \
	echo  "                           only if text src available, otherwise already generated" ; \
	echo  "" ; \
    echo  "Cleaning up" ; \
	echo  "===========" ; \
	echo  "make clean               : cleanup all variants + internal libraries and tools" ; \
	echo  "" ; \

###########################################################################################
# Target: make every variant of something
###########################################################################################

docs: $(TEXT_DIST_DOC_FILES)

#cleans: $(patsubst %,%/clean,$(EHC_VARIANTS))

###########################################################################################
# Target: www stuff + sync to www. The full content of www is copied, including releases
###########################################################################################

# www: $(WWW_SRC_TGZ) www-ex $(WWW_DOC_FILES)
www: $(WWW_DOC_FILES)

# www/DoneSyncStamp: www-ex
www/DoneSyncStamp: www
	(date "+%G%m%d %H:%M") > www/DoneSyncStamp ; \
	chmod 664 www/* ; \
	rsync --progress -azv -e ssh www/* dijks106@csstaff.science.uu.nl:/users/www/groups/ST/Projects/ehc

www-sync: www/DoneSyncStamp

###########################################################################################
# Target: clean build stuff
###########################################################################################

clean:
	$(MAKE) cleans
	rm -rf $(DIST_PREFIX)

#	$(MAKE) libutil-clean

#	@echo "NOTE: all but external libraries (gmp, ...) is cleaned. Use 'make clean-extlibs' for cleaning those."

###########################################################################################
# Target: try outs and debugging of make variable definitions
###########################################################################################

FUN_PREFIX2DIR			= $(patsubst %/,%,$(1))

tst:
	@echo $(EHC_ALL_LIB_FROMAG_HS)

tstv:
	$(MAKE) INCLUDE_DERIVED_MK=yes EHC_VARIANT=100 tst

###########################################################################################
# Target: obsolete or to become so
###########################################################################################

#: afp-full ehcs doc grinis
#	$(MAKE) initial-test-expect

rules2.tex: rules2.rul
	$(RULER1) -l --base=rules $< | $(LHS2TEX) $(LHS2TEX_OPTS_POLY) > $@

A_EH_TEST			:= $(word 1,$(wildcard test/*.eh))
A_EH_TEST_EXP		:= $(addsuffix .exp$(VERSION_FIRST),$(A_EH_TEST))

$(A_EH_TEST_EXP): $(A_EH_TEST)
	$(MAKE) test-expect

initial-test-expect: $(A_EH_TEST_EXP)

WWW_EXAMPLES_TMPL			:=	www/ehc-examples-templ.html
WWW_EXAMPLES_HTML			:=	www/ehc-examples.html

www-ex: $(WWW_EXAMPLES_HTML)

$(WWW_EXAMPLES_HTML): $(WWW_EXAMPLES_TMPL)
	$(call PERL_SUBST_EHC,$(WWW_EXAMPLES_TMPL),$(WWW_EXAMPLES_HTML))

$(WWW_SRC_TGZ): $(DIST_TGZ)
	cp $^ $@

