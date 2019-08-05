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

SRC_MERGED=monarch-pre.owl

$(SRC_MERGED): $(SRC)
	owltools $(USECAT) $< --merge-imports-closure --remove-axioms -t DisjointClasses --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange -t DisjointUnion -o $@

$(ONT)-full.owl: $(SRC_MERGED) $(OTHER_SRC)
	$(ROBOT) reason --input $(SRC_MERGED) --reasoner ELK --equivalent-classes-allowed all \
		relax \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

$(ONT)-simple.owl: $(SRC_MERGED) $(OTHER_SRC) $(SIMPLESEED)
	$(ROBOT) reason --input $(SRC_MERGED) --reasoner ELK --equivalent-classes-allowed all \
		relax \
		remove --axioms equivalent \
		relax \
		filter --term-file $(SIMPLESEED) --select "annotations ontology anonymous self" --trim true --signature true \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

reports/%-obo-report.tsv: %
	$(ROBOT) -vvv report -i $< --fail-on $(REPORT_FAIL_ON) -o $@