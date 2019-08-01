## Customize Makefile settings for mo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

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
