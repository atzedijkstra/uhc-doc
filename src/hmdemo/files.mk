#######################################################################
### Config
#######################################################################

.PRECIOUS: %.hs

#######################################################################
### Locations
#######################################################################

# location of src
SRC_HMDEMO_PREFIX							:= $(UHCDOC_SRC_PREFIX)hmdemo/

#######################################################################
### Files
#######################################################################

# variants
HMDEMO_VARIANT_A							:= A
HMDEMO_VARIANT_A_SUFF						:= _$(HMDEMO_VARIANT_A)
HMDEMO_VARIANT_A_RULERSUFF					:= $(HMDEMO_VARIANT_A_SUFF)_ruler

# this file + other mk files
HMDEMO_LAM_MKF								:= $(patsubst %,$(SRC_HMDEMO_PREFIX)%.mk,files)

# ruler src
HMDEMO_LAM_SRC_BASE							:= Lam
HMDEMO_LAM_SRC_RUL							:= $(addprefix $(SRC_HMDEMO_PREFIX),$(HMDEMO_LAM_SRC_BASE).rul)

# ag src
HMDEMO_LAM_SRC_AG_A							:= $(addprefix $(SRC_HMDEMO_PREFIX),$(HMDEMO_LAM_SRC_BASE)$(HMDEMO_VARIANT_A_SUFF).ag)

# derived for tex usage
HMDEMO_LAM_RUL_DRV_LTEX						:= $(patsubst $(SRC_HMDEMO_PREFIX)%.rul,$(TEXT_TMP_VARIANT_PREFIX)%.ltex,$(HMDEMO_LAM_SRC_RUL))
HMDEMO_LAM_RUL_DRV_TEX						:= $(HMDEMO_LAM_RUL_DRV_LTEX:.ltex=.tex)

# derived for executable, variant A
HMDEMO_LAM_RUL_DRV_A_AGR					:= $(patsubst $(SRC_HMDEMO_PREFIX)%.rul,$(TEXT_TMP_VARIANT_PREFIX)%$(HMDEMO_VARIANT_A_RULERSUFF).ag,$(HMDEMO_LAM_SRC_RUL))
HMDEMO_LAM_RUL_DRV_A_HS						:= $(patsubst $(SRC_HMDEMO_PREFIX)%.ag,$(TEXT_TMP_VARIANT_PREFIX)%.hs,$(HMDEMO_LAM_SRC_AG_A))
#HMDEMO_LAM_RUL_DRV_A_HS						:= $(patsubst %.ag,%.hs,$(HMDEMO_LAM_RUL_DRV_A_AGR))

# all src
HMDEMO_LAM_ALL_SRC							:= $(HMDEMO_LAM_SRC_RUL) $(HMDEMO_LAM_SRC_AG_A) $(HMDEMO_LAM_MKF)

#######################################################################
### Files: executables
#######################################################################

HMDEMO_A_MAIN								:= Lam_A_Main
HMDEMO_A_MAIN_BLD_EXEC						:= $(TEXT_TMP_VARIANT_PREFIX)$(HMDEMO_A_MAIN)$(EXEC_SUFFIX)
HMDEMO_A_MAIN								:= $(HMDEMO_A_MAIN_BLD_EXEC)

#######################################################################
### Targets for building
#######################################################################

$(HMDEMO_LAM_RUL_DRV_LTEX) : $(TEXT_TMP_VARIANT_PREFIX)%.ltex : $(SRC_HMDEMO_PREFIX)%.rul $(RULER2)
	mkdir -p $(@D)
	$(RULER2) $(RULER2_OPTS) $(TEXT_RULER_DEFS_TEX) --lhs2tex $(TEXT_RULER_MARK_CHANGES_CFG) --base=$(HMDEMO_LAM_SRC_BASE) $< > $@

$(HMDEMO_LAM_RUL_DRV_A_AGR) : $(TEXT_TMP_VARIANT_PREFIX)%$(HMDEMO_VARIANT_A_RULERSUFF).ag : $(SRC_HMDEMO_PREFIX)%.rul $(RULER2) $(HMDEMO_LAM_MKF)
	mkdir -p $(@D)
	$(RULER2) $(RULER2_OPTS) --ag --selrule="(A).(exp.core).(*)" --DATA --ATTR --base=$(HMDEMO_LAM_SRC_BASE) $< > $@

# other opts: --copyelim=no --wrapshuffle

$(HMDEMO_LAM_RUL_DRV_A_HS) : $(HMDEMO_LAM_SRC_AG_A) $(HMDEMO_LAM_RUL_DRV_A_AGR) $(HMDEMO_LAM_MKF)
	$(AGC) -P$(TEXT_TMP_VARIANT_PREFIX) -a -o $@ $<

$(HMDEMO_A_MAIN_BLD_EXEC) : $(HMDEMO_LAM_RUL_DRV_A_HS)
	$(GHC) -XTypeSynonymInstances -XFlexibleInstances -XMultiParamTypeClasses -XFlexibleContexts --make $< -o $@
