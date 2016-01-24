ehc-architecture.pdf: text/architecture/ehc-architecture.tex text/architecture/ehc-architecture2.tex
	cd text/architecture
	pdflatex ehc-architecture


$(UHCDOC_TOP_PREFIX)doc/AbstrInt.pdf: $(TEXT_SRC_PREFIX)AbstrInt.ltex
	lhs2tex -o $(TEXT_TMP_PREFIX)AbstrInt.tex $(TEXT_SRC_PREFIX)AbstrInt.ltex 
	pdflatex -include-directory=$(UHCDOC_TOP_PREFIX)latex -output-directory=$(TEXT_TMP_PREFIX) $(TEXT_TMP_PREFIX)AbstrInt.tex
	cp $(TEXT_TMP_PREFIX)AbstrInt.pdf $(UHCDOC_TOP_PREFIX)doc/AbstrInt.pdf

$(UHCDOC_TOP_PREFIX)doc/gpce10-SpecConst.pdf: $(TEXT_SRC_PREFIX)gpce10-SpecConst.ltex
	lhs2tex -o $(TEXT_TMP_PREFIX)gpce10-SpecConst.tex $(TEXT_SRC_PREFIX)gpce10-SpecConst.ltex 
	pdflatex -include-directory=$(UHCDOC_TOP_PREFIX)latex -output-directory=$(TEXT_TMP_PREFIX) $(TEXT_TMP_PREFIX)gpce10-SpecConst.tex
	cp $(TEXT_TMP_PREFIX)gpce10-SpecConst.pdf $(UHCDOC_TOP_PREFIX)doc/gpce10-SpecConst.pdf

	
