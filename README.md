# uhc-doc
UHC documentation (split off from UHC repo).

# installation
See `make help`.
Some doc only builds when a UHC repo locally is available and its location specified during ./configure --with-uhc-repo-prefix=<...>.
Similarly there is an implicit dependency on Ruler examples, specified via --with-ruler-uhc-examples-repo-prefix.
If not specified, these are assumed to be on the same directory level as this repo.

# working make targets
## FLOPS2016 submission
* flops2016-explimpl

## UHC user documentation
* ehc-user-doc

## Old slides about EHC structure
* slides-ehcstruct-ufmg

## FLOPS2016 keynote (20160219)
* slides-flops2016-keynote: FLOPS2016 keynote, with executables, demo input in src/hmdemo, files prefixed with 't'
    * build/slides-flops2016-keynote/Lam_A_<x>_Main, where <x> `elem` {1,2,3,4}:
        * 1: Haskell impl of running example
        * 2: Ruler + AG
        * 3: pretty printing modification
        * 4: stepwise (only works when library stepwise is installed)
