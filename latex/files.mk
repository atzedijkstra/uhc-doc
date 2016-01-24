# location of fmt src
LATEX_SRC_PREFIX	:= $(UHCDOC_TOP_PREFIX)latex/

# this file
LATEX_MKF			:= $(LATEX_SRC_PREFIX)files.mk

# all src
LATEX_ALL_SRC		:= $(wildcard $(LATEX_SRC_PREFIX)*)

# distribution
LATEX_DIST_FILES	:= $(LATEX_ALL_SRC) $(LATEX_MKF)
