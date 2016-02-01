# location of figs src
FIGS_SRC_PREFIX				:= $(UHCDOC_TOP_PREFIX)figs/
FIGS_SRC_SUBDIRS_PREFIX		:= $(patsubst %,$(FIGS_SRC_PREFIX)%/,hs09-uhcarch flops2016-keynote)

# this file
FIGS_MKF					:= $(FIGS_SRC_PREFIX)files.mk

# figures
ifeq ($(TEXT_CFG_FIGS_INCLUDES_PPD_SRC),yes)
FIGS_PPD_SRC_PPD			:= $(wildcard $(addsuffix *.ppd,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))
else
FIGS_PPD_SRC_PPD			:= 
endif

ifeq ($(TEXT_CFG_FIGS_INCLUDES_XFIG_SRC),yes)
FIGS_XFIG_SRC_FIG			:= $(wildcard $(addsuffix *.fig,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))
else
FIGS_XFIG_SRC_FIG			:= 
endif

FIGS_EPS_SRC_EPS			:= $(wildcard $(FIGS_SRC_PREFIX)*.eps)

ifeq ($(TEXT_CFG_FIGS_INCLUDES_DOT_SRC),yes)
FIGS_DOT_SRC_DOT			:= $(wildcard $(addsuffix *.dot,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))
else
FIGS_DOT_SRC_DOT			:= 
endif

FIGS_ASIS_SRC_PDF			:= $(wildcard $(addsuffix *.pdf,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))
FIGS_ASIS_SRC_JPG			:= $(wildcard $(addsuffix *.jpg,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))
FIGS_ASIS_SRC_PNG			:= $(wildcard $(addsuffix *.png,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))
FIGS_ASIS_SRC_EPS			:= # $(wildcard $(addsuffix *.eps,$(FIGS_SRC_PREFIX) $(FIGS_SRC_SUBDIRS_PREFIX)))

# exclude from pdf generation (because containing special chars)
FIGS_XFIG_SRC_FIG_NOPDF		:= $(filter-out $(patsubst %,$(FIGS_SRC_PREFIX)%.fig,type-lattice let-I2-flow roadmap),$(FIGS_XFIG_SRC_FIG))

# all src
FIGS_ASIS_SRC				:= $(FIGS_ASIS_SRC_PDF) $(FIGS_ASIS_SRC_JPG) $(FIGS_ASIS_SRC_EPS) $(FIGS_ASIS_SRC_PNG)
FIGS_ALL_SRC				:= $(FIGS_XFIG_SRC_FIG) $(FIGS_EPS_SRC_EPS) $(FIGS_ASIS_SRC) $(FIGS_DOT_SRC_DOT) $(FIGS_PPD_SRC_PPD)

# distribution
FIGS_DIST_FILES				:= $(FIGS_ALL_SRC) $(FIGS_MKF)

# derived
FIGS_PPD_SRC_TIKZ			:= $(patsubst $(FIGS_SRC_PREFIX)%.ppd,$(TEXT_TMP_VARIANT_PREFIX)%.tikz,$(FIGS_PPD_SRC_PPD))
FIGS_XFIG_DRV_TEX			:= $(patsubst $(FIGS_SRC_PREFIX)%.fig,$(TEXT_TMP_VARIANT_PREFIX)%.tex,$(FIGS_XFIG_SRC_FIG))
FIGS_XFIG_DRV_PDF			:= $(patsubst $(FIGS_SRC_PREFIX)%.fig,$(TEXT_TMP_VARIANT_PREFIX)%.pdf,$(FIGS_XFIG_SRC_FIG_NOPDF))
FIGS_ASIS_DRV				:= $(patsubst $(FIGS_SRC_PREFIX)%,$(TEXT_TMP_VARIANT_PREFIX)%,$(FIGS_ASIS_SRC))
FIGS_EPS_DRV_PDF			:= $(patsubst $(FIGS_SRC_PREFIX)%.eps,$(TEXT_TMP_VARIANT_PREFIX)%.pdf,$(FIGS_EPS_SRC_EPS))
FIGS_DOT_DRV_PDF			:= $(patsubst $(FIGS_SRC_PREFIX)%.dot,$(TEXT_TMP_VARIANT_PREFIX)%.pdf,$(FIGS_DOT_SRC_DOT))
FIGS_PDF_DRV_GIF			:= $(patsubst $(FIGS_SRC_PREFIX)%.pdf,$(TEXT_TMP_VARIANT_PREFIX)%.gif,$(FIGS_ASIS_SRC_PDF))
FIGS_ALL_DRV_GIF			:= $(FIGS_PDF_DRV_GIF)

