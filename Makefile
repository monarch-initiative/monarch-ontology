OBO=http://purl.obolibrary.org/obo
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)
CACHEDIR= cache

# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring
catalog-v001.xml: monarch.owl
	owltools $< --slurp-import-closure -d $(CACHEDIR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl
