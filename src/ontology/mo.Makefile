## Customize Makefile settings for mo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

CATALOG = catalog-v001.xml
USECAT= --catalog-xml $(CATALOG)

components/upheno.owl: .FORCE
	$(ROBOT) merge -I $(URIBASE)/upheno/metazoa.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@

components/mondo.owl: .FORCE
	$(ROBOT) merge -I $(URIBASE)/mondo.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@

components/eco.owl: .FORCE
	$(ROBOT) merge -I $(URIBASE)/eco.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@

components/so.owl: .FORCE
	$(ROBOT) merge -I $(URIBASE)/so.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@

all_components: components/upheno.owl components/mondo.owl components/eco.owl components/so.owl

#echo "skipped all components"

monarch-pre.owl:  all_components all_imports $(OTHER_SRC)
	owltools $(USECAT) $(ONT)-edit.owl --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o $@

monarch-pre-nothing.owl: 
	$(ROBOT) remove -i monarch-pre.owl --term owl:Nothing --preserve-structure false -o $@

monarch-inferred.owl: monarch-pre-nothing.owl
	$(ROBOT) reason -i $< --reasoner ELK -o $@

preprocess_release: monarch-inferred.owl

reports/%-obo-report.tsv: %
	$(ROBOT) -vv report -i $< --fail-on $(REPORT_FAIL_ON) -o $@
	
odkinfo:
	robot --version