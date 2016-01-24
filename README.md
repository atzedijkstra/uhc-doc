# uhc-doc
UHC documentation (split off from UHC repo).

# installation
See `make help`.
Some doc only builds when a UHC repo locally is available and its location specified during ./configure --with-uhc-repo-prefix=<...>.
Similarly there is an implicit dependency on Ruler examples, specified via --with-ruler-uhc-examples-repo-prefix.
If not specified, these are assumed to be on the same directory level as this repo.

# working make targets (as of 20160103)
* flops2016-explimpl
* ehc-user-doc
