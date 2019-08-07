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

preprocess_release: all_imports $(OTHER_SRC)
	owltools $(USECAT) $(ONT)-edit.owl --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o monarch-pre.owl
	#$(ROBOT) reason -i monarch-pre.owl --reasoner ELK -D mo-incoherent.owl

reports/%-obo-report.tsv: %
	$(ROBOT) -vv report -i $< --fail-on $(REPORT_FAIL_ON) -o $@
	
odkinfo:
	robot --version