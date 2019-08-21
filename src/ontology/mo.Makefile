## Customize Makefile settings for mo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)

components/%.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I $(URIBASE)/$*.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/%.owl

components/upheno.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I $(URIBASE)/upheno/metazoa.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/upheno.owl

components/so.owl: .FORCE
	@if [ $(IMP) = true ]; then touch $@; fi
.PRECIOUS: components/so.owl

all_components: components/upheno.owl components/so.owl components/mondo.owl components/eco.owl

monarch-pre.owl:  all_imports all_components
	owltools $(USECAT) $(ONT)-edit.owl --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o $@

monarch-pre-nothing.owl: monarch-pre.owl
	$(ROBOT) remove -i monarch-pre.owl --term owl:Nothing --preserve-structure false -o $@

monarch-inferred.owl: monarch-pre-nothing.owl
	$(ROBOT) reason -i $< --reasoner ELK -o $@

preprocess_release: monarch-inferred.owl

odkinfo:
	robot --version
	
$(ONT)-full.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all \
		relax \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

$(ONT)-simple.owl: $(SRC) $(OTHER_SRC) $(SIMPLESEED)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all \
		relax \
		remove --axioms equivalent \
		relax \
		filter --term-file $(SIMPLESEED) --select "annotations ontology anonymous self" --trim true --signature true \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
# foo-simple-non-classified (edit->relax,reduce,drop imports, drop every axiom which contains an entity outside the "namespaces of interest") <- aka the HPO use case, no reason.
# Should this be the non-classified ontology with the drop foreign axiom filter?
# Consider adding remove --term "http://www.geneontology.org/formats/oboInOwl#hasOBONamespace"

$(ONT)-simple-non-classified.owl: $(SRC) $(OTHER_SRC) $(ONTOLOGYTERMS)
	$(ROBOT) remove --input $< --select imports --trim true \
		remove --axioms equivalent \
		reduce -r ELK \
		filter --select ontology --term-file $(ONTOLOGYTERMS) --trim false \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
