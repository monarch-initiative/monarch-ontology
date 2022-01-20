OBO=http://purl.obolibrary.org/obo
ONTBASE=$(OBO)/monarch
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)
#USECAT=
CACHEDIR= cache
OT_MEMO=50G
OWLTOOLS=OWLTOOLS_MEMORY=$(OT_MEMO) owltools --no-logging
ROBOT=robot

all: build/monarch-ontology-final.json build/monarch-ontology-final.owl build/monarch-ontology-seed-dipper.txt build/monarch-ontology-seed.txt

#cat: $(CATALOG) 

# See: https://github.com/owlcollab/owltools/wiki/Import-Chain-Mirroring
#$(CATALOG): monarch.owl 
#	$(OWLTOOLS) $< --slurp-import-closure -d $(CACHEDIR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl

# use this to repair individual items in the cache
#cache/%.owl:
#	wget --no-check-certificate http://$*.owl -O $@

# E.g. vertebrate-catalog.xml
#%-catalog.xml: %.owl
#	$(OWLTOOLS) $< --slurp-import-closure -d $(CACHEDIR) -c $@ 

# bundled, no constraints
%-merged-nd.owl: %.owl
	$(OWLTOOLS) $< --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o $@

%-reasoned.owl: %.owl
	$(OWLTOOLS) $< --run-reasoner -r elk --assert-implied --remove-redundant-inferred-super-classes -o $@

#%.obo: %.owl
#	$(OWLTOOLS) $< --extract-mingraph --remove-axiom-annotations -o -f obo --no-check $@.tmp && grep -v ^owl-axiom $@.tmp > $@

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
#imports/dc_import.owl:
#	wget https://www.dublincore.org/specifications/dublin-core/dcmi-terms/dublin_core_elements.rdf -O imports/dc_import.owl

#components: imports/dc_import.owl

# 	remove -T config/object-property-seed-sri-translator.txt --select complement --select object-properties --signature true \
#		remove -T config/annotation-property-seed-sri-translator.txt --select complement --select annotation-properties --signature true \

BL_MODEL="https://raw.githubusercontent.com/biolink/biolink-model/master/biolink-model.owl.ttl"

build/bl-model.ttl:
	wget $(BL_MODEL) -O $@

# NOT REDUCING BECAUSE OF PROBLEM WITH SCIGRAPH when faced with
# <owl:Class rdf:about="http://purl.obolibrary.org/obo/UBERON_0002328PHENOTYPE">
#         <owl:equivalentClass>
#             <owl:Restriction>
#                 <owl:onProperty rdf:resource="http://purl.obolibrary.org/obo/UPHENO_0000001"/>
#                 <owl:someValuesFrom rdf:resource="http://purl.obolibrary.org/obo/UBERON_0002328"/>
#             </owl:Restriction>
#         </owl:equivalentClass>
#         <rdfs:subClassOf>
#             <owl:Restriction>
#                 <owl:onProperty rdf:resource="http://purl.obolibrary.org/obo/UPHENO_0000001"/>
#                 <owl:someValuesFrom rdf:resource="http://purl.obolibrary.org/obo/UBERON_0002328"/>
#             </owl:Restriction>
#         </rdfs:subClassOf>
#     </owl:Class>
build/monarch-ontology-final.owl: build/monarch-ontology-dipper.owl build/bl-model.ttl
	robot merge -i build/bl-model.ttl -i build/monarch-ontology-dipper.owl \
		unmerge -i unmerge.owl \
		reason --reasoner ELK \
		reduce \
		reduce --named-classes-only true \
		query --update sparql/bl-categories.ru \
		unmerge -i build/bl-model.ttl \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

#build/bl-categories.ttl: build/bl-model.ttl build/monarch-ontology-sri-translator.owl
#	$(ROBOT) query -i $< --construct sparql/bl-categories.ru -o $@

build/monarch-ontology-final.json: build/monarch-ontology-final.owl
	robot convert -i $< -f json -o $@

#build/%-seed.txt: build/%.owl
#	robot query -i $< --use-graphs true -f tsv --query sparql/terms.sparql $@
	
build/monarch-ontology-seed.txt: build/monarch-ontology-final.owl
	robot query -i $< --use-graphs true -f tsv --query sparql/terms.sparql $@

build/monarch-ontology-seed-dipper.txt: build/monarch-ontology-dipper.owl
	robot query -i $< --use-graphs true -f tsv --query sparql/terms.sparql $@
