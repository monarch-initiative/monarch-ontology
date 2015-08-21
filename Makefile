OBO=http://purl.obolibrary.org/obo
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
##USECAT= --catalog-xml $(CATALOG)
USECAT=
CACHEDIR= cache

TGT=monarch-merged-nd-reasoned

all: $(TGT).owl $(TGT).obo

cat: $(CATALOG) 

# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring
$(CATALOG): monarch.owl
	owltools $< --slurp-import-closure -d $(CACHEDIR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl

# use this to repair individual items in the cache
cache/%.owl:
	wget --no-check-certificate http://$*.owl -O $@

# E.g. vertebrate-catalog.xml
%-catalog.xml: %.owl
	owltools $< --slurp-import-closure -d $(CACHEDIR) -c $@ 

# bundled
%-merged.owl: %.owl 
	owltools $(USECAT) $< --merge-imports-closure -o $@

# bundled, no constraints
%-merged-nd.owl: %.owl
	owltools $(USECAT) $< --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o $@

%-validate.txt: %.owl
	owltools $(USECAT) $< --run-reasoner -r elk -u > $@

%-reasoned.owl: %.owl
	owltools $(USECAT) $< --run-reasoner -r elk --assert-implied --remove-redundant-inferred-super-classes -o $@

%.obo: %.owl
	owltools $< --extract-mingraph --remove-axiom-annotations -o -f obo --no-check $@.tmp && grep -v ^owl-axiom $@.tmp > $@
