#######################################################################
### Config
#######################################################################

.PRECIOUS: %.hs

# variant order
HMDEMO_LAM_VARIANT_A_VIA_HS					:= 1
HMDEMO_LAM_VARIANT_A_VIA_AG					:= 2
HMDEMO_LAM_VARIANT_ORDER					:= $(HMDEMO_LAM_VARIANT_A_VIA_HS) < $(HMDEMO_LAM_VARIANT_A_VIA_AG)
HMDEMO_LAM_VARIANTS							:= $(HMDEMO_LAM_VARIANT_A_VIA_HS) $(HMDEMO_LAM_VARIANT_A_VIA_AG)

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
HMDEMO_VARIANT_A_AG_SUFF					:= $(HMDEMO_VARIANT_A_SUFF)_$(HMDEMO_LAM_VARIANT_A_VIA_AG)
HMDEMO_VARIANT_A_HS_SUFF					:= $(HMDEMO_VARIANT_A_SUFF)_$(HMDEMO_LAM_VARIANT_A_VIA_HS)
HMDEMO_VARIANT_A_RULERSUFF					:= $(HMDEMO_VARIANT_A_SUFF)_ruler

# this file + other mk files
HMDEMO_LAM_MKF								:= $(patsubst %,$(SRC_HMDEMO_PREFIX)%.mk,files)

# ruler src
HMDEMO_LAM_SRC_BASE							:= Lam
HMDEMO_LAM_SRC_RUL							:= $(addprefix $(SRC_HMDEMO_PREFIX),$(HMDEMO_LAM_SRC_BASE).rul)

# ag src
HMDEMO_LAM_SRC_CAG_A						:= $(addprefix $(SRC_HMDEMO_PREFIX),$(HMDEMO_LAM_SRC_BASE)$(HMDEMO_VARIANT_A_SUFF).cag)

# derived for tex usage
HMDEMO_LAM_RUL_DRV_LTEX						:= $(patsubst $(SRC_HMDEMO_PREFIX)%.rul,$(TEXT_TMP_VARIANT_PREFIX)%.ltex,$(HMDEMO_LAM_SRC_RUL))
HMDEMO_LAM_RUL_DRV_TEX						:= $(HMDEMO_LAM_RUL_DRV_LTEX:.ltex=.tex)

# derived for executable, variant A, ruler part
HMDEMO_LAM_RUL_DRV_A_CAGR					:= $(patsubst $(SRC_HMDEMO_PREFIX)%.rul,$(TEXT_TMP_VARIANT_PREFIX)%$(HMDEMO_VARIANT_A_RULERSUFF).cag,$(HMDEMO_LAM_SRC_RUL))
HMDEMO_LAM_RUL_DRV_A_AGR					:= $(patsubst %.cag,%.ag,$(HMDEMO_LAM_RUL_DRV_A_CAGR))

# derived for executable, variant A, main AG part
HMDEMO_LAM_RUL_DRV_A_AG_AG					:= $(patsubst $(SRC_HMDEMO_PREFIX)%.cag,$(TEXT_TMP_VARIANT_PREFIX)%_$(HMDEMO_LAM_VARIANT_A_VIA_AG).ag,$(HMDEMO_LAM_SRC_CAG_A))
HMDEMO_LAM_RUL_DRV_A_AG_HS					:= $(patsubst %.ag,%.hs,$(HMDEMO_LAM_RUL_DRV_A_AG_AG))
HMDEMO_LAM_RUL_DRV_A_HS_AG					:= $(patsubst $(SRC_HMDEMO_PREFIX)%.cag,$(TEXT_TMP_VARIANT_PREFIX)%_$(HMDEMO_LAM_VARIANT_A_VIA_HS).ag,$(HMDEMO_LAM_SRC_CAG_A))
HMDEMO_LAM_RUL_DRV_A_HS_HS					:= $(patsubst %.ag,%.hs,$(HMDEMO_LAM_RUL_DRV_A_HS_AG))

# all src
HMDEMO_LAM_ALL_SRC							:= $(HMDEMO_LAM_SRC_RUL) $(HMDEMO_LAM_SRC_CAG_A) $(HMDEMO_LAM_MKF)

#######################################################################
### Files: executables
#######################################################################

HMDEMO_A_AG_MAIN							:= Lam$(HMDEMO_VARIANT_A_AG_SUFF)_Main
HMDEMO_A_HS_MAIN							:= Lam$(HMDEMO_VARIANT_A_HS_SUFF)_Main
HMDEMO_A_AG_MAIN_BLD_EXEC					:= $(TEXT_TMP_VARIANT_PREFIX)$(HMDEMO_A_AG_MAIN)$(EXEC_SUFFIX)
HMDEMO_A_HS_MAIN_BLD_EXEC					:= $(TEXT_TMP_VARIANT_PREFIX)$(HMDEMO_A_HS_MAIN)$(EXEC_SUFFIX)
HMDEMO_A_AG_MAIN							:= $(HMDEMO_A_AG_MAIN_BLD_EXEC)
HMDEMO_A_HS_MAIN							:= $(HMDEMO_A_HS_MAIN_BLD_EXEC)

#######################################################################
### Targets for building
#######################################################################

$(HMDEMO_LAM_RUL_DRV_LTEX) : $(TEXT_TMP_VARIANT_PREFIX)%.ltex : $(SRC_HMDEMO_PREFIX)%.rul $(RULER2)
	mkdir -p $(@D)
	$(RULER2) $(RULER2_OPTS) $(TEXT_RULER_DEFS_TEX) --lhs2tex $(TEXT_RULER_MARK_CHANGES_CFG) --base=$(HMDEMO_LAM_SRC_BASE) $< > $@

$(HMDEMO_LAM_RUL_DRV_A_CAGR) : $(TEXT_TMP_VARIANT_PREFIX)%$(HMDEMO_VARIANT_A_RULERSUFF).cag : $(SRC_HMDEMO_PREFIX)%.rul $(RULER2) $(HMDEMO_LAM_MKF)
	mkdir -p $(@D)
	$(RULER2) $(RULER2_OPTS) --ag --wrapshuffle --selrule="(($(HMDEMO_LAM_VARIANT_A_VIA_AG)=A)).(exp.core).(*)" --DATA --ATTR --base=$(HMDEMO_LAM_SRC_BASE) $< > $@

$(HMDEMO_LAM_RUL_DRV_A_AGR) : $(HMDEMO_LAM_RUL_DRV_A_CAGR) $(HMDEMO_LAM_MKF)
	$(SHUFFLE_AG) --variant-order="$(HMDEMO_LAM_VARIANT_ORDER)" --gen-reqm="$(HMDEMO_LAM_VARIANT_A_VIA_AG)" $< > $@

$(HMDEMO_LAM_RUL_DRV_A_AG_AG) : $(HMDEMO_LAM_SRC_CAG_A) $(HMDEMO_LAM_MKF)
	$(SHUFFLE_AG) --variant-order="$(HMDEMO_LAM_VARIANT_ORDER)" --gen-reqm="$(HMDEMO_LAM_VARIANT_A_VIA_AG)" --base=Main $< > $@

$(HMDEMO_LAM_RUL_DRV_A_HS_AG) : $(HMDEMO_LAM_SRC_CAG_A) $(HMDEMO_LAM_MKF)
	$(SHUFFLE_AG) --variant-order="$(HMDEMO_LAM_VARIANT_ORDER)" --gen-reqm="$(HMDEMO_LAM_VARIANT_A_VIA_HS)" --base=Main $< > $@

$(HMDEMO_LAM_RUL_DRV_A_AG_HS) : $(HMDEMO_LAM_RUL_DRV_A_AG_AG) $(HMDEMO_LAM_RUL_DRV_A_AGR) $(HMDEMO_LAM_MKF)
	$(AGC) -P$(TEXT_TMP_VARIANT_PREFIX) -a --aoag -o $@ $<

$(HMDEMO_LAM_RUL_DRV_A_HS_HS) : $(HMDEMO_LAM_RUL_DRV_A_HS_AG) $(HMDEMO_LAM_MKF)
	$(AGC) -P$(TEXT_TMP_VARIANT_PREFIX) -a -o $@ $<

$(HMDEMO_A_HS_MAIN_BLD_EXEC) : $(HMDEMO_LAM_RUL_DRV_A_HS_HS)
	$(GHC) -XTypeSynonymInstances -XFlexibleInstances -XMultiParamTypeClasses -XFlexibleContexts -XScopedTypeVariables --make $< -o $@

$(HMDEMO_A_AG_MAIN_BLD_EXEC) : $(HMDEMO_LAM_RUL_DRV_A_AG_HS)
	$(GHC) -XTypeSynonymInstances -XFlexibleInstances -XMultiParamTypeClasses -XFlexibleContexts --make $< -o $@
