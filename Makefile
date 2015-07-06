OBO=http://purl.obolibrary.org/obo
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)
CACHEDIR= cache

all: $(CATALOG)

# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring
$(CATALOG): monarch.owl
	owltools $< --slurp-import-closure -d $(CACHEDIR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl

# E.g. vertebrate-catalog.xml
%-catalog.xml: %.owl
	owltools $< --slurp-import-closure -d $(CACHEDIR) -c $@ 

# bundled
%-merged.owl: %.owl $(CATALOG)
	owltools $(USECAT) $< --merge-imports-closure -o $@

# bundled, no constraints
%-merged-nd.owl: %.owl $(CATALOG)
	owltools $(USECAT) $< --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -o $@
