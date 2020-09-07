OBO=http://purl.obolibrary.org/obo
ONTBASE=$(OBO)/monarch
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)
#USECAT=
CACHEDIR= cache
OT_MEMO=50G
OWLTOOLS=OWLTOOLS_MEMORY=$(OT_MEMO) owltools --no-logging

TGT=monarch-merged-nd-reasoned

all: $(TGT).owl $(TGT).obo

cat: $(CATALOG) 

# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring
$(CATALOG): monarch.owl 
	$(OWLTOOLS) $< --slurp-import-closure -d $(CACHEDIR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl

# use this to repair individual items in the cache
cache/%.owl:
	wget --no-check-certificate http://$*.owl -O $@

# E.g. vertebrate-catalog.xml
%-catalog.xml: %.owl
	$(OWLTOOLS) $< --slurp-import-closure -d $(CACHEDIR) -c $@ 

# bundled
%-merged.owl: %.owl 
	$(OWLTOOLS) $(USECAT) $< --merge-imports-closure -o $@

# bundled, no constraints
%-merged-nd.owl: %.owl
	$(OWLTOOLS) $(USECAT) $< --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o $@

%-validate.txt: %.owl
	$(OWLTOOLS) $(USECAT) $< --run-reasoner -r elk -u > $@

%-reasoned.owl: %.owl
	$(OWLTOOLS) $(USECAT) $< --run-reasoner -r elk --assert-implied --remove-redundant-inferred-super-classes -o $@

%.obo: %.owl
	$(OWLTOOLS) $< --extract-mingraph --remove-axiom-annotations -o -f obo --no-check $@.tmp && grep -v ^owl-axiom $@.tmp > $@

build/monarch-ontology-dipper.owl: monarch-merged-nd.owl
	$(OWLTOOLS) $< --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@
	# Hack to resolve https://github.com/monarch-initiative/monarch-ontology/issues/16
	# Hack to normalize omim and hgnc IRIs
	sed -i "/owl#ReflexiveProperty/d;\
	   s~http://purl.obolibrary.org/obo/OMIMPS_~http://www.omim.org/phenotypicSeries/PS~;\
	   s~http://purl.obolibrary.org/obo/OMIM_~http://omim.org/entry/~;\
	   s~http://identifiers.org/omim/~http://omim.org/entry/~;\
	   s~http://identifiers.org/hgnc/~https://www.genenames.org/data/gene-symbol-report/#!/hgnc_id/HGNC:~;\
	   s~http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=~https://www.genenames.org/data/gene-symbol-report/#!/hgnc_id/HGNC:~;\
	   s~http://www.informatics.jax.org/marker/MGI:~http://www.informatics.jax.org/accession/MGI:~;\
	   s~http://www.ncbi.nlm.nih.gov/gene/~https://www.ncbi.nlm.nih.gov/gene/~; \
	   s~http://purl.obolibrary.org/obo/MESH_~http://id.nlm.nih.gov/mesh/~" \
	   $@

# necessary because of HTTPS
imports/dc_import.owl:
	wget https://www.dublincore.org/specifications/dublin-core/dcmi-terms/dublin_core_elements.rdf -O imports/dc_import.owl

components: imports/dc_import.owl

build/monarch-ontology-sri-translator.owl: build/monarch-ontology-dipper.owl
	robot merge -i monarch-ontology-dipper.owl \
		remove -T config/object-property-seed-sri-translator.txt --select complement --select object-properties --signature true \
		remove -T config/annotation-property-seed-sri-translator.txt --select complement --select annotation-properties --signature true \
		reason --reasoner ELK \
		relax \
		reduce --reasoner ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

build/monarch-ontology-sri-translator.json: build/monarch-ontology-sri-translator.owl
	robot convert -i $< -f json -o $@

build/%-seed.txt: build/%.owl
	robot query -i $< --use-graphs true -f tsv --query sparql/terms.sparql $@
	
build/monarch-ontology-seed.txt: monarch-merged.owl
	robot query -i $< --use-graphs true -f tsv --query sparql/terms.sparql $@

sri: build/monarch-ontology-seed.txt build/monarch-ontology-sri-translator-seed.txt build/monarch-ontology-sri-translator.json

