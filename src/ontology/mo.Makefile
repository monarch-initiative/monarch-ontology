## Customize Makefile settings for mo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)

components/so.owl: .FORCE
	@if [ $(IMP) = true ]; then touch $@ && echo "$@ CURRENTLY EXCLUDED!"; fi
.PRECIOUS: components/so.owl
	
components/ncit.owl: .FORCE
	@if [ $(IMP) = true ]; then touch $@ && echo "$@ CURRENTLY EXCLUDED!"; fi
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
